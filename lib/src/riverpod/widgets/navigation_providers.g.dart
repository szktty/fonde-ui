// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for managing navigation state.
///
/// Manages the selection state of navigation items and the expansion state
/// of groups. Item and group identifiers are plain [String] values.

@ProviderFor(FondeNavigationState)
final fondeNavigationStateProvider = FondeNavigationStateProvider._();

/// Provider for managing navigation state.
///
/// Manages the selection state of navigation items and the expansion state
/// of groups. Item and group identifiers are plain [String] values.
final class FondeNavigationStateProvider
    extends $NotifierProvider<FondeNavigationState, FondeNavigationStateData> {
  /// Provider for managing navigation state.
  ///
  /// Manages the selection state of navigation items and the expansion state
  /// of groups. Item and group identifiers are plain [String] values.
  FondeNavigationStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeNavigationStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeNavigationStateHash();

  @$internal
  @override
  FondeNavigationState create() => FondeNavigationState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FondeNavigationStateData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FondeNavigationStateData>(value),
    );
  }
}

String _$fondeNavigationStateHash() =>
    r'f5af1fdb722538c08430d017a8cf01052befc8a7';

/// Provider for managing navigation state.
///
/// Manages the selection state of navigation items and the expansion state
/// of groups. Item and group identifiers are plain [String] values.

abstract class _$FondeNavigationState
    extends $Notifier<FondeNavigationStateData> {
  FondeNavigationStateData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<FondeNavigationStateData, FondeNavigationStateData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FondeNavigationStateData, FondeNavigationStateData>,
              FondeNavigationStateData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
