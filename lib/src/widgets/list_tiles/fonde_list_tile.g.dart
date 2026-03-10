// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fonde_list_tile.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that supplies an effective FondeColorScheme.

@ProviderFor(effectiveAppColorSchemeForListTile)
final effectiveAppColorSchemeForListTileProvider =
    EffectiveAppColorSchemeForListTileProvider._();

/// Provider that supplies an effective FondeColorScheme.

final class EffectiveAppColorSchemeForListTileProvider
    extends
        $FunctionalProvider<
          FondeColorScheme,
          FondeColorScheme,
          FondeColorScheme
        >
    with $Provider<FondeColorScheme> {
  /// Provider that supplies an effective FondeColorScheme.
  EffectiveAppColorSchemeForListTileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'effectiveAppColorSchemeForListTileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$effectiveAppColorSchemeForListTileHash();

  @$internal
  @override
  $ProviderElement<FondeColorScheme> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FondeColorScheme create(Ref ref) {
    return effectiveAppColorSchemeForListTile(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FondeColorScheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FondeColorScheme>(value),
    );
  }
}

String _$effectiveAppColorSchemeForListTileHash() =>
    r'3130c3784d5e3895f19a6c997179b9521113e701';
