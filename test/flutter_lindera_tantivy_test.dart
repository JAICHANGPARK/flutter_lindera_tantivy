import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lindera_tantivy/flutter_lindera_tantivy.dart';

void main() {
  group('Data Models & Enums Tests', () {
    test('DictionaryType enum values', () {
      expect(DictionaryType.values, contains(DictionaryType.korean));
      expect(DictionaryType.values, contains(DictionaryType.japaneseIpadic));
      expect(DictionaryType.values, contains(DictionaryType.japaneseUnidic));
      expect(DictionaryType.values, contains(DictionaryType.chinese));
      expect(DictionaryType.values.length, equals(4));
    });

    test('TokenMode enum values', () {
      expect(TokenMode.values, contains(TokenMode.normal));
      expect(TokenMode.values, contains(TokenMode.decompose));
      expect(TokenMode.values.length, equals(2));
    });

    test('DocumentInput model equality and hashcode', () {
      const doc1 = DocumentInput(
        id: 'uuid-1',
        title: 'Title 1',
        body: 'Body 1',
        metadata: '{"key":"value"}',
      );

      const doc2 = DocumentInput(
        id: 'uuid-1',
        title: 'Title 1',
        body: 'Body 1',
        metadata: '{"key":"value"}',
      );

      const doc3 = DocumentInput(
        id: 'uuid-2',
        title: 'Title 2',
        body: 'Body 2',
        metadata: '{}',
      );

      expect(doc1, equals(doc2));
      expect(doc1.hashCode, equals(doc2.hashCode));
      expect(doc1, isNot(equals(doc3)));
      expect(doc1.id, equals('uuid-1'));
      expect(doc1.title, equals('Title 1'));
      expect(doc1.body, equals('Body 1'));
      expect(doc1.metadata, equals('{"key":"value"}'));
    });

    test('SearchResult model equality and hashcode', () {
      const result1 = SearchResult(
        id: 'id-100',
        title: 'Result Title',
        body: 'Result Body',
        score: 1.5,
        metadata: '{"city":"Seoul"}',
      );

      const result2 = SearchResult(
        id: 'id-100',
        title: 'Result Title',
        body: 'Result Body',
        score: 1.5,
        metadata: '{"city":"Seoul"}',
      );

      const result3 = SearchResult(
        id: 'id-200',
        title: 'Other Title',
        body: 'Other Body',
        score: 0.8,
        metadata: '{}',
      );

      expect(result1, equals(result2));
      expect(result1.hashCode, equals(result2.hashCode));
      expect(result1, isNot(equals(result3)));
      expect(result1.score, equals(1.5));
    });

    test('TokenDetail model equality and hashcode', () {
      const detail1 = TokenDetail(
        surface: '한국어',
        pos: 'NNG',
        details: ['NNG', '명사', '체언'],
      );

      const detail2 = TokenDetail(
        surface: '한국어',
        pos: 'NNG',
        details: ['NNG', '명사', '체언'],
      );

      const detail3 = TokenDetail(
        surface: '형태소',
        pos: 'NNG',
        details: ['NNG'],
      );

      expect(detail1, equals(detail2));
      expect(detail1.hashCode, equals(detail2.hashCode));
      expect(detail1, isNot(equals(detail3)));
      expect(detail1.surface, equals('한국어'));
      expect(detail1.pos, equals('NNG'));
      expect(detail1.details, contains('명사'));
    });
  });

  group('Library Initialization Tests', () {
    test('RustLib init instance check', () {
      expect(RustLib.instance, isNotNull);
    });
  });
}
