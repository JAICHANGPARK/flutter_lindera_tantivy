// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '検索システム';

  @override
  String get searchHint => '検索キーワードを入力してください (例: 仁川、空港、日本)';

  @override
  String get search => '検索';

  @override
  String searchResults(int count) {
    return '検索結果: $count件';
  }

  @override
  String get noResults => '検索結果がありません';

  @override
  String get indexInitializing => 'インデックスを初期化中...';

  @override
  String get indexReady => '準備完了！検索キーワードを入力してください。';

  @override
  String get searching => '検索中...';

  @override
  String documentCount(int count) {
    return '文書: $count件';
  }

  @override
  String get addDocument => '文書を追加';

  @override
  String get addMultipleDocuments => '複数の文書を追加';

  @override
  String get loadFromJson => 'JSONファイルから読み込む';

  @override
  String get deleteAll => 'すべて削除';

  @override
  String get title => 'タイトル';

  @override
  String get content => '内容';

  @override
  String get cancel => 'キャンセル';

  @override
  String get add => '追加';

  @override
  String get edit => '編集';

  @override
  String get delete => '削除';

  @override
  String get titleRequired => 'タイトルを入力してください';

  @override
  String get contentRequired => '内容を入力してください';

  @override
  String get titleAndContentRequired => 'タイトルと内容を入力してください';

  @override
  String get enterTitle => '文書のタイトルを入力してください';

  @override
  String get enterContent => '文書の内容を入力してください';

  @override
  String get metadata => 'メタデータ';

  @override
  String get metadataJson => 'メタデータ (JSON)';

  @override
  String get autoGenerateUuid => 'UUIDは自動的に生成されます';

  @override
  String get editDocument => '文書を編集';

  @override
  String get deleteDocument => '文書を削除';

  @override
  String deleteConfirm(String id) {
    return '文書ID \"$id\"を削除してもよろしいですか？';
  }

  @override
  String get deleteAllWarning => 'すべての文書を削除してもよろしいですか？\nこの操作は元に戻せません。';

  @override
  String get warning => '⚠️ 警告';

  @override
  String get allDocumentsDeleted => 'すべての文書が削除されました。';

  @override
  String get enterSearchTerm => '検索キーワードを入力してください。';

  @override
  String get initializingIndex => '検索インデックスを初期化中...';

  @override
  String initFailed(String error) {
    return '初期化に失敗しました: $error';
  }

  @override
  String searchFailed(String error) {
    return '検索に失敗しました: $error';
  }

  @override
  String addFailed(String error) {
    return '追加に失敗しました: $error';
  }

  @override
  String updateFailed(String error) {
    return '更新に失敗しました: $error';
  }

  @override
  String deleteFailed(String error) {
    return '削除に失敗しました: $error';
  }

  @override
  String get loadingFromJson => 'JSONファイルから文書を読み込み中...';

  @override
  String jsonLoadFailed(String error) {
    return 'JSONの読み込みに失敗しました: $error';
  }

  @override
  String get bulkAddTitle => '複数の文書を追加';

  @override
  String get bulkAddFormat => '形式: タイトル|内容|メタデータ (改行で区切る)';

  @override
  String get documentList => '文書リスト';

  @override
  String invalidFormat(String line) {
    return '無効な形式: $line';
  }

  @override
  String get noDocumentsToAdd => '追加する文書がありません';

  @override
  String get webPlatformNotSupported => 'Webプラットフォーム未対応';

  @override
  String get webPlatformMessage =>
      'このアプリはRust FFIを使用しているため、Webプラットフォームではサポートされていません。\nmacOS、Windows、Linux、iOS、Androidアプリをご利用ください。';
}
