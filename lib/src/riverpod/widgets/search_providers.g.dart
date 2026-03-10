// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages the current search query.

@ProviderFor(FondeSearchQuery)
final fondeSearchQueryProvider = FondeSearchQueryProvider._();

/// Provider that manages the current search query.
final class FondeSearchQueryProvider
    extends $NotifierProvider<FondeSearchQuery, String> {
  /// Provider that manages the current search query.
  FondeSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeSearchQueryHash();

  @$internal
  @override
  FondeSearchQuery create() => FondeSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$fondeSearchQueryHash() => r'ab529df31f5b2849f24307d2565f2d423cb6b35e';

/// Provider that manages the current search query.

abstract class _$FondeSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages the state and actions of the search field.

@ProviderFor(fondeSearchFieldManager)
final fondeSearchFieldManagerProvider = FondeSearchFieldManagerProvider._();

/// Provider that manages the state and actions of the search field.

final class FondeSearchFieldManagerProvider
    extends
        $FunctionalProvider<
          FondeSearchFieldManager,
          FondeSearchFieldManager,
          FondeSearchFieldManager
        >
    with $Provider<FondeSearchFieldManager> {
  /// Provider that manages the state and actions of the search field.
  FondeSearchFieldManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeSearchFieldManagerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeSearchFieldManagerHash();

  @$internal
  @override
  $ProviderElement<FondeSearchFieldManager> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FondeSearchFieldManager create(Ref ref) {
    return fondeSearchFieldManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FondeSearchFieldManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FondeSearchFieldManager>(value),
    );
  }
}

String _$fondeSearchFieldManagerHash() =>
    r'349d10f0dfe6df9c4141201786ca9945e40c55d9';
