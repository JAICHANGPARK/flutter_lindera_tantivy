import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers/theme_provider.dart';

class ThemeSelector extends ConsumerWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(appThemeModeProvider);
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<ThemeModeOption>(
      icon: Icon(_getThemeIcon(currentTheme)),
      tooltip: l10n.changeTheme,
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
                l10n.lightMode,
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
                l10n.darkMode,
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
                l10n.systemSettings,
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
