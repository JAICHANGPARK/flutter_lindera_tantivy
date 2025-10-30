# flutter_lindera_tantivy

English | [日本語](README.ja.md) | [한국어](README.ko.md) | [中文](README.zh.md)

A Flutter FFI plugin that provides high-performance full-text search capabilities powered by Tantivy search engine and Lindera morphological analysis. Supports Korean, Japanese (IPADIC/UniDic), and Chinese text with embedded dictionaries.

### Features

- 🚀 **High-Performance Search**: Built on Rust's Tantivy search engine
- 🔍 **Morphological Analysis**: Powered by Lindera for accurate Asian language tokenization
- 🌏 **Multi-Language Support**: Korean, Japanese (IPADIC/UniDic), and Chinese
- 📱 **Cross-Platform**: Android, iOS, Linux, macOS, and Windows
- 💾 **Flexible Storage**: In-memory or disk-based index storage
- ⚡ **Native Performance**: Direct Rust FFI bindings via flutter_rust_bridge

### Supported Languages

- **Korean**: Embedded Ko-dic dictionary
- **Japanese (IPADIC)**: IPA dictionary for modern Japanese
- **Japanese (UniDic)**: UniDic dictionary for contemporary written Japanese
- **Chinese**: CC-CEDICT dictionary

### Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_lindera_tantivy: ^0.0.1
```

### Quick Start

```dart
import 'package:flutter_lindera_tantivy/flutter_lindera_tantivy.dart';

// Initialize Rust library
await RustLib.init();

// Initialize search index with Korean dictionary
initializeSearchIndex(dictionaryType: DictionaryType.korean);

// Add documents
addDocument(
  title: "Flutter Tutorial",
  body: "Learn Flutter development",
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

### API Reference

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

