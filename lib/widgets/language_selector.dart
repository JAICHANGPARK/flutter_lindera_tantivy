import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tantivy_flutter_app/providers/locale_provider.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      tooltip: 'Change Language',
      onSelected: (Locale locale) {
        ref.read(localeProvider.notifier).setLocale(locale);
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: Locale('ko', ''),
          child: Row(
            children: [
              Text('🇰🇷', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text('한국어'),
            ],
          ),
        ),
        PopupMenuItem(
          value: Locale('en', 'US'),
          child: Row(
            children: [
              Text('🇺🇸', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text('English (US)'),
            ],
          ),
        ),
        PopupMenuItem(
          value: Locale('en', 'GB'),
          child: Row(
            children: [
              Text('🇬🇧', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text('English (UK)'),
            ],
          ),
        ),
        PopupMenuItem(
          value: Locale('ja', ''),
          child: Row(
            children: [
              Text('🇯🇵', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text('日本語'),
            ],
          ),
        ),
        PopupMenuItem(
          value: Locale('zh', ''),
          child: Row(
            children: [
              Text('🇨🇳', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text('中文'),
            ],
          ),
        ),
      ],
    );
  }
}
