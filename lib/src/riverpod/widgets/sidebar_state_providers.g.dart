// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sidebar_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A map that manages the secondary sidebar state for each screen.
/// Key: index of the activity bar, Value: visibility state of the sidebar.

@ProviderFor(FondePerScreenSecondarySidebarState)
final fondePerScreenSecondarySidebarStateProvider =
    FondePerScreenSecondarySidebarStateProvider._();

/// A map that manages the secondary sidebar state for each screen.
/// Key: index of the activity bar, Value: visibility state of the sidebar.
final class FondePerScreenSecondarySidebarStateProvider
    extends
        $NotifierProvider<FondePerScreenSecondarySidebarState, Map<int, bool>> {
  /// A map that manages the secondary sidebar state for each screen.
  /// Key: index of the activity bar, Value: visibility state of the sidebar.
  FondePerScreenSecondarySidebarStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondePerScreenSecondarySidebarStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$fondePerScreenSecondarySidebarStateHash();

  @$internal
  @override
  FondePerScreenSecondarySidebarState create() =>
      FondePerScreenSecondarySidebarState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<int, bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<int, bool>>(value),
    );
  }
}

String _$fondePerScreenSecondarySidebarStateHash() =>
    r'ecec09aa99e2d55512d8fe9737aa5256f0bfc677';

/// A map that manages the secondary sidebar state for each screen.
/// Key: index of the activity bar, Value: visibility state of the sidebar.

abstract class _$FondePerScreenSecondarySidebarState
    extends $Notifier<Map<int, bool>> {
  Map<int, bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<int, bool>, Map<int, bool>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<int, bool>, Map<int, bool>>,
              Map<int, bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages the visibility state of the primary sidebar (left side).

@ProviderFor(FondePrimarySidebarState)
final fondePrimarySidebarStateProvider = FondePrimarySidebarStateProvider._();

/// Provider that manages the visibility state of the primary sidebar (left side).
final class FondePrimarySidebarStateProvider
    extends $NotifierProvider<FondePrimarySidebarState, bool> {
  /// Provider that manages the visibility state of the primary sidebar (left side).
  FondePrimarySidebarStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondePrimarySidebarStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondePrimarySidebarStateHash();

  @$internal
  @override
  FondePrimarySidebarState create() => FondePrimarySidebarState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$fondePrimarySidebarStateHash() =>
    r'09c0c3e26949bed89ae156b5e3fa7e0ea96ae936';

/// Provider that manages the visibility state of the primary sidebar (left side).

abstract class _$FondePrimarySidebarState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages the visibility state of the secondary sidebar (right side).
/// Manages the state for each screen based on the current activity bar index.

@ProviderFor(FondeSecondarySidebarState)
final fondeSecondarySidebarStateProvider =
    FondeSecondarySidebarStateProvider._();

/// Provider that manages the visibility state of the secondary sidebar (right side).
/// Manages the state for each screen based on the current activity bar index.
final class FondeSecondarySidebarStateProvider
    extends $NotifierProvider<FondeSecondarySidebarState, bool> {
  /// Provider that manages the visibility state of the secondary sidebar (right side).
  /// Manages the state for each screen based on the current activity bar index.
  FondeSecondarySidebarStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeSecondarySidebarStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeSecondarySidebarStateHash();

  @$internal
  @override
  FondeSecondarySidebarState create() => FondeSecondarySidebarState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$fondeSecondarySidebarStateHash() =>
    r'71cb2c09a7400f476ffc2b9ff545df2d8e616f61';

/// Provider that manages the visibility state of the secondary sidebar (right side).
/// Manages the state for each screen based on the current activity bar index.

abstract class _$FondeSecondarySidebarState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Secondary sidebar state provider based on the current activity bar index.
/// This provider automatically manages the state for each screen.

@ProviderFor(fondeContextualSecondarySidebarState)
final fondeContextualSecondarySidebarStateProvider =
    FondeContextualSecondarySidebarStateProvider._();

/// Secondary sidebar state provider based on the current activity bar index.
/// This provider automatically manages the state for each screen.

final class FondeContextualSecondarySidebarStateProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Secondary sidebar state provider based on the current activity bar index.
  /// This provider automatically manages the state for each screen.
  FondeContextualSecondarySidebarStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeContextualSecondarySidebarStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$fondeContextualSecondarySidebarStateHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return fondeContextualSecondarySidebarState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$fondeContextualSecondarySidebarStateHash() =>
    r'0fb9d92350ea4c6e7f675cfe674bec87b43d5c0b';
