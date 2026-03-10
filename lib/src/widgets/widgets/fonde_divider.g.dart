// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fonde_divider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that provides effective app color (supports active color scheme)

@ProviderFor(effectiveAppColorSchemeForDivider)
final effectiveAppColorSchemeForDividerProvider =
    EffectiveAppColorSchemeForDividerProvider._();

/// Provider that provides effective app color (supports active color scheme)

final class EffectiveAppColorSchemeForDividerProvider
    extends
        $FunctionalProvider<
          FondeColorScheme,
          FondeColorScheme,
          FondeColorScheme
        >
    with $Provider<FondeColorScheme> {
  /// Provider that provides effective app color (supports active color scheme)
  EffectiveAppColorSchemeForDividerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'effectiveAppColorSchemeForDividerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$effectiveAppColorSchemeForDividerHash();

  @$internal
  @override
  $ProviderElement<FondeColorScheme> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FondeColorScheme create(Ref ref) {
    return effectiveAppColorSchemeForDivider(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FondeColorScheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FondeColorScheme>(value),
    );
  }
}

String _$effectiveAppColorSchemeForDividerHash() =>
    r'7af4c120f49f70dc7d07b38df649aad06abcd96b';

/// Provider to get FondeDivider color

@ProviderFor(fondeDividerColor)
final fondeDividerColorProvider = FondeDividerColorProvider._();

/// Provider to get FondeDivider color

final class FondeDividerColorProvider
    extends $FunctionalProvider<Color, Color, Color>
    with $Provider<Color> {
  /// Provider to get FondeDivider color
  FondeDividerColorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeDividerColorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeDividerColorHash();

  @$internal
  @override
  $ProviderElement<Color> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Color create(Ref ref) {
    return fondeDividerColor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Color value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Color>(value),
    );
  }
}

String _$fondeDividerColorHash() => r'108995d53c2b8a6ece5bdf02f47bb895ac84ceb9';

/// Provider to get FondeVerticalDivider color

@ProviderFor(fondeVerticalDividerColor)
final fondeVerticalDividerColorProvider = FondeVerticalDividerColorProvider._();

/// Provider to get FondeVerticalDivider color

final class FondeVerticalDividerColorProvider
    extends $FunctionalProvider<Color, Color, Color>
    with $Provider<Color> {
  /// Provider to get FondeVerticalDivider color
  FondeVerticalDividerColorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeVerticalDividerColorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeVerticalDividerColorHash();

  @$internal
  @override
  $ProviderElement<Color> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Color create(Ref ref) {
    return fondeVerticalDividerColor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Color value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Color>(value),
    );
  }
}

String _$fondeVerticalDividerColorHash() =>
    r'46e93fb7d2869e5ef0804e3522572dd1bf15c8db';
