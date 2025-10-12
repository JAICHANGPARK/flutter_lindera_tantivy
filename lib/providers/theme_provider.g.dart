// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppThemeMode)
const appThemeModeProvider = AppThemeModeProvider._();

final class AppThemeModeProvider
    extends $NotifierProvider<AppThemeMode, ThemeModeOption> {
  const AppThemeModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemeModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appThemeModeHash();

  @$internal
  @override
  AppThemeMode create() => AppThemeMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeModeOption value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeModeOption>(value),
    );
  }
}

String _$appThemeModeHash() => r'2aa2d1b1bb51499a09c18b38ebd30030e26cfebe';

abstract class _$AppThemeMode extends $Notifier<ThemeModeOption> {
  ThemeModeOption build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ThemeModeOption, ThemeModeOption>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeModeOption, ThemeModeOption>,
              ThemeModeOption,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
