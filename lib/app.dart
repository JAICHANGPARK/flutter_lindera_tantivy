
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tantivy_flutter_app/providers/locale_provider.dart';
import 'package:tantivy_flutter_app/providers/theme_provider.dart';

import 'l10n/app_localizations.dart';
import 'screens/search_page.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(appThemeModeProvider);

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: _convertToMaterialThemeMode(themeMode),
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', ''), // 한국어
        Locale('en', 'US'), // 영어 (미국)
        Locale('en', 'GB'), // 영어 (영국)
        Locale('ja', ''), // 일본어
        Locale('zh', ''), // 중국어
      ],
      debugShowCheckedModeBanner: false,
      home: const SearchPage(),
    );
  }

  ThemeMode _convertToMaterialThemeMode(ThemeModeOption mode) {
    switch (mode) {
      case ThemeModeOption.light:
        return ThemeMode.light;
      case ThemeModeOption.dark:
        return ThemeMode.dark;
      case ThemeModeOption.system:
        return ThemeMode.system;
    }
  }
}
