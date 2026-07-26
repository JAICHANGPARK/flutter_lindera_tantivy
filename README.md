# flutter_lindera_tantivy

English | [日本語](https://github.com/JAICHANGPARK/flutter_lindera_tantivy/blob/main/README.ja.md) | [한국어](https://github.com/JAICHANGPARK/flutter_lindera_tantivy/blob/main/README.ko.md) | [中文](https://github.com/JAICHANGPARK/flutter_lindera_tantivy/blob/main/README.zh.md)

A Flutter FFI plugin that provides high-performance full-text search powered by the Tantivy search engine and Lindera 4.0 morphological analysis. Supports Korean, Japanese (IPADIC/UniDic), and Chinese text processing with embedded dictionaries.

### Features

- 🚀 **High-Performance Search**: Built on Rust's Tantivy search engine (v0.25) & Lindera (v4.0)
- 🔍 **Standalone Morphological Analysis**: Tokenize CJK text directly into tokens or detailed POS attributes
- 🌏 **Multi-Language Support**: Korean (Ko-dic), Japanese (IPADIC/UniDic), and Chinese (CC-CEDICT)
- 📱 **Cross-Platform**: Android, iOS, Linux, macOS, and Windows
- 💾 **Flexible Storage**: In-memory or disk-based index storage
- ⚡ **Native Performance**: Direct Rust FFI bindings via `flutter_rust_bridge`

### Supported Languages & Dictionaries

- **Korean**: Embedded `Ko-dic` dictionary
- **Japanese (IPADIC)**: IPA dictionary for modern Japanese
- **Japanese (UniDic)**: UniDic dictionary for contemporary written Japanese
- **Chinese**: `CC-CEDICT` dictionary

### Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_lindera_tantivy: ^2026.7.26
```

### Quick Start

#### 1. Full-Text Search

```dart
import 'package:flutter_lindera_tantivy/flutter_lindera_tantivy.dart';

// Initialize Rust library
await RustLib.init();

// Initialize search index with Korean dictionary
initializeSearchIndex(dictionaryType: DictionaryType.korean);

// Add documents
addDocument(
  title: "Flutter Tutorial",
  body: "Learn Flutter full-text search with Lindera",
  metadataJson: '{"category": "tutorial"}',
);

// Search documents
final results = searchDocuments(
  queryStr: "Flutter",
  limit: BigInt.from(10),
);

for (var result in results) {
  print('${result.title}: ${result.score}');
}
```

#### 2. Morphological Analysis (Tokenization)

```dart
import 'package:flutter_lindera_tantivy/flutter_lindera_tantivy.dart';

// Standalone text tokenization
final tokens = tokenizeText(
  dictionaryType: DictionaryType.korean,
  text: "한국어 형태소 분석 테스트",
  mode: TokenMode.normal,
);
print(tokens); // ['한국어', '형태소', '분석', '테스트']

// Detailed tokenization with Part of Speech (POS) tags
final details = tokenizeTextDetailed(
  dictionaryType: DictionaryType.korean,
  text: "한국어 형태소 분석",
  mode: TokenMode.normal,
);

for (var token in details) {
  print('${token.surface} [${token.pos}]: ${token.details.join(", ")}');
}
```

### API Reference

#### Morphological Analysis

```dart
// Tokenize text into surface string list
List<String> tokenizeText({
  required DictionaryType dictionaryType,
  required String text,
  required TokenMode mode,
})

// Tokenize text into detailed TokenDetail objects
List<TokenDetail> tokenizeTextDetailed({
  required DictionaryType dictionaryType,
  required String text,
  required TokenMode mode,
})
```

#### Initialize Index

```dart
// In-memory index
String initializeSearchIndex({required DictionaryType dictionaryType})

// Disk-based index
String initializeSearchIndexWithPath({
  required DictionaryType dictionaryType,
  required String indexPath,
})
```

#### Document Management

```dart
// Add single document
String addDocument({
  required String title,
  required String body,
  required String metadataJson,
})

// Add multiple documents
String addDocuments({required List<DocumentInput> documents})

// Update document
String updateDocument({
  required String id,
  required String title,
  required String body,
  required String metadataJson,
})

// Delete document(s)
String deleteDocument({required String id})
String deleteDocuments({required List<String> ids})
String clearAllDocuments()

// Get document count
BigInt getDocumentCount()
```

#### Search

```dart
List<SearchResult> searchDocuments({
  required String queryStr,
  required BigInt limit,
})
```

### License

See [LICENSE](LICENSE) file.

### Repository

https://github.com/JAICHANGPARK/flutter_lindera_tantivy
