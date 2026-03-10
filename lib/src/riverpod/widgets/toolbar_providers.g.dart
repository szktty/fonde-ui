// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toolbar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages the state of the toolbar.
///
/// Manages the selected tool and the set of enabled tools.

@ProviderFor(FondeToolbarStateManager)
final fondeToolbarStateManagerProvider = FondeToolbarStateManagerProvider._();

/// Provider that manages the state of the toolbar.
///
/// Manages the selected tool and the set of enabled tools.
final class FondeToolbarStateManagerProvider
    extends
        $NotifierProvider<
          FondeToolbarStateManager,
          toolbar_state.FondeToolbarState
        > {
  /// Provider that manages the state of the toolbar.
  ///
  /// Manages the selected tool and the set of enabled tools.
  FondeToolbarStateManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeToolbarStateManagerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeToolbarStateManagerHash();

  @$internal
  @override
  FondeToolbarStateManager create() => FondeToolbarStateManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(toolbar_state.FondeToolbarState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<toolbar_state.FondeToolbarState>(
        value,
      ),
    );
  }
}

String _$fondeToolbarStateManagerHash() =>
    r'3b5c83499a2c8422110340a224c241e4fcbe7613';

/// Provider that manages the state of the toolbar.
///
/// Manages the selected tool and the set of enabled tools.

abstract class _$FondeToolbarStateManager
    extends $Notifier<toolbar_state.FondeToolbarState> {
  toolbar_state.FondeToolbarState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              toolbar_state.FondeToolbarState,
              toolbar_state.FondeToolbarState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                toolbar_state.FondeToolbarState,
                toolbar_state.FondeToolbarState
              >,
              toolbar_state.FondeToolbarState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that supplies toolbar actions.

@ProviderFor(fondeToolbarActions)
final fondeToolbarActionsProvider = FondeToolbarActionsProvider._();

/// Provider that supplies toolbar actions.

final class FondeToolbarActionsProvider
    extends
        $FunctionalProvider<
          FondeToolbarActions,
          FondeToolbarActions,
          FondeToolbarActions
        >
    with $Provider<FondeToolbarActions> {
  /// Provider that supplies toolbar actions.
  FondeToolbarActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeToolbarActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeToolbarActionsHash();

  @$internal
  @override
  $ProviderElement<FondeToolbarActions> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FondeToolbarActions create(Ref ref) {
    return fondeToolbarActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FondeToolbarActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FondeToolbarActions>(value),
    );
  }
}

String _$fondeToolbarActionsHash() =>
    r'90531a6c314cc6190a5f77ff7f2549db7dbc2076';
