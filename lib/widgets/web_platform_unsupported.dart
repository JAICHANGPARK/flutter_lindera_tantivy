import 'package:flutter/material.dart';
import 'package:tantivy_flutter_app/l10n/app_localizations.dart';
import 'package:tantivy_flutter_app/widgets/language_selector.dart';
import 'package:tantivy_flutter_app/widgets/theme_selector.dart';

class WebPlatformUnsupported extends StatelessWidget {
  const WebPlatformUnsupported({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text('🔍 ${l10n.appTitle}'),
        actions: const [
          ThemeSelector(),
          LanguageSelector(),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.web,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.webPlatformNotSupported,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.webPlatformMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
