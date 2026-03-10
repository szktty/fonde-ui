// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fonde_rectangle_border.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that generates FondeRectangleBorder
///
/// Provider for providing unified border style across the app.
/// Can be used outside widget tree as it includes access to appColors.

@ProviderFor(fondeRectangleBorder)
final fondeRectangleBorderProvider = FondeRectangleBorderProvider._();

/// Provider that generates FondeRectangleBorder
///
/// Provider for providing unified border style across the app.
/// Can be used outside widget tree as it includes access to appColors.

final class FondeRectangleBorderProvider
    extends
        $FunctionalProvider<
          SmoothRectangleBorder,
          SmoothRectangleBorder,
          SmoothRectangleBorder
        >
    with $Provider<SmoothRectangleBorder> {
  /// Provider that generates FondeRectangleBorder
  ///
  /// Provider for providing unified border style across the app.
  /// Can be used outside widget tree as it includes access to appColors.
  FondeRectangleBorderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeRectangleBorderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeRectangleBorderHash();

  @$internal
  @override
  $ProviderElement<SmoothRectangleBorder> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SmoothRectangleBorder create(Ref ref) {
    return fondeRectangleBorder(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SmoothRectangleBorder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SmoothRectangleBorder>(value),
    );
  }
}

String _$fondeRectangleBorderHash() =>
    r'e3ec2ee949be182341d98e2440c4a4a12008f30b';

/// Provider that generates ShapeDecoration for FondeRectangleBorder
///
/// Can be used directly in decoration property of Container etc.

@ProviderFor(fondeShapeDecoration)
final fondeShapeDecorationProvider = FondeShapeDecorationFamily._();

/// Provider that generates ShapeDecoration for FondeRectangleBorder
///
/// Can be used directly in decoration property of Container etc.

final class FondeShapeDecorationProvider
    extends
        $FunctionalProvider<ShapeDecoration, ShapeDecoration, ShapeDecoration>
    with $Provider<ShapeDecoration> {
  /// Provider that generates ShapeDecoration for FondeRectangleBorder
  ///
  /// Can be used directly in decoration property of Container etc.
  FondeShapeDecorationProvider._({
    required FondeShapeDecorationFamily super.from,
    required ({
      Color? color,
      double? cornerRadius,
      double? cornerSmoothing,
      BorderSide? side,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'fondeShapeDecorationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fondeShapeDecorationHash();

  @override
  String toString() {
    return r'fondeShapeDecorationProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<ShapeDecoration> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ShapeDecoration create(Ref ref) {
    final argument =
        this.argument
            as ({
              Color? color,
              double? cornerRadius,
              double? cornerSmoothing,
              BorderSide? side,
            });
    return fondeShapeDecoration(
      ref,
      color: argument.color,
      cornerRadius: argument.cornerRadius,
      cornerSmoothing: argument.cornerSmoothing,
      side: argument.side,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShapeDecoration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShapeDecoration>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FondeShapeDecorationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fondeShapeDecorationHash() =>
    r'a81b2b76bd78345fede658d931c76eea00736e71';

/// Provider that generates ShapeDecoration for FondeRectangleBorder
///
/// Can be used directly in decoration property of Container etc.

final class FondeShapeDecorationFamily extends $Family
    with
        $FunctionalFamilyOverride<
          ShapeDecoration,
          ({
            Color? color,
            double? cornerRadius,
            double? cornerSmoothing,
            BorderSide? side,
          })
        > {
  FondeShapeDecorationFamily._()
    : super(
        retry: null,
        name: r'fondeShapeDecorationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider that generates ShapeDecoration for FondeRectangleBorder
  ///
  /// Can be used directly in decoration property of Container etc.

  FondeShapeDecorationProvider call({
    Color? color,
    double? cornerRadius,
    double? cornerSmoothing,
    BorderSide? side,
  }) => FondeShapeDecorationProvider._(
    argument: (
      color: color,
      cornerRadius: cornerRadius,
      cornerSmoothing: cornerSmoothing,
      side: side,
    ),
    from: this,
  );

  @override
  String toString() => r'fondeShapeDecorationProvider';
}

/// Provider that generates FondeBorderRadius
///
/// Provider for providing unified border radius across the app.

@ProviderFor(fondeBorderRadius)
final fondeBorderRadiusProvider = FondeBorderRadiusProvider._();

/// Provider that generates FondeBorderRadius
///
/// Provider for providing unified border radius across the app.

final class FondeBorderRadiusProvider
    extends
        $FunctionalProvider<
          FondeBorderRadius,
          FondeBorderRadius,
          FondeBorderRadius
        >
    with $Provider<FondeBorderRadius> {
  /// Provider that generates FondeBorderRadius
  ///
  /// Provider for providing unified border radius across the app.
  FondeBorderRadiusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeBorderRadiusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeBorderRadiusHash();

  @$internal
  @override
  $ProviderElement<FondeBorderRadius> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FondeBorderRadius create(Ref ref) {
    return fondeBorderRadius(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FondeBorderRadius value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FondeBorderRadius>(value),
    );
  }
}

String _$fondeBorderRadiusHash() => r'83a7ed49df73d939af4ba1c2767193e868fac40d';

/// Provider that generates FondeBorderSide
///
/// Provider for providing unified border style across the app.

@ProviderFor(fondeBorderSide)
final fondeBorderSideProvider = FondeBorderSideProvider._();

/// Provider that generates FondeBorderSide
///
/// Provider for providing unified border style across the app.

final class FondeBorderSideProvider
    extends
        $FunctionalProvider<FondeBorderSide, FondeBorderSide, FondeBorderSide>
    with $Provider<FondeBorderSide> {
  /// Provider that generates FondeBorderSide
  ///
  /// Provider for providing unified border style across the app.
  FondeBorderSideProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fondeBorderSideProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fondeBorderSideHash();

  @$internal
  @override
  $ProviderElement<FondeBorderSide> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FondeBorderSide create(Ref ref) {
    return fondeBorderSide(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FondeBorderSide value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FondeBorderSide>(value),
    );
  }
}

String _$fondeBorderSideHash() => r'093583c5d0b089c36f41c58ea04f633eb299d855';
