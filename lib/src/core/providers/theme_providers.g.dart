// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that monitors platform brightness settings.

@ProviderFor(FondePlatformBrightness)
final fondePlatformBrightnessProvider = FondePlatformBrightnessProvider._();

/// Provider that monitors platform brightness settings.
final class FondePlatformBrightnessProvider
    extends $NotifierProvider<FondePlatformBrightness, Brightness> {
  /// Provider that monitors platform brightness settings.
  FondePlatformBrightnessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondePlatformBrightnessProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondePlatformBrightnessHash();

  @$internal
  @override
  FondePlatformBrightness create() => FondePlatformBrightness();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Brightness value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Brightness>(value),
    );
  }
}

String _$fondePlatformBrightnessHash() =>
    r'2a66b32ae90ae2ec9ddd1b123ee3cac01324c383';

/// Provider that monitors platform brightness settings.

abstract class _$FondePlatformBrightness extends $Notifier<Brightness> {
  Brightness build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Brightness, Brightness>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Brightness, Brightness>,
              Brightness,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Active theme management Provider.
///
/// Theme persistence is left to the application. To restore a saved theme,
/// call [setTheme] after reading from your preferred storage.

@ProviderFor(FondeActiveTheme)
final fondeActiveThemeProvider = FondeActiveThemeProvider._();

/// Active theme management Provider.
///
/// Theme persistence is left to the application. To restore a saved theme,
/// call [setTheme] after reading from your preferred storage.
final class FondeActiveThemeProvider
    extends $NotifierProvider<FondeActiveTheme, FondeThemeData> {
  /// Active theme management Provider.
  ///
  /// Theme persistence is left to the application. To restore a saved theme,
  /// call [setTheme] after reading from your preferred storage.
  FondeActiveThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeActiveThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeActiveThemeHash();

  @$internal
  @override
  FondeActiveTheme create() => FondeActiveTheme();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FondeThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FondeThemeData>(value),
    );
  }
}

String _$fondeActiveThemeHash() => r'4e04484bdbc070438d05729fdf85c97bd16b8f50';

/// Active theme management Provider.
///
/// Theme persistence is left to the application. To restore a saved theme,
/// call [setTheme] after reading from your preferred storage.

abstract class _$FondeActiveTheme extends $Notifier<FondeThemeData> {
  FondeThemeData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FondeThemeData, FondeThemeData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FondeThemeData, FondeThemeData>,
              FondeThemeData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that obtains the FondeColorScheme to be actually applied,
/// based on the current theme, system brightness settings, and theme color.

@ProviderFor(fondeEffectiveColorScheme)
final fondeEffectiveColorSchemeProvider = FondeEffectiveColorSchemeProvider._();

/// Provider that obtains the FondeColorScheme to be actually applied,
/// based on the current theme, system brightness settings, and theme color.

final class FondeEffectiveColorSchemeProvider
    extends
        $FunctionalProvider<
          FondeColorScheme,
          FondeColorScheme,
          FondeColorScheme
        >
    with $Provider<FondeColorScheme> {
  /// Provider that obtains the FondeColorScheme to be actually applied,
  /// based on the current theme, system brightness settings, and theme color.
  FondeEffectiveColorSchemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeEffectiveColorSchemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeEffectiveColorSchemeHash();

  @$internal
  @override
  $ProviderElement<FondeColorScheme> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FondeColorScheme create(Ref ref) {
    return fondeEffectiveColorScheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FondeColorScheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FondeColorScheme>(value),
    );
  }
}

String _$fondeEffectiveColorSchemeHash() =>
    r'1d835b0ac773a164547a4a9f886695f11d5fe98b';

/// Provider that obtains the Flutter ColorScheme to be actually applied.

@ProviderFor(fondeEffectiveFlutterColorScheme)
final fondeEffectiveFlutterColorSchemeProvider =
    FondeEffectiveFlutterColorSchemeProvider._();

/// Provider that obtains the Flutter ColorScheme to be actually applied.

final class FondeEffectiveFlutterColorSchemeProvider
    extends $FunctionalProvider<ColorScheme, ColorScheme, ColorScheme>
    with $Provider<ColorScheme> {
  /// Provider that obtains the Flutter ColorScheme to be actually applied.
  FondeEffectiveFlutterColorSchemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeEffectiveFlutterColorSchemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeEffectiveFlutterColorSchemeHash();

  @$internal
  @override
  $ProviderElement<ColorScheme> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ColorScheme create(Ref ref) {
    return fondeEffectiveFlutterColorScheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ColorScheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ColorScheme>(value),
    );
  }
}

String _$fondeEffectiveFlutterColorSchemeHash() =>
    r'337664db7b88f601b0de688fed955fbb20bd629b';

/// Provider that obtains the ThemeData to be actually applied.

@ProviderFor(fondeEffectiveThemeData)
final fondeEffectiveThemeDataProvider = FondeEffectiveThemeDataProvider._();

/// Provider that obtains the ThemeData to be actually applied.

final class FondeEffectiveThemeDataProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  /// Provider that obtains the ThemeData to be actually applied.
  FondeEffectiveThemeDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeEffectiveThemeDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeEffectiveThemeDataHash();

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeData create(Ref ref) {
    return fondeEffectiveThemeData(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeData>(value),
    );
  }
}

String _$fondeEffectiveThemeDataHash() =>
    r'376e99b8e7a73f3b4f832f46e7f141aa58fec173';

/// Active icon theme management Provider.
///
/// The initial value is null. Set a [FondeIconTheme] via [setIconTheme] to
/// activate a custom icon set. Components fall back to [lucideIconTheme] when null.

@ProviderFor(FondeActiveIconTheme)
final fondeActiveIconThemeProvider = FondeActiveIconThemeProvider._();

/// Active icon theme management Provider.
///
/// The initial value is null. Set a [FondeIconTheme] via [setIconTheme] to
/// activate a custom icon set. Components fall back to [lucideIconTheme] when null.
final class FondeActiveIconThemeProvider
    extends $NotifierProvider<FondeActiveIconTheme, FondeIconTheme?> {
  /// Active icon theme management Provider.
  ///
  /// The initial value is null. Set a [FondeIconTheme] via [setIconTheme] to
  /// activate a custom icon set. Components fall back to [lucideIconTheme] when null.
  FondeActiveIconThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeActiveIconThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeActiveIconThemeHash();

  @$internal
  @override
  FondeActiveIconTheme create() => FondeActiveIconTheme();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FondeIconTheme? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FondeIconTheme?>(value),
    );
  }
}

String _$fondeActiveIconThemeHash() =>
    r'8d6edf7760f636167210aa1fb3285c04875396d7';

/// Active icon theme management Provider.
///
/// The initial value is null. Set a [FondeIconTheme] via [setIconTheme] to
/// activate a custom icon set. Components fall back to [lucideIconTheme] when null.

abstract class _$FondeActiveIconTheme extends $Notifier<FondeIconTheme?> {
  FondeIconTheme? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FondeIconTheme?, FondeIconTheme?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FondeIconTheme?, FondeIconTheme?>,
              FondeIconTheme?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages accessibility settings.
///
/// Persistence is left to the application. Call [updateConfig] with a loaded
/// [FondeAccessibilityConfig] to restore saved settings.

@ProviderFor(FondeAccessibilityConfigNotifier)
final fondeAccessibilityConfigProvider =
    FondeAccessibilityConfigNotifierProvider._();

/// Provider that manages accessibility settings.
///
/// Persistence is left to the application. Call [updateConfig] with a loaded
/// [FondeAccessibilityConfig] to restore saved settings.
final class FondeAccessibilityConfigNotifierProvider
    extends
        $NotifierProvider<
          FondeAccessibilityConfigNotifier,
          FondeAccessibilityConfig
        > {
  /// Provider that manages accessibility settings.
  ///
  /// Persistence is left to the application. Call [updateConfig] with a loaded
  /// [FondeAccessibilityConfig] to restore saved settings.
  FondeAccessibilityConfigNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeAccessibilityConfigProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeAccessibilityConfigNotifierHash();

  @$internal
  @override
  FondeAccessibilityConfigNotifier create() =>
      FondeAccessibilityConfigNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FondeAccessibilityConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FondeAccessibilityConfig>(value),
    );
  }
}

String _$fondeAccessibilityConfigNotifierHash() =>
    r'1ab4d07530c310d14b115da522d2378211aef480';

/// Provider that manages accessibility settings.
///
/// Persistence is left to the application. Call [updateConfig] with a loaded
/// [FondeAccessibilityConfig] to restore saved settings.

abstract class _$FondeAccessibilityConfigNotifier
    extends $Notifier<FondeAccessibilityConfig> {
  FondeAccessibilityConfig build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<FondeAccessibilityConfig, FondeAccessibilityConfig>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FondeAccessibilityConfig, FondeAccessibilityConfig>,
              FondeAccessibilityConfig,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
