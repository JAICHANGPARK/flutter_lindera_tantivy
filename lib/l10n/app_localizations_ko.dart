// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '한국어 검색 시스템';

  @override
  String get searchHint => '검색어를 입력하세요 (예: 인천, 공항, 일본)';

  @override
  String get search => '검색';

  @override
  String searchResults(int count) {
    return '검색 결과: $count개';
  }

  @override
  String get noResults => '검색 결과가 없습니다';

  @override
  String get indexInitializing => '인덱스 초기화 중...';

  @override
  String get indexReady => '준비 완료! 검색어를 입력하세요.';

  @override
  String get searching => '검색 중...';

  @override
  String documentCount(int count) {
    return '문서: $count개';
  }

  @override
  String get addDocument => '문서 추가';

  @override
  String get addMultipleDocuments => '여러 문서 추가';

  @override
  String get loadFromJson => 'JSON 파일에서 로드';

  @override
  String get deleteAll => '모두 삭제';

  @override
  String get title => '제목';

  @override
  String get content => '내용';

  @override
  String get cancel => '취소';

  @override
  String get add => '추가';

  @override
  String get edit => '수정';

  @override
  String get delete => '삭제';

  @override
  String get titleRequired => '제목을 입력하세요';

  @override
  String get contentRequired => '내용을 입력하세요';

  @override
  String get titleAndContentRequired => '제목과 내용을 입력해주세요';

  @override
  String get enterTitle => '문서 제목을 입력하세요';

  @override
  String get enterContent => '문서 내용을 입력하세요';

  @override
  String get metadata => 'Metadata';

  @override
  String get metadataJson => 'Metadata (JSON)';

  @override
  String get autoGenerateUuid => 'UUID는 자동으로 생성됩니다';

  @override
  String get editDocument => '문서 수정';

  @override
  String get deleteDocument => '문서 삭제';

  @override
  String deleteConfirm(String id) {
    return '문서 ID \"$id\"를 삭제하시겠습니까?';
  }

  @override
  String get deleteAllWarning => '모든 문서를 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.';

  @override
  String get warning => '⚠️ 경고';

  @override
  String get allDocumentsDeleted => '모든 문서가 삭제되었습니다.';

  @override
  String get enterSearchTerm => '검색어를 입력하세요.';

  @override
  String get initializingIndex => '검색 인덱스 초기화 중...';

  @override
  String initFailed(String error) {
    return '초기화 실패: $error';
  }

  @override
  String searchFailed(String error) {
    return '검색 실패: $error';
  }

  @override
  String addFailed(String error) {
    return '추가 실패: $error';
  }

  @override
  String updateFailed(String error) {
    return '수정 실패: $error';
  }

  @override
  String deleteFailed(String error) {
    return '삭제 실패: $error';
  }

  @override
  String get loadingFromJson => 'JSON 파일에서 문서 로드 중...';

  @override
  String jsonLoadFailed(String error) {
    return 'JSON 로드 실패: $error';
  }

  @override
  String get bulkAddTitle => '여러 문서 추가';

  @override
  String get bulkAddFormat => '형식: 제목|내용|메타데이터 (줄바꿈으로 구분)';

  @override
  String get documentList => '문서 목록';

  @override
  String invalidFormat(String line) {
    return '잘못된 형식: $line';
  }

  @override
  String get noDocumentsToAdd => '추가할 문서가 없습니다';

  @override
  String get webPlatformNotSupported => '웹 플랫폼 미지원';

  @override
  String get webPlatformMessage =>
      '이 앱은 Rust FFI를 사용하므로 웹 플랫폼에서는 지원되지 않습니다.\nmacOS, Windows, Linux, iOS, Android 앱을 사용해주세요.';

  @override
  String get performanceBenchmark => '성능 벤치마크';

  @override
  String get benchmarkSettings => '벤치마크 설정';

  @override
  String get testLanguage => '테스트 언어';

  @override
  String documentCountLabel(String count) {
    return '문서 개수: $count';
  }

  @override
  String get runBenchmark => '벤치마크 실행';

  @override
  String get running => '실행 중...';

  @override
  String get benchmarkPreparing => '벤치마크 준비 중...';

  @override
  String get deletingExisting => '기존 문서 삭제 중...';

  @override
  String indexingStart(int count) {
    return '$count개 문서 인덱싱 시작...';
  }

  @override
  String indexingProgress(int current, int total, String percent) {
    return '인덱싱 중: $current/$total ($percent%)';
  }

  @override
  String indexingComplete(int time, String perDoc) {
    return '인덱싱 완료: ${time}ms (${perDoc}ms/문서)';
  }

  @override
  String get searchPerformanceTest => '검색 성능 테스트 시작...';

  @override
  String searchingQuery(String query, int current, int total) {
    return '검색 중: \"$query\" ($current/$total)';
  }

  @override
  String get completed => '완료!';

  @override
  String get waitMessage => '잠시만 기다려주세요. UI가 일시적으로 느려질 수 있습니다.';

  @override
  String get benchmarkResults => '벤치마크 결과';

  @override
  String get totalIndexingTime => '총 인덱싱 시간';

  @override
  String get avgIndexingTimePerDoc => '문서당 평균 인덱싱 시간';

  @override
  String get searchQueryCount => '검색 쿼리 수';

  @override
  String get totalSearchTime => '총 검색 시간';

  @override
  String get avgSearchTime => '평균 검색 시간';

  @override
  String get totalSearchResults => '총 검색 결과';

  @override
  String get individualSearchTimes => '개별 검색 시간 상세';

  @override
  String benchmarkSummary(int count, String time) {
    return '평균적으로 $count개의 문서를 ${time}ms에 검색할 수 있습니다.';
  }
}
