# Tantivy 한국어 검색 API 사용 가이드

## 개요

이 프로젝트는 Rust의 Tantivy 검색 엔진과 Lindera 한국어 형태소 분석기를 Flutter 앱에 통합한 예제입니다.

## 주요 기능

### 1. 검색 인덱스 초기화
```dart
final result = initializeSearchIndex();
// "검색 인덱스가 초기화되었습니다."
```

### 2. 샘플 문서 인덱싱
```dart
final result = indexSampleDocuments();
// "총 8개의 문서가 인덱싱되었습니다."
```

샘플 데이터:
- 나리타 국제공항
- 도쿄 국제공항
- 간사이 국제공항
- 인천국제공항
- 김포국제공항
- 제주국제공항
- 싱가포르 창이공항
- 홍콩국제공항

### 3. 문서 검색
```dart
final results = searchDocuments(
  queryStr: "인천",
  limit: BigInt.from(10),
);

// results는 List<SearchResult>
for (var result in results) {
  print('제목: ${result.title}');
  print('내용: ${result.body}');
  print('점수: ${result.score}');
  print('ID: ${result.id}');
}
```

### 4. 단일 문서 추가
```dart
final result = addDocument(
  id: "9",
  title: "방콕 수완나품 국제공항",
  body: "방콕 수완나품 국제공항은 태국 방콕에 위치한 국제공항입니다.",
);
// "문서 ID '9'가 추가되었습니다."
```

### 5. 여러 문서 한 번에 추가 ⭐ NEW
```dart
final documents = [
  DocumentInput(
    id: "9",
    title: "베이징 수도 국제공항",
    body: "베이징 수도 국제공항은 중국 베이징에 위치한 공항입니다.",
  ),
  DocumentInput(
    id: "10",
    title: "상하이 푸동 국제공항",
    body: "상하이 푸동 국제공항은 중국 상하이에 위치한 공항입니다.",
  ),
];

final result = addDocuments(documents: documents);
// "총 2개의 문서가 추가되었습니다."
```

### 6. 문서 수정 ⭐ NEW
```dart
final result = updateDocument(
  id: "9",
  title: "베이징 수도 국제공항 (업데이트)",
  body: "베이징 수도 국제공항은 중국의 주요 국제공항입니다.",
);
// "문서 ID '9'가 업데이트되었습니다."
```

### 7. 단일 문서 삭제 ⭐ NEW
```dart
final result = deleteDocument(id: "9");
// "문서 ID '9'가 삭제되었습니다."
```

### 8. 여러 문서 삭제 ⭐ NEW
```dart
final result = deleteDocuments(ids: ["9", "10", "11"]);
// "총 3개의 문서가 삭제되었습니다."
```

### 9. 모든 문서 삭제 ⭐ NEW
```dart
final result = clearAllDocuments();
// "모든 문서가 삭제되었습니다."
```

### 10. 문서 개수 조회 ⭐ NEW
```dart
final count = getDocumentCount();
print('총 문서 개수: $count');
// 총 문서 개수: 8
```

## 검색 예제

### 한국어 검색
```dart
// "인천" 검색 - 인천국제공항 관련 문서가 나옴
searchDocuments(queryStr: "인천", limit: BigInt.from(10));

// "일본" 검색 - 나리타, 도쿄, 간사이 공항이 나옴
searchDocuments(queryStr: "일본", limit: BigInt.from(10));

// "공항" 검색 - 모든 공항 문서가 나옴
searchDocuments(queryStr: "공항", limit: BigInt.from(10));
```

## 데이터 구조

### SearchResult
```dart
class SearchResult {
  String id;        // 문서 ID
  String title;     // 제목
  String body;      // 본문
  double score;     // 검색 점수 (높을수록 관련성이 높음)
}
```

### DocumentInput
```dart
class DocumentInput {
  String id;        // 문서 ID
  String title;     // 제목
  String body;      // 본문
}
```

## Flutter UI 기능

앱에 구현된 주요 기능:

### 1. 검색 기능
- 검색창에서 한국어로 검색
- 실시간 검색 결과 표시
- 검색 점수와 문서 ID 표시

### 2. 문서 관리 (오른쪽 상단 메뉴)
- **문서 추가**: 단일 문서를 추가하는 대화상자
- **여러 문서 추가**: 여러 문서를 한 번에 추가 (파이프 구분: `ID|제목|내용`)
- **모두 삭제**: 모든 문서를 삭제

### 3. 검색 결과 항목별 기능
- **수정 버튼**: 문서의 제목과 내용 수정
- **삭제 버튼**: 해당 문서 삭제

### 4. 문서 개수 표시
- 상단 바에 현재 인덱스된 문서 개수 표시

## 여러 문서 추가 형식

메뉴에서 "여러 문서 추가"를 선택하면 다음 형식으로 입력:

```
9|베이징공항|베이징 수도 국제공항입니다
10|상하이공항|상하이 푸동 국제공항입니다
11|광저우공항|광저우 바이윈 국제공항입니다
```

- 각 줄은 하나의 문서
- `|` (파이프)로 ID, 제목, 내용 구분
- 빈 줄은 무시됨

## 앱 실행 방법

### 1. 의존성 설치
```bash
flutter pub get
```

### 2. 앱 실행
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# macOS
flutter run -d macos

# 웹
flutter run -d chrome
```

## 주요 특징

- **한국어 형태소 분석**: Lindera의 ko-dic을 사용하여 정확한 한국어 검색 지원
- **인메모리 인덱스**: 빠른 성능을 위해 메모리에 인덱스 저장
- **동기 API**: `#[flutter_rust_bridge::frb(sync)]`를 사용하여 간단한 동기 호출
- **에러 처리**: Result 타입을 사용한 안전한 에러 처리
- **CRUD 완전 지원**: Create, Read, Update, Delete 모든 작업 지원
- **대량 작업**: 여러 문서를 한 번에 추가/삭제 가능

## 기술 스택

- **검색 엔진**: Tantivy 0.25.0
- **형태소 분석기**: Lindera 1.3.2 (embedded ko-dic)
- **Flutter-Rust Bridge**: 2.11.1
- **Flutter**: Material Design 3

## API 함수 목록

| 함수 | 설명 | 반환 타입 |
|------|------|-----------|
| `initializeSearchIndex()` | 검색 인덱스 초기화 | `Result<String, String>` |
| `indexSampleDocuments()` | 샘플 문서 인덱싱 | `Result<String, String>` |
| `searchDocuments(queryStr, limit)` | 문서 검색 | `Result<List<SearchResult>, String>` |
| `addDocument(id, title, body)` | 단일 문서 추가 | `Result<String, String>` |
| `addDocuments(documents)` | 여러 문서 추가 | `Result<String, String>` |
| `updateDocument(id, title, body)` | 문서 수정 | `Result<String, String>` |
| `deleteDocument(id)` | 단일 문서 삭제 | `Result<String, String>` |
| `deleteDocuments(ids)` | 여러 문서 삭제 | `Result<String, String>` |
| `clearAllDocuments()` | 모든 문서 삭제 | `Result<String, String>` |
| `getDocumentCount()` | 문서 개수 조회 | `Result<u64, String>` |

## 사용 시나리오

### 시나리오 1: 검색 앱 초기화
```dart
// 1. 인덱스 초기화
initializeSearchIndex();

// 2. 샘플 데이터 로드
indexSampleDocuments();

// 3. 문서 개수 확인
final count = getDocumentCount();
```

### 시나리오 2: 사용자 데이터 추가
```dart
// 단일 문서 추가
addDocument(
  id: "user_1",
  title: "나의 여행 기록",
  body: "2024년 제주도 여행 기록입니다.",
);

// 검색 확인
final results = searchDocuments(queryStr: "제주", limit: BigInt.from(5));
```

### 시나리오 3: 대량 데이터 임포트
```dart
final bulkData = [
  DocumentInput(id: "1", title: "문서1", body: "내용1"),
  DocumentInput(id: "2", title: "문서2", body: "내용2"),
  DocumentInput(id: "3", title: "문서3", body: "내용3"),
];

addDocuments(documents: bulkData);
```

### 시나리오 4: 문서 관리
```dart
// 문서 수정
updateDocument(id: "1", title: "수정된 제목", body: "수정된 내용");

// 특정 문서 삭제
deleteDocument(id: "1");

// 여러 문서 삭제
deleteDocuments(ids: ["2", "3", "4"]);

// 전체 초기화
clearAllDocuments();
indexSampleDocuments(); // 다시 샘플 데이터 로드
```

## 참고사항

- 모든 함수는 동기(sync) 방식으로 동작합니다
- 인덱스는 앱이 실행되는 동안 메모리에 유지됩니다
- 앱을 재시작하면 인덱스도 초기화됩니다
- 실제 프로덕션에서는 디스크에 인덱스를 저장하는 것을 권장합니다
- 한국어 형태소 분석은 자동으로 처리되므로 "공항"과 "국제공항" 모두 검색됩니다

## 성능 팁

1. **대량 추가 시**: `addDocuments()`를 사용하여 한 번에 여러 문서 추가
2. **검색 최적화**: `limit` 파라미터를 적절히 설정하여 필요한 만큼만 검색
3. **인덱스 관리**: 정기적으로 불필요한 문서 삭제하여 인덱스 크기 관리
