// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fonde_container.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that supplies the default padding for FondeContainer.

@ProviderFor(fondeContainerPadding)
final fondeContainerPaddingProvider = FondeContainerPaddingProvider._();

/// Provider that supplies the default padding for FondeContainer.

final class FondeContainerPaddingProvider
    extends
        $FunctionalProvider<
          EdgeInsetsGeometry,
          EdgeInsetsGeometry,
          EdgeInsetsGeometry
        >
    with $Provider<EdgeInsetsGeometry> {
  /// Provider that supplies the default padding for FondeContainer.
  FondeContainerPaddingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeContainerPaddingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeContainerPaddingHash();

  @$internal
  @override
  $ProviderElement<EdgeInsetsGeometry> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EdgeInsetsGeometry create(Ref ref) {
    return fondeContainerPadding(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EdgeInsetsGeometry value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EdgeInsetsGeometry>(value),
    );
  }
}

String _$fondeContainerPaddingHash() =>
    r'fe16a1b3aa4c0cd25c6dbdd08b7e1010a7d11354';

/// Provider that supplies the leading widget width for FondeContainer.

@ProviderFor(fondeContainerLeadingWidth)
final fondeContainerLeadingWidthProvider =
    FondeContainerLeadingWidthProvider._();

/// Provider that supplies the leading widget width for FondeContainer.

final class FondeContainerLeadingWidthProvider
    extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
  /// Provider that supplies the leading widget width for FondeContainer.
  FondeContainerLeadingWidthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeContainerLeadingWidthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeContainerLeadingWidthHash();

  @$internal
  @override
  $ProviderElement<double> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  double create(Ref ref) {
    return fondeContainerLeadingWidth(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$fondeContainerLeadingWidthHash() =>
    r'82375bc641b0f910461b73694bde9fdda6428dd9';
