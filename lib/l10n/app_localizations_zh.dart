// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '搜索系统';

  @override
  String get searchHint => '请输入搜索词 (例如: 仁川、机场、日本)';

  @override
  String get search => '搜索';

  @override
  String searchResults(int count) {
    return '搜索结果: $count个';
  }

  @override
  String get noResults => '没有找到搜索结果';

  @override
  String get indexInitializing => '正在初始化索引...';

  @override
  String get indexReady => '准备就绪！请输入搜索词。';

  @override
  String get searching => '正在搜索...';

  @override
  String documentCount(int count) {
    return '文档: $count个';
  }

  @override
  String get addDocument => '添加文档';

  @override
  String get addMultipleDocuments => '添加多个文档';

  @override
  String get loadFromJson => '从JSON文件加载';

  @override
  String get deleteAll => '全部删除';

  @override
  String get title => '标题';

  @override
  String get content => '内容';

  @override
  String get cancel => '取消';

  @override
  String get add => '添加';

  @override
  String get edit => '编辑';

  @override
  String get delete => '删除';

  @override
  String get titleRequired => '请输入标题';

  @override
  String get contentRequired => '请输入内容';

  @override
  String get titleAndContentRequired => '请输入标题和内容';

  @override
  String get enterTitle => '请输入文档标题';

  @override
  String get enterContent => '请输入文档内容';

  @override
  String get metadata => '元数据';

  @override
  String get metadataJson => '元数据 (JSON)';

  @override
  String get autoGenerateUuid => 'UUID将自动生成';

  @override
  String get editDocument => '编辑文档';

  @override
  String get deleteDocument => '删除文档';

  @override
  String deleteConfirm(String id) {
    return '确定要删除文档ID \"$id\"吗？';
  }

  @override
  String get deleteAllWarning => '确定要删除所有文档吗？\n此操作无法撤销。';

  @override
  String get warning => '⚠️ 警告';

  @override
  String get allDocumentsDeleted => '所有文档已删除。';

  @override
  String get enterSearchTerm => '请输入搜索词。';

  @override
  String get initializingIndex => '正在初始化搜索索引...';

  @override
  String initFailed(String error) {
    return '初始化失败: $error';
  }

  @override
  String searchFailed(String error) {
    return '搜索失败: $error';
  }

  @override
  String addFailed(String error) {
    return '添加失败: $error';
  }

  @override
  String updateFailed(String error) {
    return '更新失败: $error';
  }

  @override
  String deleteFailed(String error) {
    return '删除失败: $error';
  }

  @override
  String get loadingFromJson => '正在从JSON文件加载文档...';

  @override
  String jsonLoadFailed(String error) {
    return 'JSON加载失败: $error';
  }

  @override
  String get bulkAddTitle => '添加多个文档';

  @override
  String get bulkAddFormat => '格式: 标题|内容|元数据 (用换行符分隔)';

  @override
  String get documentList => '文档列表';

  @override
  String invalidFormat(String line) {
    return '格式错误: $line';
  }

  @override
  String get noDocumentsToAdd => '没有要添加的文档';
}
