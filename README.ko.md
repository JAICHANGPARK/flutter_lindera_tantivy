# flutter_lindera_tantivy

[English](README.md) | [日本語](README.ja.md) | 한국어 | [中文](README.zh.md)

Tantivy 검색 엔진과 Lindera 형태소 분석을 활용한 고성능 전문 검색 기능을 제공하는 Flutter FFI 플러그인입니다. 내장 사전으로 한국어, 일본어(IPADIC/UniDic), 중국어 텍스트를 지원합니다.

### 주요 기능

- 🚀 **고성능 검색**: Rust의 Tantivy 검색 엔진 기반
- 🔍 **형태소 분석**: Lindera를 통한 정확한 아시아 언어 토큰화
- 🌏 **다국어 지원**: 한국어, 일본어(IPADIC/UniDic), 중국어
- 📱 **크로스 플랫폼**: Android, iOS, Linux, macOS, Windows
- 💾 **유연한 저장소**: 메모리 또는 디스크 기반 인덱스 저장
- ⚡ **네이티브 성능**: flutter_rust_bridge를 통한 직접 Rust FFI 바인딩

### 지원 언어

- **한국어**: Ko-dic 내장 사전
- **일본어(IPADIC)**: 현대 일본어용 IPA 사전
- **일본어(UniDic)**: 현대 문어체용 UniDic 사전
- **중국어**: CC-CEDICT 사전

### 설치

`pubspec.yaml`에 추가:

```yaml
dependencies:
  flutter_lindera_tantivy: ^0.0.1
```

### 빠른 시작

```dart
import 'package:flutter_lindera_tantivy/flutter_lindera_tantivy.dart';

// Rust 라이브러리 초기화
await RustLib.init();

// 한국어 사전으로 검색 인덱스 초기화
initializeSearchIndex(dictionaryType: DictionaryType.korean);

// 문서 추가
addDocument(
  title: "Flutter 튜토리얼",
  body: "Flutter 개발 배우기",
  metadataJson: '{"category": "tutorial"}',
);

// 문서 검색
final results = searchDocuments(
  queryStr: "Flutter",
  limit: BigInt.from(10),
);

for (var result in results) {
  print('${result.title}: ${result.score}');
}
```

### API 참조

#### 인덱스 초기화

```dart
// 메모리 인덱스
String initializeSearchIndex({required DictionaryType dictionaryType})

// 디스크 기반 인덱스
String initializeSearchIndexWithPath({
  required DictionaryType dictionaryType,
  required String indexPath,
})
```

#### 문서 관리

```dart
// 단일 문서 추가
String addDocument({
  required String title,
  required String body,
  required String metadataJson,
})

// 여러 문서 추가
String addDocuments({required List<DocumentInput> documents})

// 문서 업데이트
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

// 문서 개수 조회
BigInt getDocumentCount()
```

#### 검색

```dart
List<SearchResult> searchDocuments({
  required String queryStr,
  required BigInt limit,
})
```

### 라이선스

[LICENSE](LICENSE) 파일을 참조하세요.

### 저장소

https://github.com/JAICHANGPARK/flutter_lindera_tantivy
