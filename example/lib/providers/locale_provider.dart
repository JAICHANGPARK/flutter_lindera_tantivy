import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_provider.g.dart';

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    _loadLocale();
    return const Locale('ko', '');
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'ko';
    final countryCode = prefs.getString('country_code') ?? '';
    state = Locale(languageCode, countryCode);
  }

  Future<void> setLocale(Locale locale) async {
    if (state == locale) return;

    state = locale;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    await prefs.setString('country_code', locale.countryCode ?? '');
  }

  void clearLocale() {
    state = const Locale('ko', '');
  }
}
