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
    setState(() {
      _isRunning = true;
      _progressMessage = '벤치마크 준비 중...';
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
        _progressMessage = '완료!';
      });
    } catch (e) {
      setState(() {
        _isRunning = false;
        _progressMessage = '오류 발생: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚀 성능 벤치마크'),
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
                      '벤치마크 설정',
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
                                '테스트 언어',
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
                                '문서 개수: ${_documentCount.toString()}',
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
                        label: Text(_isRunning ? '실행 중...' : '벤치마크 실행'),
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
                  '벤치마크 결과',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(height: 24),

            // 인덱싱 성능
            _buildMetricRow(
              '문서 개수',
              '${result.documentCount.toStringAsFixed(0)}개',
              Icons.description,
            ),
            const SizedBox(height: 12),
            _buildMetricRow(
              '총 인덱싱 시간',
              '${(result.indexingTime.inMilliseconds / 1000).toStringAsFixed(2)}초',
              Icons.timer,
            ),
            const SizedBox(height: 12),
            _buildMetricRow(
              '문서당 평균 인덱싱 시간',
              '${result.indexingTimePerDocMs.toStringAsFixed(3)}ms',
              Icons.speed,
              highlight: true,
            ),

            const Divider(height: 24),

            // 검색 성능
            _buildMetricRow(
              '검색 쿼리 수',
              '${result.individualSearchTimes.length}개',
              Icons.search,
            ),
            const SizedBox(height: 12),
            _buildMetricRow(
              '총 검색 시간',
              '${(result.searchTime.inMilliseconds / 1000).toStringAsFixed(3)}초',
              Icons.timer,
            ),
            const SizedBox(height: 12),
            _buildMetricRow(
              '평균 검색 시간',
              '${result.averageSearchTimeMs.toStringAsFixed(3)}ms',
              Icons.speed,
              highlight: true,
            ),
            const SizedBox(height: 12),
            _buildMetricRow(
              '총 검색 결과',
              '${result.searchResultCount}건',
              Icons.list,
            ),

            const Divider(height: 24),

            // 개별 검색 시간
            ExpansionTile(
              title: const Text('개별 검색 시간 상세'),
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
                      '평균적으로 ${result.documentCount}개의 문서를 ${result.averageSearchTimeMs.toStringAsFixed(1)}ms에 검색할 수 있습니다.',
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
