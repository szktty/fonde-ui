import 'package:flutter/material.dart';
import 'package:figma_squircle/figma_squircle.dart';
import '../../internal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fonde_rectangle_border.g.dart';

/// App app common Figma-style squircle border
///
/// Provides unified border style across the app.
/// cornerRadius, cornerSmoothing, and side can be optionally specified.
/// Default values follow the app's design guidelines.
class FondeRectangleBorder extends ConsumerWidget {
  /// Constructor
  const FondeRectangleBorder({
    super.key,
    this.child,
    this.cornerRadius,
    this.cornerSmoothing,
    this.side,
    this.color,
    this.padding,
    this.width,
    this.height,
    this.alignment = Alignment.center,
  });

  /// Child widget
  final Widget? child;

  /// Corner radius
  /// Default value is 12.0
  final double? cornerRadius;

  /// Corner smoothing
  /// Value between 0.0 and 1.0, closer to 1.0 is smoother.
  /// Default value is 0.6
  final double? cornerSmoothing;

  /// Border style
  /// By default appColors.containerBorder is used.
  final BorderSide? side;

  /// Background color
  /// By default null (transparent)
  final Color? color;

  /// Padding
  final EdgeInsetsGeometry? padding;

  /// Width
  final double? width;

  /// Height
  final double? height;

  /// Alignment
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(fondeEffectiveColorSchemeProvider);

    final effectiveCornerRadius = cornerRadius ?? 12.0;
    final effectiveCornerSmoothing = cornerSmoothing ?? 0.6;
    final effectiveSide =
        side ?? BorderSide(color: appColors.base.border, width: 1.5);

    Widget content = Container(
      width: width,
      height: height,
      alignment: alignment,
      decoration: ShapeDecoration(
        color: color,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: effectiveCornerRadius,
            cornerSmoothing: effectiveCornerSmoothing,
          ),
          side: effectiveSide,
        ),
      ),
      child: padding != null ? Padding(padding: padding!, child: child) : child,
    );

    return content;
  }
}

/// Provider that generates FondeRectangleBorder
///
/// Provider for providing unified border style across the app.
/// Can be used outside widget tree as it includes access to appColors.
@riverpod
SmoothRectangleBorder fondeRectangleBorder(Ref ref) {
  final appColors = ref.watch(fondeEffectiveColorSchemeProvider);

  return SmoothRectangleBorder(
    borderRadius: SmoothBorderRadius(cornerRadius: 12.0, cornerSmoothing: 0.6),
    side: BorderSide(color: appColors.base.border, width: 1.5),
  );
}

/// Provider that generates ShapeDecoration for FondeRectangleBorder
///
/// Can be used directly in decoration property of Container etc.
@riverpod
ShapeDecoration fondeShapeDecoration(
  Ref ref, {
  Color? color,
  double? cornerRadius,
  double? cornerSmoothing,
  BorderSide? side,
}) {
  final appColors = ref.watch(fondeEffectiveColorSchemeProvider);

  return ShapeDecoration(
    color: color,
    shape: SmoothRectangleBorder(
      borderRadius: SmoothBorderRadius(
        cornerRadius: cornerRadius ?? 12.0,
        cornerSmoothing: cornerSmoothing ?? 0.6,
      ),
      side: side ?? BorderSide(color: appColors.base.border, width: 1.5),
    ),
  );
}

/// App app specific BorderRadius
///
/// Wraps figma_squircle's SmoothBorderRadius to provide
/// unified border radius across the app.
class FondeBorderRadius {
  /// Corner radius
  final double cornerRadius;

  /// Corner smoothing
  final double cornerSmoothing;

  /// Create default FondeBorderRadius
  const FondeBorderRadius({double? cornerRadius, double? cornerSmoothing})
    : cornerRadius = cornerRadius ?? 12.0,
      cornerSmoothing = cornerSmoothing ?? 0.6;

  /// Create FondeBorderRadius with only corner radius specified
  const FondeBorderRadius.radius(double radius)
    : cornerRadius = radius,
      cornerSmoothing = 0.6;

  /// Create FondeBorderRadius with small corner radius
  const FondeBorderRadius.small() : cornerRadius = 8.0, cornerSmoothing = 0.6;

  /// Create FondeBorderRadius with medium corner radius
  const FondeBorderRadius.medium() : cornerRadius = 12.0, cornerSmoothing = 0.6;

  /// Create FondeBorderRadius with large corner radius
  const FondeBorderRadius.large() : cornerRadius = 16.0, cornerSmoothing = 0.6;

  /// Create circular FondeBorderRadius
  const FondeBorderRadius.circular(double radius)
    : cornerRadius = radius,
      cornerSmoothing = 1.0;

  /// Factory method: select optimal constructor based on parameters
  factory FondeBorderRadius.create({
    double? cornerRadius,
    double? cornerSmoothing,
  }) {
    // Use const constructor if both are null
    if (cornerRadius == null && cornerSmoothing == null) {
      return const FondeBorderRadius();
    }
    // Use normal constructor if either is not null
    return FondeBorderRadius(
      cornerRadius: cornerRadius,
      cornerSmoothing: cornerSmoothing,
    );
  }

  /// Convert to SmoothBorderRadius
  SmoothBorderRadius toSmoothBorderRadius() {
    return SmoothBorderRadius(
      cornerRadius: cornerRadius,
      cornerSmoothing: cornerSmoothing,
    );
  }

  BorderRadiusGeometry toBorderRadiusGeometry() {
    return toSmoothBorderRadius();
  }
}

/// App app specific BorderSide
///
/// Provides unified border style across the app.
class FondeBorderSide extends BorderSide {
  /// Create default FondeBorderSide
  const FondeBorderSide({
    super.color,
    super.width = 1.5,
    super.style,
    super.strokeAlign,
  });

  /// Create FondeBorderSide with thin border
  const FondeBorderSide.thin({super.color, super.style, super.strokeAlign})
    : super(width: 1.0);

  /// Create FondeBorderSide with standard border
  const FondeBorderSide.standard({super.color, super.style, super.strokeAlign})
    : super(width: 1.5);

  /// Create FondeBorderSide with thick border
  const FondeBorderSide.thick({super.color, super.style, super.strokeAlign})
    : super(width: 2.0);

  /// Create FondeBorderSide with no border
  const FondeBorderSide.none() : super(width: 0.0, style: BorderStyle.none);
}

/// Provider that generates FondeBorderRadius
///
/// Provider for providing unified border radius across the app.
@riverpod
FondeBorderRadius fondeBorderRadius(Ref ref) {
  return const FondeBorderRadius.medium();
}

/// Provider that generates FondeBorderSide
///
/// Provider for providing unified border style across the app.
@riverpod
FondeBorderSide fondeBorderSide(Ref ref) {
  final appColors = ref.watch(fondeEffectiveColorSchemeProvider);

  return FondeBorderSide.standard(color: appColors.base.border);
}
