import 'package:flutter/material.dart';
import 'package:flutter_lindera_tantivy/flutter_lindera_tantivy.dart';

class TokenizerPage extends StatefulWidget {
  const TokenizerPage({super.key});

  @override
  State<TokenizerPage> createState() => _TokenizerPageState();
}

class _TokenizerPageState extends State<TokenizerPage> {
  final TextEditingController _textController = TextEditingController(
    text: '한국어 형태소 분석 기능을 테스트합니다.',
  );
  DictionaryType _selectedDict = DictionaryType.korean;
  TokenMode _selectedMode = TokenMode.normal;

  List<String> _simpleTokens = [];
  List<TokenDetail> _detailedTokens = [];
  bool _isAnalyzing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _analyze();
  }

  void _analyze() {
    setState(() {
      _isAnalyzing = true;
      _error = null;
    });

    try {
      final text = _textController.text.trim();
      if (text.isEmpty) {
        setState(() {
          _simpleTokens = [];
          _detailedTokens = [];
          _isAnalyzing = false;
        });
        return;
      }

      final simple = tokenizeText(
        dictionaryType: _selectedDict,
        text: text,
        mode: _selectedMode,
      );

      final detailed = tokenizeTextDetailed(
        dictionaryType: _selectedDict,
        text: text,
        mode: _selectedMode,
      );

      setState(() {
        _simpleTokens = simple;
        _detailedTokens = detailed;
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lindera Morphological Tokenizer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Settings Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '사전 및 모드 설정',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('사전 선택: '),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButton<DictionaryType>(
                            value: _selectedDict,
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(
                                value: DictionaryType.korean,
                                child: Text('한국어 (ko-dic)'),
                              ),
                              DropdownMenuItem(
                                value: DictionaryType.japaneseIpadic,
                                child: Text('일본어 (IPADIC)'),
                              ),
                              DropdownMenuItem(
                                value: DictionaryType.japaneseUnidic,
                                child: Text('일본어 (UniDic)'),
                              ),
                              DropdownMenuItem(
                                value: DictionaryType.chinese,
                                child: Text('중국어 (CC-CEDICT)'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedDict = val;
                                  if (val == DictionaryType.japaneseIpadic || val == DictionaryType.japaneseUnidic) {
                                    _textController.text = '関西国際空港限定トートバッグ';
                                  } else if (val == DictionaryType.chinese) {
                                    _textController.text = '北京首都国际机场';
                                  } else {
                                    _textController.text = '한국어 형태소 분석 기능을 테스트합니다.';
                                  }
                                });
                                _analyze();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('분석 모드: '),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Normal'),
                          selected: _selectedMode == TokenMode.normal,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedMode = TokenMode.normal);
                              _analyze();
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Decompose'),
                          selected: _selectedMode == TokenMode.decompose,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedMode = TokenMode.decompose);
                              _analyze();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Input Text Field
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: '분석할 텍스트 입력',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _analyze,
                ),
              ),
              maxLines: 3,
              onChanged: (_) => _analyze(),
            ),
            const SizedBox(height: 16),

            if (_isAnalyzing)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Card(
                color: Colors.red.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('오류: $_error', style: const TextStyle(color: Colors.red)),
                ),
              )
            else ...[
              // Simple Tokens Result
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '단순 형태소 토큰 (${_simpleTokens.length}개)',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: _simpleTokens
                            .map((t) => Chip(
                                  label: Text(t),
                                  backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Detailed Tokens Result
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '상세 형태소 분석 결과 (${_detailedTokens.length}개)',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _detailedTokens.length,
                        separatorBuilder: (_, _) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = _detailedTokens[index];
                          return ListTile(
                            dense: true,
                            title: Text(
                              item.surface,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            subtitle: Text('품사: ${item.pos}\n상세: ${item.details.join(", ")}'),
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
