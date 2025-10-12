import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:tantivy_flutter_app/src/rust/api/search.dart';

class BenchmarkResult {
  final int documentCount;
  final Duration indexingTime;
  final Duration searchTime;
  final int searchResultCount;
  final List<Duration> individualSearchTimes;

  BenchmarkResult({
    required this.documentCount,
    required this.indexingTime,
    required this.searchTime,
    required this.searchResultCount,
    required this.individualSearchTimes,
  });

  double get averageSearchTimeMs =>
      searchTime.inMicroseconds / 1000.0 / individualSearchTimes.length;
  double get indexingTimePerDocMs =>
      indexingTime.inMicroseconds / 1000.0 / documentCount;
}

class BenchmarkService {
  static final Random _random = Random();

  // 한국어 샘플 단어 풀
  static const List<String> _koreanWords = [
    '안녕하세요', '검색', '시스템', '성능', '테스트', '벤치마크', '데이터', '분석',
    '결과', '속도', '인덱스', '문서', '처리', '최적화', '알고리즘', '개발',
    '프로그램', '소프트웨어', '하드웨어', '네트워크', '데이터베이스', '서버',
    '클라이언트', '인터페이스', '사용자', '관리', '설정', '기능', '구현', '디자인',
    '서울', '부산', '대구', '인천', '광주', '대전', '울산', '세종',
    '경기도', '강원도', '충청도', '전라도', '경상도', '제주도',
    '공항', '항만', '도로', '철도', '지하철', '버스', '자동차', '비행기', '선박', '기차',
    '회사', '학교', '병원', '은행', '상점', '레스토랑', '카페', '호텔', '공원', '도서관',
    '한국', '일본', '중국', '미국', '영국', '독일', '프랑스', '이탈리아', '스페인', '캐나다',
  ];

  static const List<String> _englishWords = [
    'hello', 'search', 'system', 'performance', 'test', 'benchmark', 'data', 'analysis',
    'result', 'speed', 'index', 'document', 'process', 'optimization', 'algorithm', 'development',
    'program', 'software', 'hardware', 'network', 'database', 'server',
    'client', 'interface', 'user', 'management', 'settings', 'feature', 'implementation', 'design',
    'Seoul', 'Busan', 'Daegu', 'Incheon', 'Gwangju', 'Daejeon', 'Ulsan', 'Sejong',
    'airport', 'port', 'road', 'railway', 'subway', 'bus', 'car', 'airplane', 'ship', 'train',
    'company', 'school', 'hospital', 'bank', 'store', 'restaurant', 'cafe', 'hotel', 'park', 'library',
    'Korea', 'Japan', 'China', 'USA', 'UK', 'Germany', 'France', 'Italy', 'Spain', 'Canada',
  ];

  static const List<String> _japaneseWords = [
    'こんにちは', '検索', 'システム', '性能', 'テスト', 'ベンチマーク', 'データ', '分析',
    '結果', '速度', 'インデックス', '文書', '処理', '最適化', 'アルゴリズム', '開発',
    'プログラム', 'ソフトウェア', 'ハードウェア', 'ネットワーク', 'データベース', 'サーバー',
    'クライアント', 'インターフェース', 'ユーザー', '管理', '設定', '機能', '実装', 'デザイン',
    'ソウル', '釜山', '大邱', '仁川', '光州', '大田', '蔚山', '世宗',
    '空港', '港湾', '道路', '鉄道', '地下鉄', 'バス', '自動車', '飛行機', '船', '列車',
    '会社', '学校', '病院', '銀行', '店舗', 'レストラン', 'カフェ', 'ホテル', '公園', '図書館',
    '韓国', '日本', '中国', 'アメリカ', 'イギリス', 'ドイツ', 'フランス', 'イタリア', 'スペイン', 'カナダ',
  ];

  static const List<String> _chineseWords = [
    '你好', '搜索', '系统', '性能', '测试', '基准', '数据', '分析',
    '结果', '速度', '索引', '文档', '处理', '优化', '算法', '开发',
    '程序', '软件', '硬件', '网络', '数据库', '服务器',
    '客户端', '界面', '用户', '管理', '设置', '功能', '实现', '设计',
    '首尔', '釜山', '大邱', '仁川', '光州', '大田', '蔚山', '世宗',
    '机场', '港口', '道路', '铁路', '地铁', '公交车', '汽车', '飞机', '船', '火车',
    '公司', '学校', '医院', '银行', '商店', '餐厅', '咖啡馆', '酒店', '公园', '图书馆',
    '韩国', '日本', '中国', '美国', '英国', '德国', '法国', '意大利', '西班牙', '加拿大',
  ];

  static const Map<String, List<String>> _categoriesByLanguage = {
    'ko': ['뉴스', '기술', '과학', '경제', '문화', '스포츠', '여행', '음식', '건강', '교육'],
    'en': ['News', 'Technology', 'Science', 'Economy', 'Culture', 'Sports', 'Travel', 'Food', 'Health', 'Education'],
    'ja': ['ニュース', '技術', '科学', '経済', '文化', 'スポーツ', '旅行', '食べ物', '健康', '教育'],
    'zh': ['新闻', '技术', '科学', '经济', '文化', '体育', '旅游', '美食', '健康', '教育'],
  };

  static const Map<String, String> _documentLabelByLanguage = {
    'ko': '문서',
    'en': 'Document',
    'ja': '文書',
    'zh': '文档',
  };

  /// 언어별 단어 풀 가져오기
  static List<String> _getWordsByLanguage(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return _koreanWords;
      case 'en':
        return _englishWords;
      case 'ja':
        return _japaneseWords;
      case 'zh':
        return _chineseWords;
      default:
        return _koreanWords;
    }
  }

  /// 랜덤 문장 생성 (다국어 지원)
  static String _generateRandomSentence(int wordCount, String languageCode) {
    final words = _getWordsByLanguage(languageCode);
    final selectedWords = List.generate(
      wordCount,
      (_) => words[_random.nextInt(words.length)],
    );
    return selectedWords.join(' ');
  }

  /// 테스트 문서 데이터 생성 (다국어 지원)
  static Map<String, dynamic> generateTestDocument(int index, String languageCode) {
    final categories = _categoriesByLanguage[languageCode] ?? _categoriesByLanguage['ko']!;
    final documentLabel = _documentLabelByLanguage[languageCode] ?? '문서';

    final category = categories[_random.nextInt(categories.length)];
    final title = '$category $documentLabel #$index: ${_generateRandomSentence(3, languageCode)}';
    final body = List.generate(
      5 + _random.nextInt(10),
      (_) => _generateRandomSentence(10 + _random.nextInt(20), languageCode),
    ).join('. ');

    final metadata = {
      'category': category,
      'index': index,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'wordCount': body.split(' ').length,
      'author': 'Author ${_random.nextInt(100)}',
      'tags': List.generate(
        2 + _random.nextInt(4),
        (_) => _koreanWords[_random.nextInt(_koreanWords.length)],
      ),
    };

    return {
      'title': title,
      'body': body,
      'metadata': metadata,
    };
  }

  /// 벤치마크 실행
  static Future<BenchmarkResult> runBenchmark({
    required int documentCount,
    required List<String> searchQueries,
    required Function(String) onProgress,
    String languageCode = 'ko',
  }) async {
    // 1. 기존 문서 삭제
    onProgress('기존 문서 삭제 중...');
    clearAllDocuments();
    await Future.delayed(const Duration(milliseconds: 100));

    // 2. 문서 인덱싱 시작
    onProgress('$documentCount개 문서 인덱싱 시작...');
    final indexingStart = DateTime.now();

    // 배치 크기 설정 (UI 블로킹 방지)
    const batchSize = 50;

    for (int i = 0; i < documentCount; i++) {
      final doc = generateTestDocument(i, languageCode);
      addDocument(
        title: doc['title'],
        body: doc['body'],
        metadataJson: _encodeMetadata(doc['metadata']),
      );

      // 배치마다 UI 업데이트 및 yield
      if (i % batchSize == 0) {
        onProgress('인덱싱 중: ${i + 1}/$documentCount (${((i + 1) / documentCount * 100).toStringAsFixed(1)}%)');
        // UI 스레드에 제어권 반환
        await Future.delayed(const Duration(milliseconds: 1));
      }
    }

    final indexingEnd = DateTime.now();
    final indexingTime = indexingEnd.difference(indexingStart);
    onProgress(
        '인덱싱 완료: ${indexingTime.inMilliseconds}ms (${(indexingTime.inMilliseconds / documentCount).toStringAsFixed(2)}ms/문서)');

    await Future.delayed(const Duration(milliseconds: 500));

    // 3. 검색 성능 테스트
    onProgress('검색 성능 테스트 시작...');
    final searchTimes = <Duration>[];
    int totalResults = 0;

    for (int i = 0; i < searchQueries.length; i++) {
      final query = searchQueries[i];
      onProgress('검색 중: "${query}" (${i + 1}/${searchQueries.length})');

      final searchStart = DateTime.now();
      final results = searchDocuments(
        queryStr: query,
        limit: BigInt.from(10),
      );
      final searchEnd = DateTime.now();

      final searchTime = searchEnd.difference(searchStart);
      searchTimes.add(searchTime);
      totalResults += results.length;

      debugPrint(
          '검색 "$query": ${results.length}건, ${searchTime.inMicroseconds / 1000}ms');

      // UI 업데이트를 위한 짧은 대기
      await Future.delayed(const Duration(milliseconds: 10));
    }

    final totalSearchTime = searchTimes.fold<Duration>(
      Duration.zero,
      (prev, time) => prev + time,
    );

    onProgress('벤치마크 완료!');

    return BenchmarkResult(
      documentCount: documentCount,
      indexingTime: indexingTime,
      searchTime: totalSearchTime,
      searchResultCount: totalResults,
      individualSearchTimes: searchTimes,
    );
  }

  /// 기본 검색 쿼리 생성 (다국어 지원)
  static List<String> generateDefaultSearchQueries(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return [
          '서울', '공항', '검색', '시스템', '데이터', '분석', '개발',
          '서울 공항', '검색 시스템', '데이터 분석', '성능 테스트',
          '인덱스 최적화', '한국 기술', '뉴스 경제', '여행 호텔',
        ];
      case 'en':
        return [
          'Seoul', 'airport', 'search', 'system', 'data', 'analysis', 'development',
          'Seoul airport', 'search system', 'data analysis', 'performance test',
          'index optimization', 'Korea technology', 'news economy', 'travel hotel',
        ];
      case 'ja':
        return [
          'ソウル', '空港', '検索', 'システム', 'データ', '分析', '開発',
          'ソウル 空港', '検索 システム', 'データ 分析', '性能 テスト',
          'インデックス 最適化', '韓国 技術', 'ニュース 経済', '旅行 ホテル',
        ];
      case 'zh':
        return [
          '首尔', '机场', '搜索', '系统', '数据', '分析', '开发',
          '首尔 机场', '搜索 系统', '数据 分析', '性能 测试',
          '索引 优化', '韩国 技术', '新闻 经济', '旅游 酒店',
        ];
      default:
        return generateDefaultSearchQueries('ko');
    }
  }

  static String _encodeMetadata(Map<String, dynamic> metadata) {
    final buffer = StringBuffer('{');
    final entries = metadata.entries.toList();

    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      buffer.write('"${entry.key}":');

      final value = entry.value;
      if (value is String) {
        buffer.write('"${value.replaceAll('"', '\\"')}"');
      } else if (value is List) {
        buffer.write('[');
        for (int j = 0; j < value.length; j++) {
          if (j > 0) buffer.write(',');
          if (value[j] is String) {
            buffer.write('"${value[j].toString().replaceAll('"', '\\"')}"');
          } else {
            buffer.write(value[j].toString());
          }
        }
        buffer.write(']');
      } else {
        buffer.write(value.toString());
      }

      if (i < entries.length - 1) buffer.write(',');
    }
    buffer.write('}');

    return buffer.toString();
  }
}
