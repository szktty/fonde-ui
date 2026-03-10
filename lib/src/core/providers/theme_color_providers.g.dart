// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_color_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Currently selected theme color type.

@ProviderFor(FondeThemeColorNotifier)
final fondeThemeColorProvider = FondeThemeColorNotifierProvider._();

/// Currently selected theme color type.
final class FondeThemeColorNotifierProvider
    extends
        $NotifierProvider<FondeThemeColorNotifier, models.FondeThemeColorType> {
  /// Currently selected theme color type.
  FondeThemeColorNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeThemeColorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeThemeColorNotifierHash();

  @$internal
  @override
  FondeThemeColorNotifier create() => FondeThemeColorNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(models.FondeThemeColorType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<models.FondeThemeColorType>(value),
    );
  }
}

String _$fondeThemeColorNotifierHash() =>
    r'0ce8e75991565b43f7737f2361dc5f52e8b58a9e';

/// Currently selected theme color type.

abstract class _$FondeThemeColorNotifier
    extends $Notifier<models.FondeThemeColorType> {
  models.FondeThemeColorType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<models.FondeThemeColorType, models.FondeThemeColorType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                models.FondeThemeColorType,
                models.FondeThemeColorType
              >,
              models.FondeThemeColorType,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Theme color scheme.

@ProviderFor(fondeThemeColorScheme)
final fondeThemeColorSchemeProvider = FondeThemeColorSchemeProvider._();

/// Theme color scheme.

final class FondeThemeColorSchemeProvider
    extends
        $FunctionalProvider<
          models.FondeThemeColorScheme,
          models.FondeThemeColorScheme,
          models.FondeThemeColorScheme
        >
    with $Provider<models.FondeThemeColorScheme> {
  /// Theme color scheme.
  FondeThemeColorSchemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeThemeColorSchemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeThemeColorSchemeHash();

  @$internal
  @override
  $ProviderElement<models.FondeThemeColorScheme> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  models.FondeThemeColorScheme create(Ref ref) {
    return fondeThemeColorScheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(models.FondeThemeColorScheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<models.FondeThemeColorScheme>(value),
    );
  }
}

String _$fondeThemeColorSchemeHash() =>
    r'69baf4e03874f667da610120aceb303964851b4f';

/// Based on the current theme, system brightness settings, and theme color,
/// a Provider that obtains the FondeColorScheme to be actually applied.

@ProviderFor(effectiveColorSchemeWithTheme)
final effectiveColorSchemeWithThemeProvider =
    EffectiveColorSchemeWithThemeProvider._();

/// Based on the current theme, system brightness settings, and theme color,
/// a Provider that obtains the FondeColorScheme to be actually applied.

final class EffectiveColorSchemeWithThemeProvider
    extends
        $FunctionalProvider<
          FondeColorScheme,
          FondeColorScheme,
          FondeColorScheme
        >
    with $Provider<FondeColorScheme> {
  /// Based on the current theme, system brightness settings, and theme color,
  /// a Provider that obtains the FondeColorScheme to be actually applied.
  EffectiveColorSchemeWithThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'effectiveColorSchemeWithThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$effectiveColorSchemeWithThemeHash();

  @$internal
  @override
  $ProviderElement<FondeColorScheme> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FondeColorScheme create(Ref ref) {
    return effectiveColorSchemeWithTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FondeColorScheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FondeColorScheme>(value),
    );
  }
}

String _$effectiveColorSchemeWithThemeHash() =>
    r'88e46cf3a5c17b50c950d38f7fed53e55fe7a506';
