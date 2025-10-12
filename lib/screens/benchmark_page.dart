import 'package:flutter/material.dart';
import 'package:tantivy_flutter_app/services/benchmark_service.dart';
import 'package:tantivy_flutter_app/l10n/app_localizations.dart';

class BenchmarkPage extends StatefulWidget {
  const BenchmarkPage({super.key});

  @override
  State<BenchmarkPage> createState() => _BenchmarkPageState();
}

class _BenchmarkPageState extends State<BenchmarkPage> {
  bool _isRunning = false;
  String _progressMessage = '';
  BenchmarkResult? _result;
  int _documentCount = 100;
  String _selectedLanguage = 'ko';

  Future<void> _runBenchmark() async {
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isRunning = true;
      _progressMessage = l10n.benchmarkPreparing;
      _result = null;
    });

    try {
      final result = await BenchmarkService.runBenchmark(
        documentCount: _documentCount,
        searchQueries: BenchmarkService.generateDefaultSearchQueries(_selectedLanguage),
        onProgress: (message) {
          setState(() {
            _progressMessage = message;
          });
        },
        languageCode: _selectedLanguage,
      );

      setState(() {
        _result = result;
        _isRunning = false;
        _progressMessage = l10n.completed;
      });
    } catch (e) {
      setState(() {
        _isRunning = false;
        _progressMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text('🚀 ${l10n.performanceBenchmark}'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 설정 섹션
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.benchmarkSettings,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    // 언어 선택
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.testLanguage,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 8),
                              DropdownButton<String>(
                                value: _selectedLanguage,
                                isExpanded: true,
                                items: const [
                                  DropdownMenuItem(value: 'ko', child: Text('🇰🇷 한국어 (Korean)')),
                                  DropdownMenuItem(value: 'en', child: Text('🇺🇸 영어 (English)')),
                                  DropdownMenuItem(value: 'ja', child: Text('🇯🇵 일본어 (Japanese)')),
                                  DropdownMenuItem(value: 'zh', child: Text('🇨🇳 중국어 (Chinese)')),
                                ],
                                onChanged: _isRunning ? null : (value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedLanguage = value;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // 문서 개수 슬라이더
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.documentCountLabel(_documentCount.toString()),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Slider(
                                value: _documentCount.toDouble(),
                                min: 100,
                                max: 10000,
                                divisions: 99,
                                label: _documentCount.toString(),
                                onChanged: _isRunning
                                    ? null
                                    : (value) {
                                        setState(() {
                                          // 100 단위로 반올림
                                          _documentCount = ((value / 100).round() * 100).toInt();
                                        });
                                      },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isRunning ? null : _runBenchmark,
                        icon: _isRunning
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.play_arrow),
                        label: Text(_isRunning ? l10n.running : l10n.runBenchmark),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 진행 상황
            if (_progressMessage.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      if (_isRunning)
                        const Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          _progressMessage,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // 결과 섹션
            if (_result != null) _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final result = _result!;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.benchmarkResults,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(height: 24),

            // 인덱싱 성능
            _buildMetricRow(
              l10n.documentCount(result.documentCount.toInt()),
              '${result.documentCount.toStringAsFixed(0)}',
              Icons.description,
            ),
            const SizedBox(height: 12),
            _buildMetricRow(
              l10n.totalIndexingTime,
              '${(result.indexingTime.inMilliseconds / 1000).toStringAsFixed(2)}s',
              Icons.timer,
            ),
            const SizedBox(height: 12),
            _buildMetricRow(
              l10n.avgIndexingTimePerDoc,
              '${result.indexingTimePerDocMs.toStringAsFixed(3)}ms',
              Icons.speed,
              highlight: true,
            ),

            const Divider(height: 24),

            // 검색 성능
            _buildMetricRow(
              l10n.searchQueryCount,
              '${result.individualSearchTimes.length}',
              Icons.search,
            ),
            const SizedBox(height: 12),
            _buildMetricRow(
              l10n.totalSearchTime,
              '${(result.searchTime.inMilliseconds / 1000).toStringAsFixed(3)}s',
              Icons.timer,
            ),
            const SizedBox(height: 12),
            _buildMetricRow(
              l10n.avgSearchTime,
              '${result.averageSearchTimeMs.toStringAsFixed(3)}ms',
              Icons.speed,
              highlight: true,
            ),
            const SizedBox(height: 12),
            _buildMetricRow(
              l10n.totalSearchResults,
              '${result.searchResultCount}',
              Icons.list,
            ),

            const Divider(height: 24),

            // 개별 검색 시간
            ExpansionTile(
              title: Text(l10n.individualSearchTimes),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: result.individualSearchTimes.length,
                  itemBuilder: (context, index) {
                    final time = result.individualSearchTimes[index];
                    final queries =
                        BenchmarkService.generateDefaultSearchQueries(_selectedLanguage);
                    return ListTile(
                      dense: true,
                      leading: Text(
                        '#${index + 1}',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                      ),
                      title: Text(
                        queries[index],
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                      trailing: Text(
                        '${(time.inMicroseconds / 1000).toStringAsFixed(3)}ms',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 요약
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.benchmarkSummary(
                        result.documentCount.toInt(),
                        result.averageSearchTimeMs.toStringAsFixed(1),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(
    String label,
    String value,
    IconData icon, {
    bool highlight = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: highlight
                ? Theme.of(context).colorScheme.secondaryContainer
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'monospace',
              color: highlight
                  ? Theme.of(context).colorScheme.onSecondaryContainer
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
