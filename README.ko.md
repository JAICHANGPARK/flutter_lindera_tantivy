# flutter_lindera_tantivy

[English](https://github.com/JAICHANGPARK/flutter_lindera_tantivy/blob/main/README.md) | [日本語](https://github.com/JAICHANGPARK/flutter_lindera_tantivy/blob/main/README.ja.md) | 한국어 | [中文](https://github.com/JAICHANGPARK/flutter_lindera_tantivy/blob/main/README.zh.md)

Tantivy 검색 엔진과 Lindera 4.0 형태소 분석기 기반의 고성능 Flutter 전문 검색(Full-text search) 및 형태소 분석 FFI 플러그인입니다. 내장 사전을 통해 한국어, 일본어(IPADIC/UniDic), 중국어를 지원합니다.

### 주요 기능

- 🚀 **고성능 검색**: Rust 기반 Tantivy 엔진 (v0.25) & Lindera (v4.0) 적용
- 🔍 **단독 형태소 분석**: CJK 텍스트를 바로 토큰화하거나 세부 품사(POS) 태그 추출
- 🌏 **다국어 지원**: 한국어(Ko-dic), 일본어(IPADIC/UniDic), 중국어(CC-CEDICT)
- 📱 **크로스 플랫폼**: Android, iOS, Linux, macOS, Windows 지원
- 💾 **유연한 저장소**: 인메모리(RAM) 및 디스크 기반 인덱스 저장 지원
- ⚡ **네이티브 성능**: `flutter_rust_bridge` 기반의 직관적인 Rust FFI 연동

### 지원 언어 및 사전

- **한국어**: 내장 `Ko-dic` 사전
- **일본어 (IPADIC)**: 현대 일본어용 IPA 사전
- **일본어 (UniDic)**: 구어체/서면어 맞춤 UniDic 사전
- **중국어**: `CC-CEDICT` 사전

### 설치 방법

`pubspec.yaml`에 패키지를 추가하세요:

```yaml
dependencies:
  flutter_lindera_tantivy: ^2026.7.26
```

### 빠른 시작 (Quick Start)

#### 1. 전문 검색 (Full-Text Search)

```dart
import 'package:flutter_lindera_tantivy/flutter_lindera_tantivy.dart';

// Rust 라이브러리 초기화
await RustLib.init();

// 한국어 사전을 사용하여 검색 인덱스 초기화
initializeSearchIndex(dictionaryType: DictionaryType.korean);

// 문서 추가
addDocument(
  title: "플러터 튜토리얼",
  body: "Lindera를 활용한 플러터 전문 검색 개발",
  metadataJson: '{"category": "tutorial"}',
);

// 문서 검색
final results = searchDocuments(
  queryStr: "플러터",
  limit: BigInt.from(10),
);

for (var result in results) {
  print('${result.title}: ${result.score}');
}
```

#### 2. 형태소 분석 (Tokenization)

```dart
import 'package:flutter_lindera_tantivy/flutter_lindera_tantivy.dart';

// 단독 형태소 토큰화
final tokens = tokenizeText(
  dictionaryType: DictionaryType.korean,
  text: "한국어 형태소 분석 테스트",
  mode: TokenMode.normal,
);
print(tokens); // ['한국어', '형태소', '분석', '테스트']

// 품사(POS) 정보가 포함된 세부 형태소 분석
final details = tokenizeTextDetailed(
  dictionaryType: DictionaryType.korean,
  text: "한국어 형태소 분석",
  mode: TokenMode.normal,
);

for (var token in details) {
  print('${token.surface} [${token.pos}]: ${token.details.join(", ")}');
}
```

### API 레퍼런스

#### 형태소 분석 API

```dart
// 표형 텍스트 리스트 추출
List<String> tokenizeText({
  required DictionaryType dictionaryType,
  required String text,
  required TokenMode mode,
})

// 품사 및 속성이 포함된 상세 TokenDetail 리스트 추출
List<TokenDetail> tokenizeTextDetailed({
  required DictionaryType dictionaryType,
  required String text,
  required TokenMode mode,
})
```

#### 인덱스 초기화 API

```dart
// 인메모리(RAM) 인덱스
String initializeSearchIndex({required DictionaryType dictionaryType})

// 디스크 기반 인덱스
String initializeSearchIndexWithPath({
  required DictionaryType dictionaryType,
  required String indexPath,
})
```

#### 문서 관리 API

```dart
// 단일 문서 추가
String addDocument({
  required String title,
  required String body,
  required String metadataJson,
})

// 다중 문서 추가
String addDocuments({required List<DocumentInput> documents})

// 문서 수정
String updateDocument({
  required String id,
  required String title,
  required String body,
  required String metadataJson,
})

// 문서 삭제
String deleteDocument({required String id})
String deleteDocuments({required List<String> ids})
String clearAllDocuments()

// 전체 문서 수 조회
BigInt getDocumentCount()
```

#### 검색 API

```dart
List<SearchResult> searchDocuments({
  required String queryStr,
  required BigInt limit,
})
```

### 라이선스

[LICENSE](LICENSE) 파일을 참고하세요.
