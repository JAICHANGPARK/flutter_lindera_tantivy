# Flutter Lindera Tantivy

LinderapトークナイザーとTantivy検索エンジンを使用した、韓国語サポート付きの高性能全文検索アプリケーションです。FlutterとRustで構築されています。

[English](README.md) | [한국어](README.ko.md)

## 主な機能

- **🔍 全文検索**: BM25ランキングを使用したTantivy検索エンジン
- **🇰🇷 韓国語サポート**: Linderaトークナイザーを使用した高度な韓国語テキスト解析
- **⚡ 高性能**: Flutter Rust Bridge (FFI) を介したRustベースのバックエンド
- **🌍 多言語UI**: 韓国語、英語、日本語、中国語をサポート
- **🎨 テーマサポート**: ライトモード、ダークモード、システムテーマ
- **📱 クロスプラットフォーム**: macOS、Windows、Linux、iOS、Androidをサポート
- **💾 永続ストレージ**: 自動永続化を備えたローカルドキュメントインデックス

## 技術スタック

### フロントエンド
- **Flutter**: クロスプラットフォームUIフレームワーク
- **Riverpod**: 状態管理
- **Material 3**: モダンなデザインシステム

### バックエンド
- **Rust**: 高性能検索エンジン
- **Tantivy**: 全文検索ライブラリ
- **Lindera**: 多言語形態素解析器
- **flutter_rust_bridge**: FlutterとRust間のFFIブリッジ

## はじめに

### 前提条件

- Flutter SDK (^3.9.2)
- Rustツールチェーン
- プラットフォーム固有の開発ツール:
  - macOS: Xcode
  - Windows: C++サポート付きVisual Studio
  - Linux: GCC/Clang
  - iOS: Xcode
  - Android: Android Studio

### インストール

1. リポジトリをクローン:
```bash
git clone https://github.com/yourusername/flutter_lindera_tantivy.git
cd flutter_lindera_tantivy
```

2. Flutter依存関係をインストール:
```bash
flutter pub get
```

3. コードを生成:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. アプリを実行:
```bash
# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux

# iOS (実機またはシミュレータが必要)
flutter run -d ios

# Android
flutter run -d android
```

## 使い方

### ドキュメントの追加

1. **「文書を追加」** ボタン（フローティングアクションボタン）をクリック
2. タイトルと内容を入力
3. オプションでJSON形式のメタデータを追加
4. **「追加」** をクリックしてドキュメントをインデックス化

### ドキュメントの検索

1. 検索バーに検索キーワードを入力
2. Enterキーを押すか **「検索」** ボタンをクリック
3. BM25アルゴリズムを使用して関連性に応じて結果をランク付け

### ドキュメントの管理

- **編集**: 検索結果カードの編集ボタンをクリック
- **削除**: 検索結果カードの削除ボタンをクリック
- **JSONから読み込む**: メニューを使用してJSONファイルからドキュメントを一括インポート
- **すべて削除**: インデックス化されたすべてのドキュメントを削除（確認が必要）

### テーマのカスタマイズ

アプリバーのテーマアイコンをクリックして選択:
- 🌞 ライトモード
- 🌙 ダークモード
- ⚙️ システムモード（システム設定に従う）

### 言語選択

アプリバーの言語アイコンをクリックして切り替え:
- 🇰🇷 韓国語
- 🇺🇸 英語
- 🇯🇵 日本語
- 🇨🇳 中国語

## アーキテクチャ

```
lib/
├── l10n/                 # ローカライゼーションファイル
├── models/              # データモデル
├── providers/           # Riverpod状態プロバイダー
├── screens/             # アプリ画面
├── services/            # ビジネスロジック
├── widgets/             # 再利用可能なUIコンポーネント
└── src/rust/            # 生成されたRust FFIバインディング

rust/
└── src/
    └── api/             # Rust検索API
```

## プラットフォームサポート

| プラットフォーム | サポート | 備考 |
|----------|-----------|-------|
| macOS    | ✅ | 完全サポート |
| Windows  | ✅ | 完全サポート |
| Linux    | ✅ | 完全サポート |
| iOS      | ✅ | 完全サポート |
| Android  | ✅ | 完全サポート |
| Web      | ❌ | 未サポート（FFIが必要） |

## 依存関係

### Flutterパッケージ
- `flutter_riverpod`: 状態管理
- `riverpod_annotation`: Riverpodのコード生成
- `flutter_rust_bridge`: Rust FFI統合
- `path_provider`: ローカルストレージアクセス
- `shared_preferences`: 永続的なキー値ストレージ

### Rustクレート
- `tantivy`: 全文検索エンジン
- `lindera`: 形態素解析器
- `lindera-tantivy`: LinderaのTantivy統合
- `serde_json`: JSONシリアライゼーション

## 貢献

貢献を歓迎します！お気軽にPull Requestを送信してください。

1. リポジトリをフォーク
2. 機能ブランチを作成 (`git checkout -b feature/AmazingFeature`)
3. 変更をコミット (`git commit -m 'Add some AmazingFeature'`)
4. ブランチにプッシュ (`git push origin feature/AmazingFeature`)
5. Pull Requestを開く

## ライセンス

このプロジェクトはMITライセンスの下でライセンスされています。詳細はLICENSEファイルを参照してください。

## 謝辞

- [Tantivy](https://github.com/tantivy-search/tantivy) - 高速な全文検索エンジンライブラリ
- [Lindera](https://github.com/lindera-morphology/lindera) - 形態素解析器
- [Flutter Rust Bridge](https://github.com/fzyzcjy/flutter_rust_bridge) - 高レベルFFIブリッジ

## お問い合わせ

プロジェクトリンク: [https://github.com/yourusername/flutter_lindera_tantivy](https://github.com/yourusername/flutter_lindera_tantivy)
