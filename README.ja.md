# flutter_lindera_tantivy

[English](https://github.com/JAICHANGPARK/flutter_lindera_tantivy/blob/main/README.md) | 日本語 | [한국어](https://github.com/JAICHANGPARK/flutter_lindera_tantivy/blob/main/README.ko.md) | [中文](https://github.com/JAICHANGPARK/flutter_lindera_tantivy/blob/main/README.zh.md)

Tantivy検索エンジンとLindera 4.0形態素解析器を搭載した、高速フルテキスト検索および形態素解析を提供するFlutter FFIプラグインです。組み込み辞書により、日本語（IPADIC/UniDic）、韓国語、中国語に対応しています。

### 主な機能

- 🚀 **高速全文検索**: Rust製Tantivy（v0.25）およびLindera（v4.0）を採用
- 🔍 **単独の形態素解析**: CJKテキストを単語に分割、品사（POS）情報を詳細取得
- 🌏 **多言語サポート**: 日本語（IPADIC/UniDic）、韓国語（Ko-dic）、中国語（CC-CEDICT）
- 📱 **クロスプラットフォーム**: Android、iOS、Linux、macOS、Windows対応
- 💾 **柔軟なストレージ**: インメモリ（RAM）およびディスクストレージをサポート
- ⚡ **ネイティブパフォーマンス**: `flutter_rust_bridge`によるダイレクトRust FFIバインディング

### インストール方法

`pubspec.yaml`に追加してください:

```yaml
dependencies:
  flutter_lindera_tantivy: ^2026.7.26
```

### クイックスタート

#### 1. 全文検索

```dart
import 'package:flutter_lindera_tantivy/flutter_lindera_tantivy.dart';

// Rustライブラリの初期化
await RustLib.init();

// 日本語（IPADIC）辞書で検索インデックスを初期化
initializeSearchIndex(dictionaryType: DictionaryType.japaneseIpadic);

// ドキュメントを追加
addDocument(
  title: "Flutter チュートリアル",
  body: "Linderaを活用したFlutter全文検索開発",
  metadataJson: '{"category": "tutorial"}',
);

// 検索を実行
final results = searchDocuments(
  queryStr: "検索",
  limit: BigInt.from(10),
);

for (var result in results) {
  print('${result.title}: ${result.score}');
}
```

#### 2. 形態素解析（単独利用）

```dart
import 'package:flutter_lindera_tantivy/flutter_lindera_tantivy.dart';

// テキストの分節・トークン化
final tokens = tokenizeText(
  dictionaryType: DictionaryType.japaneseIpadic,
  text: "関西国際空港に行きます",
  mode: TokenMode.normal,
);
print(tokens); // ['関西', '国際', '空港', 'に', '行き', 'ます']

// 品詞情報を含む詳細解析
final details = tokenizeTextDetailed(
  dictionaryType: DictionaryType.japaneseIpadic,
  text: "関西国際空港",
  mode: TokenMode.normal,
);

for (var token in details) {
  print('${token.surface} [${token.pos}]: ${token.details.join(", ")}');
}
```

### 라이선스 / License

[LICENSE](LICENSE) ファイルをご参照ください。
