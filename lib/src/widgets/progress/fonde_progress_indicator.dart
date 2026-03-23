import 'package:flutter/material.dart';
import '../../internal.dart';
import '../../core/context_extensions.dart';

/// Linear progress indicator with accessibility support.
///
/// Supports zoom scaling and theme-aware colors.
/// Use [value] for determinate progress (0.0–1.0), or null for indeterminate.
class FondeLinearProgressIndicator extends StatelessWidget {
  const FondeLinearProgressIndicator({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.height = 4.0,
    this.disableZoom = false,
    this.isCancelled = false,
    this.animationDuration = const Duration(milliseconds: 400),
  });

  /// Progress value (0.0–1.0), or null for indeterminate.
  final double? value;

  /// Progress bar color. Defaults to the theme primary color.
  final Color? color;

  /// Track background color. Defaults to [FondeColorScheme.base.divider].
  final Color? backgroundColor;

  /// Height of the progress bar in logical pixels (before zoom scaling).
  final double height;

  /// When true, zoom scaling is not applied.
  final bool disableZoom;

  /// When true, animation stops and the current value is frozen.
  final bool isCancelled;

  /// Duration of the animated transition between progress values.
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.fondeColorScheme;
    final zoomScale = disableZoom ? 1.0 : context.fondeZoomScale;

    final effectiveHeight = height * zoomScale;
    final effectiveColor = color ?? colorScheme.theme.primaryColor;
    final effectiveBackgroundColor =
        backgroundColor ?? colorScheme.base.divider;

    Widget indicator;

    if (isCancelled || value == null) {
      // Indeterminate or cancelled: no tween animation
      indicator = SizedBox(
        height: effectiveHeight,
        child: LinearProgressIndicator(
          value: value,
          backgroundColor: effectiveBackgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(
            isCancelled
                ? effectiveColor.withValues(alpha: 0.5)
                : effectiveColor,
          ),
        ),
      );
    } else {
      indicator = TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: value!),
        duration: animationDuration,
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, _) {
          return SizedBox(
            height: effectiveHeight,
            child: LinearProgressIndicator(
              value: animatedValue,
              backgroundColor: effectiveBackgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
            ),
          );
        },
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(effectiveHeight / 2),
      child: indicator,
    );
  }
}

/// Circular progress indicator with accessibility support.
///
/// Supports zoom scaling and theme-aware colors.
/// Use [value] for determinate progress (0.0–1.0), or null for indeterminate.
class FondeCircularProgressIndicator extends StatelessWidget {
  const FondeCircularProgressIndicator({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.size = 20.0,
    this.strokeWidth = 2.0,
    this.disableZoom = false,
  });

  /// Progress value (0.0–1.0), or null for indeterminate.
  final double? value;

  /// Indicator color. Defaults to the theme primary color.
  final Color? color;

  /// Track background color. Defaults to [FondeColorScheme.base.divider].
  final Color? backgroundColor;

  /// Diameter of the indicator in logical pixels (before zoom scaling).
  final double size;

  /// Stroke width in logical pixels (before zoom scaling).
  final double strokeWidth;

  /// When true, zoom scaling is not applied.
  final bool disableZoom;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.fondeColorScheme;
    final scale = disableZoom ? 1.0 : context.fondeZoomScale;
    final effectiveSize = size * scale;
    final effectiveStrokeWidth = strokeWidth * scale;
    final effectiveColor = color ?? colorScheme.theme.primaryColor;
    final effectiveBackgroundColor =
        backgroundColor ?? colorScheme.base.divider;

    return SizedBox(
      width: effectiveSize,
      height: effectiveSize,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: effectiveStrokeWidth,
        backgroundColor: effectiveBackgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
      ),
    );
  }
}
