# flutter_lindera_tantivy

[English](README.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | 中文

一个基于 Tantivy 搜索引擎和 Lindera 形态分析的高性能全文搜索 Flutter FFI 插件。支持韩语、日语（IPADIC/UniDic）和中文文本，内置词典。

### 主要特性

- 🚀 **高性能搜索**: 基于 Rust 的 Tantivy 搜索引擎
- 🔍 **形态分析**: 由 Lindera 提供准确的亚洲语言分词
- 🌏 **多语言支持**: 韩语、日语（IPADIC/UniDic）、中文
- 📱 **跨平台**: Android、iOS、Linux、macOS、Windows
- 💾 **灵活存储**: 内存或磁盘索引存储
- ⚡ **原生性能**: 通过 flutter_rust_bridge 直接调用 Rust FFI

### 支持语言

- **韩语**: 内置 Ko-dic 词典
- **日语（IPADIC）**: 现代日语 IPA 词典
- **日语（UniDic）**: 现代书面语 UniDic 词典
- **中文**: CC-CEDICT 词典

### 安装

在 `pubspec.yaml` 中添加：

```yaml
dependencies:
  flutter_lindera_tantivy: ^0.0.1
```

### 快速开始

```dart
import 'package:flutter_lindera_tantivy/flutter_lindera_tantivy.dart';

// 初始化 Rust 库
await RustLib.init();

// 使用中文词典初始化搜索索引
initializeSearchIndex(dictionaryType: DictionaryType.chinese);

// 添加文档
addDocument(
  title: "Flutter 教程",
  body: "学习 Flutter 开发",
  metadataJson: '{"category": "tutorial"}',
);

// 搜索文档
final results = searchDocuments(
  queryStr: "Flutter",
  limit: BigInt.from(10),
);

for (var result in results) {
  print('${result.title}: ${result.score}');
}
```

### API 参考

#### 初始化索引

```dart
// 内存索引
String initializeSearchIndex({required DictionaryType dictionaryType})

// 磁盘索引
String initializeSearchIndexWithPath({
  required DictionaryType dictionaryType,
  required String indexPath,
})
```

#### 文档管理

```dart
// 添加单个文档
String addDocument({
  required String title,
  required String body,
  required String metadataJson,
})

// 添加多个文档
String addDocuments({required List<DocumentInput> documents})

// 更新文档
String updateDocument({
  required String id,
  required String title,
  required String body,
  required String metadataJson,
})

// 删除文档
String deleteDocument({required String id})
String deleteDocuments({required List<String> ids})
String clearAllDocuments()

// 获取文档数量
BigInt getDocumentCount()
```

#### 搜索

```dart
List<SearchResult> searchDocuments({
  required String queryStr,
  required BigInt limit,
})
```

### 许可证

参见 [LICENSE](LICENSE) 文件。

### 代码仓库

https://github.com/JAICHANGPARK/flutter_lindera_tantivy
