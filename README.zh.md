# flutter_lindera_tantivy

[English](https://github.com/JAICHANGPARK/flutter_lindera_tantivy/blob/main/README.md) | [日本語](https://github.com/JAICHANGPARK/flutter_lindera_tantivy/blob/main/README.ja.md) | [한국어](https://github.com/JAICHANGPARK/flutter_lindera_tantivy/blob/main/README.ko.md) | 中文

基于 Tantivy 搜索引擎与 Lindera 4.0 分词器的 Flutter 高性能全文搜索与分词 FFI 插件。内置词典，支持中文、韩语及日语 (IPADIC/UniDic)。

### 主要特性

- 🚀 **高性能搜索**: 基于 Rust Tantivy (v0.25) 与 Lindera (v4.0)
- 🔍 **独立分词分析**: 直接将 CJK 文本分词或提取词性 (POS) 标记
- 🌏 **多语言支持**: 中文 (CC-CEDICT)、韩语 (Ko-dic)、日语 (IPADIC/UniDic)
- 📱 **跨平台**: 支持 Android, iOS, Linux, macOS, Windows
- 💾 **灵活存储**: 支持内存索引及磁盘索引存储
- ⚡ **原生性能**: 基于 `flutter_rust_bridge` 的 Rust FFI 绑定

### 安装方法

在 `pubspec.yaml` 中添加：

```yaml
dependencies:
  flutter_lindera_tantivy: ^2026.7.26
```

### 快速开始

#### 1. 全文搜索

```dart
import 'package:flutter_lindera_tantivy/flutter_lindera_tantivy.dart';

// 初始化 Rust 库
await RustLib.init();

// 使用中文词典初始化搜索索引
initializeSearchIndex(dictionaryType: DictionaryType.chinese);

// 添加文档
addDocument(
  title: "Flutter 教程",
  body: "使用 Lindera 进行 Flutter 全文搜索开发",
  metadataJson: '{"category": "tutorial"}',
);

// 搜索文档
final results = searchDocuments(
  queryStr: "搜索",
  limit: BigInt.from(10),
);

for (var result in results) {
  print('${result.title}: ${result.score}');
}
```

#### 2. 分词分析 (Tokenization)

```dart
import 'package:flutter_lindera_tantivy/flutter_lindera_tantivy.dart';

// 独立文本分词
final tokens = tokenizeText(
  dictionaryType: DictionaryType.chinese,
  text: "北京首都国际机场",
  mode: TokenMode.normal,
);
print(tokens);

// 详细分词及词性标注
final details = tokenizeTextDetailed(
  dictionaryType: DictionaryType.chinese,
  text: "北京首都国际机场",
  mode: TokenMode.normal,
);

for (var token in details) {
  print('${token.surface} [${token.pos}]: ${token.details.join(", ")}');
}
```

### 许可协议

请参阅 [LICENSE](LICENSE) 文件。
