import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tantivy_flutter_app/providers/theme_provider.dart';

class ThemeSelector extends ConsumerWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(appThemeModeProvider);

    return PopupMenuButton<ThemeModeOption>(
      icon: Icon(_getThemeIcon(currentTheme)),
      tooltip: '테마 변경',
      onSelected: (ThemeModeOption mode) {
        ref.read(appThemeModeProvider.notifier).setThemeMode(mode);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ThemeModeOption.light,
          child: Row(
            children: [
              Icon(
                Icons.light_mode,
                color: currentTheme == ThemeModeOption.light
                    ? Theme.of(context).primaryColor
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                '라이트 모드',
                style: TextStyle(
                  fontWeight: currentTheme == ThemeModeOption.light
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeModeOption.dark,
          child: Row(
            children: [
              Icon(
                Icons.dark_mode,
                color: currentTheme == ThemeModeOption.dark
                    ? Theme.of(context).primaryColor
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                '다크 모드',
                style: TextStyle(
                  fontWeight: currentTheme == ThemeModeOption.dark
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeModeOption.system,
          child: Row(
            children: [
              Icon(
                Icons.settings_suggest,
                color: currentTheme == ThemeModeOption.system
                    ? Theme.of(context).primaryColor
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                '시스템 설정',
                style: TextStyle(
                  fontWeight: currentTheme == ThemeModeOption.system
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getThemeIcon(ThemeModeOption mode) {
    switch (mode) {
      case ThemeModeOption.light:
        return Icons.light_mode;
      case ThemeModeOption.dark:
        return Icons.dark_mode;
      case ThemeModeOption.system:
        return Icons.settings_suggest;
    }
  }
}
