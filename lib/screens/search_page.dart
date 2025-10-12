import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tantivy_flutter_app/l10n/app_localizations.dart';
import 'package:tantivy_flutter_app/models/document_data.dart';
import 'package:tantivy_flutter_app/services/document_loader_service.dart';
import 'package:tantivy_flutter_app/src/rust/api/search.dart';
import 'package:tantivy_flutter_app/widgets/language_selector.dart';
import 'package:tantivy_flutter_app/widgets/search_result_card.dart';
import 'package:tantivy_flutter_app/widgets/dialogs/add_document_dialog.dart';
import 'package:tantivy_flutter_app/widgets/theme_selector.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> _searchResults = [];
  bool _isIndexInitialized = false;
  bool _isLoading = false;
  String _statusMessage = '';
  int _documentCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeIndex();
  }

  Future<void> _initializeIndex() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Initializing...';
    });

    try {
      final directory = await getApplicationDocumentsDirectory();
      final indexPath = '${directory.path}/tantivy_index';

      debugPrint('인덱스 경로: $indexPath');

      final initResult = initializeSearchIndexWithPath(indexPath: indexPath);
      debugPrint(initResult);

      await _updateDocumentCount();

      if (_documentCount == 0) {
        debugPrint('문서가 없어서 샘플 문서를 추가합니다.');
        final indexResult = indexSampleDocuments();
        debugPrint(indexResult);
        await _updateDocumentCount();
      } else {
        debugPrint('기존 인덱스를 로드했습니다. 문서 수: $_documentCount개');
      }

      setState(() {
        _isIndexInitialized = true;
        _statusMessage = 'Ready! (Path: $indexPath)';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Init failed: $e';
      });
      debugPrint('초기화 오류: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateDocumentCount() async {
    try {
      final count = getDocumentCount();
      setState(() {
        _documentCount = count.toInt();
      });
    } catch (e) {
      debugPrint('문서 개수 조회 실패: $e');
    }
  }

  Future<void> _loadDocumentsFromJson() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isLoading = true;
      _statusMessage = l10n.loadingFromJson;
    });

    try {
      final result = await DocumentLoaderService.loadSampleDocuments();
      await _updateDocumentCount();

      setState(() {
        _statusMessage = result;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _statusMessage = l10n.jsonLoadFailed(e.toString());
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.jsonLoadFailed(e.toString())),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _performSearch() async {
    final l10n = AppLocalizations.of(context)!;

    if (_searchController.text.trim().isEmpty) {
      setState(() {
        _statusMessage = l10n.enterSearchTerm;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = l10n.searching;
    });

    try {
      final results = searchDocuments(
        queryStr: _searchController.text.trim(),
        limit: BigInt.from(10),
      );

      setState(() {
        _searchResults = results;
        _statusMessage = l10n.searchResults(results.length);
      });
    } catch (e) {
      setState(() {
        _statusMessage = l10n.searchFailed(e.toString());
        _searchResults = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAddDocumentDialog() {
    showDialog(
      context: context,
      builder: (context) => AddDocumentDialog(
        onDocumentAdded: () {
          _updateDocumentCount();
        },
      ),
    );
  }

  void _clearAllDocuments() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ 경고'),
        content: const Text('모든 문서를 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('모두 삭제'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final result = clearAllDocuments();
        await _updateDocumentCount();

        setState(() {
          _searchResults = [];
          _statusMessage = '모든 문서가 삭제되었습니다.';
        });

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result)));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('삭제 실패: $e')));
        }
      }
    }
  }

  void _deleteDocument(String id) async {
    final result = deleteDocument(id: id);
    await _updateDocumentCount();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
      _performSearch();
    }
  }

  void _editDocument(SearchResult result) {
    // 간단한 편집 다이얼로그 (기존 코드 유지)
    final titleController = TextEditingController(text: result.title);
    final bodyController = TextEditingController(text: result.body);
    final metadataController = TextEditingController(text: result.metadata);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('문서 수정 (ID: ${result.id.substring(0, 16)}...)'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: '제목'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: bodyController,
                decoration: const InputDecoration(labelText: '내용'),
                maxLines: 5,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: metadataController,
                decoration: const InputDecoration(labelText: 'Metadata (JSON)'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final updateResult = updateDocument(
                  id: result.id,
                  title: titleController.text.trim(),
                  body: bodyController.text.trim(),
                  metadataJson: metadataController.text.trim(),
                );

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(updateResult)));
                  _performSearch();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('수정 실패: $e')));
                }
              }
            },
            child: const Text('수정'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text('🔍 ${l10n.appTitle}'),
        elevation: 2,
        actions: [
          const ThemeSelector(),
          const LanguageSelector(),

          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'add':
                  _showAddDocumentDialog();
                  break;
                case 'load_json':
                  _loadDocumentsFromJson();
                  break;
                case 'clear':
                  _clearAllDocuments();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'add',
                child: Row(
                  children: [
                    const Icon(Icons.add),
                    const SizedBox(width: 8),
                    Text(l10n.addDocument),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'load_json',
                child: Row(
                  children: [
                    Icon(
                      Icons.upload_file,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.loadFromJson,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_forever,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.deleteAll,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              spacing: 8,
              children: [
                const Icon(Icons.description, size: 16),
                Text(l10n.documentCount(_documentCount)),
              ],
            ),
          ),
          // 검색창
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.searchHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchResults = [];
                                _statusMessage = l10n.indexReady;
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabled: _isIndexInitialized && !_isLoading,
                  ),
                  onChanged: (value) => setState(() {}),
                  onSubmitted: (value) => _performSearch(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isIndexInitialized && !_isLoading
                            ? _performSearch
                            : null,
                        icon: const Icon(Icons.search),
                        label: Text(l10n.search),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 상태 메시지
          if (_statusMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isLoading
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    if (_isLoading)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    if (_isLoading) const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _statusMessage,
                        style: TextStyle(
                          color: _isLoading
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // 검색 결과
          Expanded(
            child: _searchResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isIndexInitialized
                              ? l10n.noResults
                              : l10n.indexInitializing,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final result = _searchResults[index];
                      return SearchResultCard(
                        result: result,
                        index: index,
                        onEdit: () => _editDocument(result),
                        onDelete: () => _deleteDocument(result.id),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: _isIndexInitialized
          ? FloatingActionButton.extended(
              onPressed: _showAddDocumentDialog,
              icon: const Icon(Icons.add),
              label: Text(l10n.addDocument),
              tooltip: l10n.addDocument,
            )
          : null,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
