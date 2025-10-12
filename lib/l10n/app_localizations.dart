import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('en', 'GB'),
    Locale('en', 'US'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ko, this message translates to:
  /// **'한국어 검색 시스템'**
  String get appTitle;

  /// No description provided for @searchHint.
  ///
  /// In ko, this message translates to:
  /// **'검색어를 입력하세요 (예: 인천, 공항, 일본)'**
  String get searchHint;

  /// No description provided for @search.
  ///
  /// In ko, this message translates to:
  /// **'검색'**
  String get search;

  /// No description provided for @searchResults.
  ///
  /// In ko, this message translates to:
  /// **'검색 결과: {count}개'**
  String searchResults(int count);

  /// No description provided for @noResults.
  ///
  /// In ko, this message translates to:
  /// **'검색 결과가 없습니다'**
  String get noResults;

  /// No description provided for @indexInitializing.
  ///
  /// In ko, this message translates to:
  /// **'인덱스 초기화 중...'**
  String get indexInitializing;

  /// No description provided for @indexReady.
  ///
  /// In ko, this message translates to:
  /// **'준비 완료! 검색어를 입력하세요.'**
  String get indexReady;

  /// No description provided for @searching.
  ///
  /// In ko, this message translates to:
  /// **'검색 중...'**
  String get searching;

  /// No description provided for @documentCount.
  ///
  /// In ko, this message translates to:
  /// **'문서: {count}개'**
  String documentCount(int count);

  /// No description provided for @addDocument.
  ///
  /// In ko, this message translates to:
  /// **'문서 추가'**
  String get addDocument;

  /// No description provided for @addMultipleDocuments.
  ///
  /// In ko, this message translates to:
  /// **'여러 문서 추가'**
  String get addMultipleDocuments;

  /// No description provided for @loadFromJson.
  ///
  /// In ko, this message translates to:
  /// **'JSON 파일에서 로드'**
  String get loadFromJson;

  /// No description provided for @deleteAll.
  ///
  /// In ko, this message translates to:
  /// **'모두 삭제'**
  String get deleteAll;

  /// No description provided for @title.
  ///
  /// In ko, this message translates to:
  /// **'제목'**
  String get title;

  /// No description provided for @content.
  ///
  /// In ko, this message translates to:
  /// **'내용'**
  String get content;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In ko, this message translates to:
  /// **'추가'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In ko, this message translates to:
  /// **'수정'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get delete;

  /// No description provided for @titleRequired.
  ///
  /// In ko, this message translates to:
  /// **'제목을 입력하세요'**
  String get titleRequired;

  /// No description provided for @contentRequired.
  ///
  /// In ko, this message translates to:
  /// **'내용을 입력하세요'**
  String get contentRequired;

  /// No description provided for @titleAndContentRequired.
  ///
  /// In ko, this message translates to:
  /// **'제목과 내용을 입력해주세요'**
  String get titleAndContentRequired;

  /// No description provided for @enterTitle.
  ///
  /// In ko, this message translates to:
  /// **'문서 제목을 입력하세요'**
  String get enterTitle;

  /// No description provided for @enterContent.
  ///
  /// In ko, this message translates to:
  /// **'문서 내용을 입력하세요'**
  String get enterContent;

  /// No description provided for @metadata.
  ///
  /// In ko, this message translates to:
  /// **'Metadata'**
  String get metadata;

  /// No description provided for @metadataJson.
  ///
  /// In ko, this message translates to:
  /// **'Metadata (JSON)'**
  String get metadataJson;

  /// No description provided for @autoGenerateUuid.
  ///
  /// In ko, this message translates to:
  /// **'UUID는 자동으로 생성됩니다'**
  String get autoGenerateUuid;

  /// No description provided for @editDocument.
  ///
  /// In ko, this message translates to:
  /// **'문서 수정'**
  String get editDocument;

  /// No description provided for @deleteDocument.
  ///
  /// In ko, this message translates to:
  /// **'문서 삭제'**
  String get deleteDocument;

  /// No description provided for @deleteConfirm.
  ///
  /// In ko, this message translates to:
  /// **'문서 ID \"{id}\"를 삭제하시겠습니까?'**
  String deleteConfirm(String id);

  /// No description provided for @deleteAllWarning.
  ///
  /// In ko, this message translates to:
  /// **'모든 문서를 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'**
  String get deleteAllWarning;

  /// No description provided for @warning.
  ///
  /// In ko, this message translates to:
  /// **'⚠️ 경고'**
  String get warning;

  /// No description provided for @allDocumentsDeleted.
  ///
  /// In ko, this message translates to:
  /// **'모든 문서가 삭제되었습니다.'**
  String get allDocumentsDeleted;

  /// No description provided for @enterSearchTerm.
  ///
  /// In ko, this message translates to:
  /// **'검색어를 입력하세요.'**
  String get enterSearchTerm;

  /// No description provided for @initializingIndex.
  ///
  /// In ko, this message translates to:
  /// **'검색 인덱스 초기화 중...'**
  String get initializingIndex;

  /// No description provided for @initFailed.
  ///
  /// In ko, this message translates to:
  /// **'초기화 실패: {error}'**
  String initFailed(String error);

  /// No description provided for @searchFailed.
  ///
  /// In ko, this message translates to:
  /// **'검색 실패: {error}'**
  String searchFailed(String error);

  /// No description provided for @addFailed.
  ///
  /// In ko, this message translates to:
  /// **'추가 실패: {error}'**
  String addFailed(String error);

  /// No description provided for @updateFailed.
  ///
  /// In ko, this message translates to:
  /// **'수정 실패: {error}'**
  String updateFailed(String error);

  /// No description provided for @deleteFailed.
  ///
  /// In ko, this message translates to:
  /// **'삭제 실패: {error}'**
  String deleteFailed(String error);

  /// No description provided for @loadingFromJson.
  ///
  /// In ko, this message translates to:
  /// **'JSON 파일에서 문서 로드 중...'**
  String get loadingFromJson;

  /// No description provided for @jsonLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'JSON 로드 실패: {error}'**
  String jsonLoadFailed(String error);

  /// No description provided for @bulkAddTitle.
  ///
  /// In ko, this message translates to:
  /// **'여러 문서 추가'**
  String get bulkAddTitle;

  /// No description provided for @bulkAddFormat.
  ///
  /// In ko, this message translates to:
  /// **'형식: 제목|내용|메타데이터 (줄바꿈으로 구분)'**
  String get bulkAddFormat;

  /// No description provided for @documentList.
  ///
  /// In ko, this message translates to:
  /// **'문서 목록'**
  String get documentList;

  /// No description provided for @invalidFormat.
  ///
  /// In ko, this message translates to:
  /// **'잘못된 형식: {line}'**
  String invalidFormat(String line);

  /// No description provided for @noDocumentsToAdd.
  ///
  /// In ko, this message translates to:
  /// **'추가할 문서가 없습니다'**
  String get noDocumentsToAdd;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'GB':
            return AppLocalizationsEnGb();
          case 'US':
            return AppLocalizationsEnUs();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
