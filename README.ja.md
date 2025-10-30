# flutter_lindera_tantivy

[English](README.md) | 日本語 | [한국어](README.ko.md) | [中文](README.zh.md)

Tantivyサーチエンジンとlindera形態素解析を活用した高性能全文検索機能を提供するFlutter FFIプラグインです。韓国語、日本語（IPADIC/UniDic）、中国語のテキストを埋め込み辞書でサポートします。

### 主な機能

- 🚀 **高性能検索**: RustのTantivyサーチエンジンを基盤
- 🔍 **形態素解析**: Linderaによる正確なアジア言語のトークン化
- 🌏 **多言語サポート**: 韓国語、日本語（IPADIC/UniDic）、中国語
- 📱 **クロスプラットフォーム**: Android、iOS、Linux、macOS、Windows
- 💾 **柔軟なストレージ**: メモリ内またはディスクベースのインデックス保存
- ⚡ **ネイティブパフォーマンス**: flutter_rust_bridge経由の直接Rust FFIバインディング

### サポート言語

- **韓国語**: Ko-dic辞書を内蔵
- **日本語（IPADIC）**: 現代日本語向けIPA辞書
- **日本語（UniDic）**: 現代書き言葉向けUniDic辞書
- **中国語**: CC-CEDICT辞書

### インストール

`pubspec.yaml`に追加：

```yaml
dependencies:
  flutter_lindera_tantivy: ^0.0.1
```

### クイックスタート

```dart
import 'package:flutter_lindera_tantivy/flutter_lindera_tantivy.dart';

// Rustライブラリを初期化
await RustLib.init();

// 日本語IPADIC辞書で検索インデックスを初期化
initializeSearchIndex(dictionaryType: DictionaryType.japaneseIpadic);

// ドキュメントを追加
addDocument(
  title: "Flutterチュートリアル",
  body: "Flutter開発を学ぶ",
  metadataJson: '{"category": "tutorial"}',
);

// ドキュメントを検索
final results = searchDocuments(
  queryStr: "Flutter",
  limit: BigInt.from(10),
);

for (var result in results) {
  print('${result.title}: ${result.score}');
}
```

### API リファレンス

#### インデックス初期化

```dart
// メモリ内インデックス
String initializeSearchIndex({required DictionaryType dictionaryType})

// ディスクベースインデックス
String initializeSearchIndexWithPath({
  required DictionaryType dictionaryType,
  required String indexPath,
})
```

#### ドキュメント管理

```dart
// 単一ドキュメント追加
String addDocument({
  required String title,
  required String body,
  required String metadataJson,
})

// 複数ドキュメント追加
String addDocuments({required List<DocumentInput> documents})

// ドキュメント更新
String updateDocument({
  required String id,
  required String title,
  required String body,
  required String metadataJson,
})

// ドキュメント削除
String deleteDocument({required String id})
String deleteDocuments({required List<String> ids})
String clearAllDocuments()

// ドキュメント数取得
BigInt getDocumentCount()
```

#### 検索

```dart
List<SearchResult> searchDocuments({
  required String queryStr,
  required BigInt limit,
})
```

### ライセンス

[LICENSE](LICENSE)ファイルを参照してください。

### リポジトリ

https://github.com/JAICHANGPARK/flutter_lindera_tantivy
