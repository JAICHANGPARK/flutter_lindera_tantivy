import 'package:flutter/material.dart';
import 'package:tantivy_flutter_app/models/document_data.dart';
import 'package:tantivy_flutter_app/services/document_loader_service.dart';
import 'package:tantivy_flutter_app/src/rust/api/search.dart';
import 'package:tantivy_flutter_app/src/rust/frb_generated.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '한국어 검색 시스템',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
      _statusMessage = '검색 인덱스 초기화 중...';
    });

    try {
      // 로컬 저장소 경로 가져오기
      final directory = await getApplicationDocumentsDirectory();
      final indexPath = '${directory.path}/tantivy_index';

      debugPrint('인덱스 경로: $indexPath');

      // 디스크에 인덱스 초기화 (기존 인덱스가 있으면 로드, 없으면 생성)
      final initResult = initializeSearchIndexWithPath(indexPath: indexPath);
      debugPrint(initResult);

      await _updateDocumentCount();

      // 문서가 없으면 샘플 문서 추가
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
        _statusMessage = '준비 완료! 검색어를 입력하세요. (저장 경로: $indexPath)';
      });
    } catch (e) {
      setState(() {
        _statusMessage = '초기화 실패: $e';
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

  /// JSON 파일에서 문서를 로드하는 함수
  Future<void> _loadDocumentsFromJson() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'JSON 파일에서 문서 로드 중...';
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
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'JSON 로드 실패: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('JSON 로드 실패: $e'),
            backgroundColor: Colors.red,
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
    if (_searchController.text.trim().isEmpty) {
      setState(() {
        _statusMessage = '검색어를 입력하세요.';
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = '검색 중...';
    });

    try {
      final results = searchDocuments(
        queryStr: _searchController.text.trim(),
        limit: BigInt.from(10),
      );

      setState(() {
        _searchResults = results;
        _statusMessage = '검색 결과: ${results.length}개';
      });
    } catch (e) {
      setState(() {
        _statusMessage = '검색 실패: $e';
        _searchResults = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAddDocumentDialog() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    final metadataController = TextEditingController(text: '{}');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('문서 추가'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'UUID는 자동으로 생성됩니다',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  hintText: '문서 제목을 입력하세요',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: bodyController,
                decoration: const InputDecoration(
                  labelText: '내용',
                  hintText: '문서 내용을 입력하세요',
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: metadataController,
                decoration: const InputDecoration(
                  labelText: 'Metadata (JSON)',
                  hintText: '{"country": "한국", "city": "서울"}',
                ),
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
              if (titleController.text.trim().isEmpty ||
                  bodyController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('제목과 내용을 입력해주세요')),
                );
                return;
              }

              try {
                final result = addDocument(
                  title: titleController.text.trim(),
                  body: bodyController.text.trim(),
                  metadataJson: metadataController.text.trim(),
                );

                await _updateDocumentCount();

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result)),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('추가 실패: $e')),
                  );
                }
              }
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }

  void _showBulkAddDialog() {
    final TextEditingController bulkController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('여러 문서 추가'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '형식: 제목|내용|{"metadata":"json"} (줄바꿈으로 구분)\n예시:\n베이징공항|베이징 수도 국제공항입니다|{"country":"중국"}\n상하이공항|상하이 푸동 국제공항입니다|{"country":"중국"}',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bulkController,
                decoration: const InputDecoration(
                  labelText: '문서 목록',
                  hintText: '제목|내용|metadata',
                  border: OutlineInputBorder(),
                ),
                maxLines: 10,
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
              final lines = bulkController.text.trim().split('\n');
              final documents = <DocumentInput>[];

              for (final line in lines) {
                if (line.trim().isEmpty) continue;
                final parts = line.split('|');
                if (parts.length < 2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('잘못된 형식: $line')),
                  );
                  return;
                }
                documents.add(DocumentInput(
                  id: '', // UUID 자동 생성
                  title: parts[0].trim(),
                  body: parts[1].trim(),
                  metadata: parts.length > 2 ? parts[2].trim() : '{}',
                ));
              }

              if (documents.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('추가할 문서가 없습니다')),
                );
                return;
              }

              try {
                final result = addDocuments(documents: documents);

                await _updateDocumentCount();

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result)),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('추가 실패: $e')),
                  );
                }
              }
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }

  void _showEditDocumentDialog(SearchResult result) {
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
                decoration: const InputDecoration(
                  labelText: '제목',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: bodyController,
                decoration: const InputDecoration(
                  labelText: '내용',
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: metadataController,
                decoration: const InputDecoration(
                  labelText: 'Metadata (JSON)',
                ),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(updateResult)),
                  );
                  _performSearch(); // 검색 결과 갱신
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('수정 실패: $e')),
                  );
                }
              }
            },
            child: const Text('수정'),
          ),
        ],
      ),
    );
  }

  void _deleteDocument(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('문서 삭제'),
        content: Text('문서 ID "$id"를 삭제하시겠습니까?'),
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
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final result = deleteDocument(id: id);

        await _updateDocumentCount();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result)),
          );
          _performSearch(); // 검색 결과 갱신
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('삭제 실패: $e')),
          );
        }
      }
    }
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('삭제 실패: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔍 한국어 검색 시스템'),
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Chip(
                label: Text('문서: $_documentCount개'),
                avatar: const Icon(Icons.description, size: 16),
              ),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'add':
                  _showAddDocumentDialog();
                  break;
                case 'bulk_add':
                  _showBulkAddDialog();
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
              const PopupMenuItem(
                value: 'add',
                child: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('문서 추가'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'bulk_add',
                child: Row(
                  children: [
                    Icon(Icons.add_box),
                    SizedBox(width: 8),
                    Text('여러 문서 추가'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'load_json',
                child: Row(
                  children: [
                    Icon(Icons.upload_file, color: Colors.green),
                    SizedBox(width: 8),
                    Text('JSON 파일에서 로드', style: TextStyle(color: Colors.green)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_forever, color: Colors.red),
                    SizedBox(width: 8),
                    Text('모두 삭제', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 검색창
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '검색어를 입력하세요 (예: 인천, 공항, 일본)',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchResults = [];
                                _statusMessage = '준비 완료! 검색어를 입력하세요.';
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
                        label: const Text('검색'),
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
                      ? Colors.blue.shade50
                      : Colors.green.shade50,
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
                    Expanded(child: Text(_statusMessage)),
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
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isIndexInitialized
                              ? '검색 결과가 없습니다'
                              : '인덱스 초기화 중...',
                          style: TextStyle(
                            color: Colors.grey.shade600,
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

                      // metadata JSON 파싱
                      Map<String, dynamic> metadata = {};
                      try {
                        metadata = json.decode(result.metadata);
                      } catch (e) {
                        debugPrint('Metadata 파싱 오류: $e');
                      }

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 상단: 순위와 점수
                              Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      result.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '⭐ ${result.score.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange.shade900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // 본문 내용
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  result.body.length > 150
                                      ? '${result.body.substring(0, 150)}...'
                                      : result.body,
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    height: 1.5,
                                    fontSize: 14,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Metadata 섹션
                              if (metadata.isNotEmpty) ...[
                                const Divider(),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Metadata',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: _buildMetadataChips(metadata),
                                ),
                              ],

                              const SizedBox(height: 12),

                              // 하단 액션 버튼
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // ID 표시 (축약)
                                  Expanded(
                                    child: Text(
                                      'ID: ${result.id.length > 20 ? "${result.id.substring(0, 20)}..." : result.id}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                                  // 액션 버튼
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () => _showEditDocumentDialog(result),
                                        icon: const Icon(Icons.edit, size: 16),
                                        label: const Text('수정', style: TextStyle(fontSize: 12)),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.blue,
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: () => _deleteDocument(result.id),
                                        icon: const Icon(Icons.delete, size: 16),
                                        label: const Text('삭제', style: TextStyle(fontSize: 12)),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
              label: const Text('문서 추가'),
              tooltip: '새 문서 추가',
            )
          : null,
    );
  }

  /// Metadata를 Chip 위젯으로 변환하는 헬퍼 함수
  List<Widget> _buildMetadataChips(Map<String, dynamic> metadata) {
    final chips = <Widget>[];

    metadata.forEach((key, value) {
      // 값의 타입에 따라 다르게 표시
      String displayValue;
      Color chipColor;
      IconData? icon;

      if (value is List) {
        // 배열의 각 요소를 문자열로 변환하고 null 제거
        final stringList = value
            .where((item) => item != null)
            .map((item) => item.toString())
            .toList();

        if (stringList.isEmpty) {
          return; // 빈 배열은 표시하지 않음
        }

        displayValue = '$key: ${stringList.join(", ")}';
        chipColor = Colors.purple.shade50;
        icon = Icons.list;
      } else if (value is num) {
        displayValue = '$key: $value';
        chipColor = Colors.green.shade50;
        icon = Icons.numbers;
      } else if (value is bool) {
        displayValue = '$key: $value';
        chipColor = Colors.blue.shade50;
        icon = Icons.check_circle_outline;
      } else if (value == null) {
        return; // null 값은 표시하지 않음
      } else {
        displayValue = '$key: $value';
        chipColor = Colors.grey.shade100;

        // 특정 키에 대한 아이콘 설정
        if (key == 'author') {
          icon = Icons.person;
          chipColor = Colors.amber.shade50;
        } else if (key == 'createdAt' || key == 'lastModified') {
          icon = Icons.calendar_today;
          chipColor = Colors.cyan.shade50;
        } else if (key == 'rating') {
          icon = Icons.star;
          chipColor = Colors.orange.shade50;
        } else if (key == 'views' || key == 'likes' || key == 'visitors') {
          icon = Icons.visibility;
          chipColor = Colors.pink.shade50;
        } else if (key == 'category') {
          icon = Icons.category;
          chipColor = Colors.indigo.shade50;
        } else if (key == 'language') {
          icon = Icons.language;
          chipColor = Colors.teal.shade50;
        } else if (key == 'tags') {
          icon = Icons.label;
          chipColor = Colors.purple.shade50;
        }
      }

      chips.add(
        Chip(
          avatar: icon != null
              ? Icon(icon, size: 16, color: Colors.grey.shade700)
              : null,
          label: Text(
            displayValue,
            style: const TextStyle(fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
          backgroundColor: chipColor,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    });

    return chips;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
