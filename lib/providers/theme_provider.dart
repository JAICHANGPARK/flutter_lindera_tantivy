import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

enum ThemeModeOption {
  light,
  dark,
  system,
}

@riverpod
class AppThemeMode extends _$AppThemeMode {
  static const String _key = 'theme_mode';

  @override
  ThemeModeOption build() {
    _loadThemeMode();
    return ThemeModeOption.system;
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_key);
    if (savedMode != null) {
      state = ThemeModeOption.values.firstWhere(
        (e) => e.name == savedMode,
        orElse: () => ThemeModeOption.system,
      );
    }
  }

  Future<void> setThemeMode(ThemeModeOption mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }
}
