import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lindera_tantivy/flutter_lindera_tantivy.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async => await RustLib.init());

  test('Can call rust greet function', () async {
    expect(greet(name: "Tom"), "Hello, Tom!");
  });

  test('Can tokenize text via Rust FFI', () async {
    final tokens = tokenizeText(
      dictionaryType: DictionaryType.korean,
      text: '한국어 형태소 분석 테스트',
      mode: TokenMode.normal,
    );
    expect(tokens, isNotEmpty);
    expect(tokens, contains('한국어'));

    final details = tokenizeTextDetailed(
      dictionaryType: DictionaryType.korean,
      text: '한국어 형태소 분석 테스트',
      mode: TokenMode.normal,
    );
    expect(details, isNotEmpty);
    expect(details.first.surface, equals('한국어'));
    expect(details.first.pos, isNotEmpty);
  });

  test('Full search index workflow via Rust FFI', () async {
    final initRes = initializeSearchIndex(dictionaryType: DictionaryType.korean);
    expect(initRes, contains('초기화'));

    final sampleRes = indexSampleDocuments();
    expect(sampleRes, contains('문서'));

    final results = searchDocuments(queryStr: '나리타', limit: BigInt.from(10));
    expect(results, isNotEmpty);
    expect(results.first.title, contains('나리타'));

    final count = getDocumentCount();
    expect(count.toInt(), greaterThan(0));

    final clearRes = clearAllDocuments();
    expect(clearRes, contains('삭제'));
    expect(getDocumentCount().toInt(), equals(0));
  });
}
