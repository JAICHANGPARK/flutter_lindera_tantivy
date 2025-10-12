# Flutter Lindera Tantivy

Lindera 토크나이저와 Tantivy 검색 엔진을 사용한 한국어 지원 고성능 전문 검색 애플리케이션입니다. Flutter와 Rust로 구축되었습니다.

[English](README.md) | [日本語](README.ja.md)

## 주요 기능

- **🔍 전문 검색**: BM25 랭킹을 사용하는 Tantivy 검색 엔진 기반
- **🇰🇷 한국어 지원**: Lindera 토크나이저를 사용한 고급 한국어 텍스트 분석
- **⚡ 고성능**: Flutter Rust Bridge(FFI)를 통한 Rust 기반 백엔드
- **🌍 다국어 UI**: 한국어, 영어, 일본어, 중국어 지원
- **🎨 테마 지원**: 라이트 모드, 다크 모드, 시스템 테마
- **📱 크로스 플랫폼**: macOS, Windows, Linux, iOS, Android 지원
- **💾 영구 저장소**: 자동 영속성을 가진 로컬 문서 인덱싱
- **📊 성능 벤치마크**: 최대 10,000개 문서로 인덱싱 및 검색 성능을 측정하는 내장 도구

## 기술 스택

### 프론트엔드
- **Flutter**: 크로스 플랫폼 UI 프레임워크
- **Riverpod**: 상태 관리
- **Material 3**: 현대적인 디자인 시스템

### 백엔드
- **Rust**: 고성능 검색 엔진
- **Tantivy**: 전문 검색 라이브러리
- **Lindera**: 다국어 형태소 분석기
- **flutter_rust_bridge**: Flutter와 Rust 간의 FFI 브릿지

## 시작하기

### 필수 요구사항

- Flutter SDK (^3.9.2)
- Rust 툴체인
- 플랫폼별 개발 도구:
  - macOS: Xcode
  - Windows: C++ 지원이 포함된 Visual Studio
  - Linux: GCC/Clang
  - iOS: Xcode
  - Android: Android Studio

### 설치 방법

1. 저장소 복제:
```bash
git clone https://github.com/yourusername/flutter_lindera_tantivy.git
cd flutter_lindera_tantivy
```

2. Flutter 의존성 설치:
```bash
flutter pub get
```

3. 코드 생성:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. 앱 실행:
```bash
# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux

# iOS (실제 기기 또는 시뮬레이터 필요)
flutter run -d ios

# Android
flutter run -d android
```

## 사용 방법

### 문서 추가하기

1. **"문서 추가"** 버튼(플로팅 액션 버튼) 클릭
2. 제목과 내용 입력
3. 선택적으로 JSON 형식의 메타데이터 추가
4. **"추가"** 클릭하여 문서 인덱싱

### 문서 검색하기

1. 검색창에 검색어 입력
2. Enter 키를 누르거나 **"검색"** 버튼 클릭
3. BM25 알고리즘을 사용하여 관련성에 따라 결과 순위 지정

### 문서 관리하기

- **수정**: 검색 결과 카드의 수정 버튼 클릭
- **삭제**: 검색 결과 카드의 삭제 버튼 클릭
- **JSON에서 로드**: 메뉴를 사용하여 JSON 파일에서 문서 일괄 가져오기
- **모두 삭제**: 인덱싱된 모든 문서 삭제 (확인 필요)

### 테마 커스터마이징

앱 바의 테마 아이콘을 클릭하여 선택:
- 🌞 라이트 모드
- 🌙 다크 모드
- ⚙️ 시스템 모드 (시스템 설정 따름)

### 언어 선택

앱 바의 언어 아이콘을 클릭하여 전환:
- 🇰🇷 한국어
- 🇺🇸 영어
- 🇯🇵 일본어
- 🇨🇳 중국어

### 성능 벤치마크

메뉴에서 벤치마크 도구에 접근하여 검색 성능 측정:

1. 메뉴에서 **"성능 벤치마크"** 옵션 선택
2. 테스트 언어 선택 (한국어, 영어, 일본어, 중국어)
3. 슬라이더를 사용하여 문서 개수 조정 (100 - 10,000개)
4. **"벤치마크 실행"** 클릭하여 테스트 시작
5. 다음을 포함한 상세 결과 확인:
   - 총 인덱싱 시간
   - 문서당 평균 시간
   - 쿼리당 평균 검색 시간
   - 개별 쿼리 성능 지표

벤치마크 기능의 용도:
- 대용량 데이터셋으로 검색 엔진 성능 테스트
- 다양한 언어 간 성능 비교
- 인덱싱 및 검색 속도 측정
- 검색 구성 최적화

## 아키텍처

```
lib/
├── l10n/                 # 로컬라이제이션 파일
├── models/              # 데이터 모델
├── providers/           # Riverpod 상태 프로바이더
├── screens/             # 앱 화면
├── services/            # 비즈니스 로직
├── widgets/             # 재사용 가능한 UI 컴포넌트
└── src/rust/            # 생성된 Rust FFI 바인딩

rust/
└── src/
    └── api/             # Rust 검색 API
```

## 플랫폼 지원

| 플랫폼    | 지원 여부 | 비고 |
|----------|-----------|------|
| macOS    | ✅ | 완전 지원 |
| Windows  | ✅ | 완전 지원 |
| Linux    | ✅ | 완전 지원 |
| iOS      | ✅ | 완전 지원 |
| Android  | ✅ | 완전 지원 |
| Web      | ❌ | 미지원 (FFI 필요) |

## 의존성

### Flutter 패키지
- `flutter_riverpod`: 상태 관리
- `riverpod_annotation`: Riverpod 코드 생성
- `flutter_rust_bridge`: Rust FFI 통합
- `path_provider`: 로컬 저장소 액세스
- `shared_preferences`: 영구 키-값 저장소

### Rust 크레이트
- `tantivy`: 전문 검색 엔진
- `lindera`: 형태소 분석기
- `lindera-tantivy`: Lindera의 Tantivy 통합
- `serde_json`: JSON 직렬화

## 기여하기

기여를 환영합니다! Pull Request를 자유롭게 제출해주세요.

1. 저장소 포크
2. 기능 브랜치 생성 (`git checkout -b feature/AmazingFeature`)
3. 변경사항 커밋 (`git commit -m 'Add some AmazingFeature'`)
4. 브랜치에 푸시 (`git push origin feature/AmazingFeature`)
5. Pull Request 열기

## 라이선스

이 프로젝트는 MIT 라이선스에 따라 라이선스가 부여됩니다. 자세한 내용은 LICENSE 파일을 참조하세요.

## 감사의 말

- [Tantivy](https://github.com/tantivy-search/tantivy) - 빠른 전문 검색 엔진 라이브러리
- [Lindera](https://github.com/lindera-morphology/lindera) - 형태소 분석기
- [Flutter Rust Bridge](https://github.com/fzyzcjy/flutter_rust_bridge) - 고수준 FFI 브릿지

## 연락처

프로젝트 링크: [https://github.com/yourusername/flutter_lindera_tantivy](https://github.com/yourusername/flutter_lindera_tantivy)
