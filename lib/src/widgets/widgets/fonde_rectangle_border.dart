import 'package:flutter/material.dart';
import 'package:figma_squircle/figma_squircle.dart';
import '../../core/context_extensions.dart';
import '../../internal.dart';

/// App common Figma-style squircle border widget.
class FondeRectangleBorder extends StatelessWidget {
  const FondeRectangleBorder({
    super.key,
    this.child,
    this.cornerRadius,
    this.cornerSmoothing,
    this.side,
    this.outerSide,
    this.color,
    this.padding,
    this.width,
    this.height,
    this.alignment = Alignment.center,
  });

  final Widget? child;
  final double? cornerRadius;
  final double? cornerSmoothing;

  /// Inner border drawn inside the widget bounds (default).
  final BorderSide? side;

  /// Outer border drawn outside the widget bounds via Stack overlay.
  /// Use this when the border should not affect the internal layout.
  final BorderSide? outerSide;

  final Color? color;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final appColors = context.fondeColorScheme;

    final effectiveCornerRadius = cornerRadius ?? 12.0;
    final effectiveCornerSmoothing = cornerSmoothing ?? 0.6;
    final effectiveSide =
        side ?? BorderSide(color: appColors.base.border, width: 1.5);

    Widget container = Container(
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

    if (outerSide == null) return container;

    final outerWidth = outerSide!.width;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        container,
        Positioned(
          left: -outerWidth,
          top: -outerWidth,
          right: -outerWidth,
          bottom: -outerWidth,
          child: IgnorePointer(
            child: Container(
              decoration: ShapeDecoration(
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: effectiveCornerRadius + outerWidth,
                    cornerSmoothing: effectiveCornerSmoothing,
                  ),
                  side: outerSide!,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// App specific BorderRadius using figma_squircle's SmoothBorderRadius.
class FondeBorderRadius {
  final double cornerRadius;
  final double cornerSmoothing;

  const FondeBorderRadius({double? cornerRadius, double? cornerSmoothing})
    : cornerRadius = cornerRadius ?? 12.0,
      cornerSmoothing = cornerSmoothing ?? 0.6;

  const FondeBorderRadius.radius(double radius)
    : cornerRadius = radius,
      cornerSmoothing = 0.6;

  const FondeBorderRadius.small() : cornerRadius = 8.0, cornerSmoothing = 0.6;
  const FondeBorderRadius.medium() : cornerRadius = 12.0, cornerSmoothing = 0.6;
  const FondeBorderRadius.large() : cornerRadius = 16.0, cornerSmoothing = 0.6;
  const FondeBorderRadius.circular(double radius)
    : cornerRadius = radius,
      cornerSmoothing = 1.0;

  factory FondeBorderRadius.create({
    double? cornerRadius,
    double? cornerSmoothing,
  }) {
    if (cornerRadius == null && cornerSmoothing == null) {
      return const FondeBorderRadius();
    }
    return FondeBorderRadius(
      cornerRadius: cornerRadius,
      cornerSmoothing: cornerSmoothing,
    );
  }

  SmoothBorderRadius toSmoothBorderRadius() => SmoothBorderRadius(
    cornerRadius: cornerRadius,
    cornerSmoothing: cornerSmoothing,
  );

  BorderRadiusGeometry toBorderRadiusGeometry() => toSmoothBorderRadius();
}

/// App specific BorderSide presets.
class FondeBorderSide extends BorderSide {
  const FondeBorderSide({
    super.color,
    super.width = 1.5,
    super.style,
    super.strokeAlign,
  });

  const FondeBorderSide.thin({super.color, super.style, super.strokeAlign})
    : super(width: 1.0);

  const FondeBorderSide.standard({super.color, super.style, super.strokeAlign})
    : super(width: 1.5);

  const FondeBorderSide.thick({super.color, super.style, super.strokeAlign})
    : super(width: 2.0);

  const FondeBorderSide.none() : super(width: 0.0, style: BorderStyle.none);
}
