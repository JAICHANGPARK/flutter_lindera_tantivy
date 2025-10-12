// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Search System';

  @override
  String get searchHint => 'Enter search term (e.g., Incheon, airport, Japan)';

  @override
  String get search => 'Search';

  @override
  String searchResults(int count) {
    return 'Search results: $count';
  }

  @override
  String get noResults => 'No results found';

  @override
  String get indexInitializing => 'Initializing index...';

  @override
  String get indexReady => 'Ready! Enter your search term.';

  @override
  String get searching => 'Searching...';

  @override
  String documentCount(int count) {
    return 'Documents: $count';
  }

  @override
  String get addDocument => 'Add Document';

  @override
  String get addMultipleDocuments => 'Add Multiple Documents';

  @override
  String get loadFromJson => 'Load from JSON';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get title => 'Title';

  @override
  String get content => 'Content';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get titleRequired => 'Please enter a title';

  @override
  String get contentRequired => 'Please enter content';

  @override
  String get titleAndContentRequired => 'Please enter both title and content';

  @override
  String get enterTitle => 'Enter document title';

  @override
  String get enterContent => 'Enter document content';

  @override
  String get metadata => 'Metadata';

  @override
  String get metadataJson => 'Metadata (JSON)';

  @override
  String get autoGenerateUuid => 'UUID will be generated automatically';

  @override
  String get editDocument => 'Edit Document';

  @override
  String get deleteDocument => 'Delete Document';

  @override
  String deleteConfirm(String id) {
    return 'Are you sure you want to delete document ID \"$id\"?';
  }

  @override
  String get deleteAllWarning =>
      'Are you sure you want to delete all documents?\nThis action cannot be undone.';

  @override
  String get warning => '⚠️ Warning';

  @override
  String get allDocumentsDeleted => 'All documents have been deleted.';

  @override
  String get enterSearchTerm => 'Please enter a search term.';

  @override
  String get initializingIndex => 'Initializing search index...';

  @override
  String initFailed(String error) {
    return 'Initialization failed: $error';
  }

  @override
  String searchFailed(String error) {
    return 'Search failed: $error';
  }

  @override
  String addFailed(String error) {
    return 'Failed to add: $error';
  }

  @override
  String updateFailed(String error) {
    return 'Failed to update: $error';
  }

  @override
  String deleteFailed(String error) {
    return 'Failed to delete: $error';
  }

  @override
  String get loadingFromJson => 'Loading documents from JSON...';

  @override
  String jsonLoadFailed(String error) {
    return 'Failed to load JSON: $error';
  }

  @override
  String get bulkAddTitle => 'Add Multiple Documents';

  @override
  String get bulkAddFormat =>
      'Format: title|content|metadata (separated by newlines)';

  @override
  String get documentList => 'Document List';

  @override
  String invalidFormat(String line) {
    return 'Invalid format: $line';
  }

  @override
  String get noDocumentsToAdd => 'No documents to add';

  @override
  String get webPlatformNotSupported => 'Web Platform Not Supported';

  @override
  String get webPlatformMessage =>
      'This app uses Rust FFI and is not supported on web platforms.\nPlease use the macOS, Windows, Linux, iOS, or Android app.';

  @override
  String get performanceBenchmark => 'Performance Benchmark';

  @override
  String get benchmarkSettings => 'Benchmark Settings';

  @override
  String get testLanguage => 'Test Language';

  @override
  String documentCountLabel(String count) {
    return 'Document Count: $count';
  }

  @override
  String get runBenchmark => 'Run Benchmark';

  @override
  String get running => 'Running...';

  @override
  String get benchmarkPreparing => 'Preparing benchmark...';

  @override
  String get deletingExisting => 'Deleting existing documents...';

  @override
  String indexingStart(int count) {
    return 'Starting to index $count documents...';
  }

  @override
  String indexingProgress(int current, int total, String percent) {
    return 'Indexing: $current/$total ($percent%)';
  }

  @override
  String indexingComplete(int time, String perDoc) {
    return 'Indexing complete: ${time}ms (${perDoc}ms/doc)';
  }

  @override
  String get searchPerformanceTest => 'Starting search performance test...';

  @override
  String searchingQuery(String query, int current, int total) {
    return 'Searching: \"$query\" ($current/$total)';
  }

  @override
  String get completed => 'Completed!';

  @override
  String get waitMessage => 'Please wait. UI may be temporarily slow.';

  @override
  String get benchmarkResults => 'Benchmark Results';

  @override
  String get totalIndexingTime => 'Total Indexing Time';

  @override
  String get avgIndexingTimePerDoc => 'Avg. Indexing Time per Doc';

  @override
  String get searchQueryCount => 'Search Query Count';

  @override
  String get totalSearchTime => 'Total Search Time';

  @override
  String get avgSearchTime => 'Avg. Search Time';

  @override
  String get totalSearchResults => 'Total Search Results';

  @override
  String get individualSearchTimes => 'Individual Search Times';

  @override
  String benchmarkSummary(int count, String time) {
    return 'On average, $count documents can be searched in ${time}ms.';
  }

  @override
  String get changeTheme => 'Change Theme';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get systemSettings => 'System Settings';
}

/// The translations for English, as used in the United Kingdom (`en_GB`).
class AppLocalizationsEnGb extends AppLocalizationsEn {
  AppLocalizationsEnGb() : super('en_GB');

  @override
  String get appTitle => 'Search System';

  @override
  String get searchHint => 'Enter search term (e.g., Incheon, airport, Japan)';

  @override
  String get search => 'Search';

  @override
  String searchResults(int count) {
    return 'Search results: $count';
  }

  @override
  String get noResults => 'No results found';

  @override
  String get indexInitializing => 'Initialising index...';

  @override
  String get indexReady => 'Ready! Enter your search term.';

  @override
  String get searching => 'Searching...';

  @override
  String documentCount(int count) {
    return 'Documents: $count';
  }

  @override
  String get addDocument => 'Add Document';

  @override
  String get addMultipleDocuments => 'Add Multiple Documents';

  @override
  String get loadFromJson => 'Load from JSON';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get title => 'Title';

  @override
  String get content => 'Content';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get titleRequired => 'Please enter a title';

  @override
  String get contentRequired => 'Please enter content';

  @override
  String get titleAndContentRequired => 'Please enter both title and content';

  @override
  String get enterTitle => 'Enter document title';

  @override
  String get enterContent => 'Enter document content';

  @override
  String get metadata => 'Metadata';

  @override
  String get metadataJson => 'Metadata (JSON)';

  @override
  String get autoGenerateUuid => 'UUID will be generated automatically';

  @override
  String get editDocument => 'Edit Document';

  @override
  String get deleteDocument => 'Delete Document';

  @override
  String deleteConfirm(String id) {
    return 'Are you sure you want to delete document ID \"$id\"?';
  }

  @override
  String get deleteAllWarning =>
      'Are you sure you want to delete all documents?\nThis action cannot be undone.';

  @override
  String get warning => '⚠️ Warning';

  @override
  String get allDocumentsDeleted => 'All documents have been deleted.';

  @override
  String get enterSearchTerm => 'Please enter a search term.';

  @override
  String get initializingIndex => 'Initialising search index...';

  @override
  String initFailed(String error) {
    return 'Initialisation failed: $error';
  }

  @override
  String searchFailed(String error) {
    return 'Search failed: $error';
  }

  @override
  String addFailed(String error) {
    return 'Failed to add: $error';
  }

  @override
  String updateFailed(String error) {
    return 'Failed to update: $error';
  }

  @override
  String deleteFailed(String error) {
    return 'Failed to delete: $error';
  }

  @override
  String get loadingFromJson => 'Loading documents from JSON...';

  @override
  String jsonLoadFailed(String error) {
    return 'Failed to load JSON: $error';
  }

  @override
  String get bulkAddTitle => 'Add Multiple Documents';

  @override
  String get bulkAddFormat =>
      'Format: title|content|metadata (separated by newlines)';

  @override
  String get documentList => 'Document List';

  @override
  String invalidFormat(String line) {
    return 'Invalid format: $line';
  }

  @override
  String get noDocumentsToAdd => 'No documents to add';
}

/// The translations for English, as used in the United States (`en_US`).
class AppLocalizationsEnUs extends AppLocalizationsEn {
  AppLocalizationsEnUs() : super('en_US');

  @override
  String get appTitle => 'Search System';

  @override
  String get searchHint => 'Enter search term (e.g., Incheon, airport, Japan)';

  @override
  String get search => 'Search';

  @override
  String searchResults(int count) {
    return 'Search results: $count';
  }

  @override
  String get noResults => 'No results found';

  @override
  String get indexInitializing => 'Initializing index...';

  @override
  String get indexReady => 'Ready! Enter your search term.';

  @override
  String get searching => 'Searching...';

  @override
  String documentCount(int count) {
    return 'Documents: $count';
  }

  @override
  String get addDocument => 'Add Document';

  @override
  String get addMultipleDocuments => 'Add Multiple Documents';

  @override
  String get loadFromJson => 'Load from JSON';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get title => 'Title';

  @override
  String get content => 'Content';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get titleRequired => 'Please enter a title';

  @override
  String get contentRequired => 'Please enter content';

  @override
  String get titleAndContentRequired => 'Please enter both title and content';

  @override
  String get enterTitle => 'Enter document title';

  @override
  String get enterContent => 'Enter document content';

  @override
  String get metadata => 'Metadata';

  @override
  String get metadataJson => 'Metadata (JSON)';

  @override
  String get autoGenerateUuid => 'UUID will be generated automatically';

  @override
  String get editDocument => 'Edit Document';

  @override
  String get deleteDocument => 'Delete Document';

  @override
  String deleteConfirm(String id) {
    return 'Are you sure you want to delete document ID \"$id\"?';
  }

  @override
  String get deleteAllWarning =>
      'Are you sure you want to delete all documents?\nThis action cannot be undone.';

  @override
  String get warning => '⚠️ Warning';

  @override
  String get allDocumentsDeleted => 'All documents have been deleted.';

  @override
  String get enterSearchTerm => 'Please enter a search term.';

  @override
  String get initializingIndex => 'Initializing search index...';

  @override
  String initFailed(String error) {
    return 'Initialization failed: $error';
  }

  @override
  String searchFailed(String error) {
    return 'Search failed: $error';
  }

  @override
  String addFailed(String error) {
    return 'Failed to add: $error';
  }

  @override
  String updateFailed(String error) {
    return 'Failed to update: $error';
  }

  @override
  String deleteFailed(String error) {
    return 'Failed to delete: $error';
  }

  @override
  String get loadingFromJson => 'Loading documents from JSON...';

  @override
  String jsonLoadFailed(String error) {
    return 'Failed to load JSON: $error';
  }

  @override
  String get bulkAddTitle => 'Add Multiple Documents';

  @override
  String get bulkAddFormat =>
      'Format: title|content|metadata (separated by newlines)';

  @override
  String get documentList => 'Document List';

  @override
  String invalidFormat(String line) {
    return 'Invalid format: $line';
  }

  @override
  String get noDocumentsToAdd => 'No documents to add';
}
