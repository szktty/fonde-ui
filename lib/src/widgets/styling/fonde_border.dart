import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Constant class for border widths that conform to design guidelines.
/// Provides automatic application of borderScale and accessibility support.
class FondeBorderWidth {
  const FondeBorderWidth._();

  /// Thin (1px) - normal border
  static const double thin = 1.0;

  /// Medium (1.5px) - accent, focus
  static const double medium = 1.5;

  /// Thick (2px) - emphasis, error state
  static const double thick = 2.0;

  /// All allowed border width values.
  static const List<double> allowedValues = [0.0, thin, medium, thick];

  /// Check if the value is a valid border width.
  static bool isValidWidth(double value) {
    return allowedValues.contains(value);
  }

  /// Get the nearest valid border width.
  static double getNearestValidWidth(double value) {
    if (value <= 0) return 0.0;

    double nearest = allowedValues.first;
    double minDiff = (value - nearest).abs();

    for (final allowedValue in allowedValues) {
      final diff = (value - allowedValue).abs();
      if (diff < minDiff) {
        minDiff = diff;
        nearest = allowedValue;
      }
    }

    return nearest;
  }

  /// Get the border width token name.
  static String? getTokenName(double value) {
    switch (value) {
      case 0.0:
        return 'none';
      case thin:
        return 'thin';
      case medium:
        return 'medium';
      case thick:
        return 'thick';
      default:
        return null;
    }
  }
}

/// Accessibility-ready border creation utility.
class FondeBorder {
  /// Create a standard border (automatically applies borderScale).
  static Border all({
    required double width,
    required Color color,
    double borderScale = 1.0,
    BorderStyle style = BorderStyle.solid,
  }) {
    final effectiveWidth = _getEffectiveWidth(width, borderScale);
    return Border.all(width: effectiveWidth, color: color, style: style);
  }

  /// Create individual borders.
  static Border only({
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
    double left = 0.0,
    required Color color,
    double borderScale = 1.0,
    BorderStyle style = BorderStyle.solid,
  }) {
    return Border(
      top:
          top > 0
              ? BorderSide(
                width: _getEffectiveWidth(top, borderScale),
                color: color,
                style: style,
              )
              : BorderSide.none,
      right:
          right > 0
              ? BorderSide(
                width: _getEffectiveWidth(right, borderScale),
                color: color,
                style: style,
              )
              : BorderSide.none,
      bottom:
          bottom > 0
              ? BorderSide(
                width: _getEffectiveWidth(bottom, borderScale),
                color: color,
                style: style,
              )
              : BorderSide.none,
      left:
          left > 0
              ? BorderSide(
                width: _getEffectiveWidth(left, borderScale),
                color: color,
                style: style,
              )
              : BorderSide.none,
    );
  }

  /// Create a BorderSide.
  static BorderSide side({
    required double width,
    required Color color,
    double borderScale = 1.0,
    BorderStyle style = BorderStyle.solid,
  }) {
    return BorderSide(
      width: _getEffectiveWidth(width, borderScale),
      color: color,
      style: style,
    );
  }

  /// Factory methods that use predefined border widths.

  /// Thin (1px) border.
  static Border thin({
    required Color color,
    double borderScale = 1.0,
    BorderStyle style = BorderStyle.solid,
  }) {
    return all(
      width: FondeBorderWidth.thin,
      color: color,
      borderScale: borderScale,
      style: style,
    );
  }

  /// Medium (1.5px) border.
  static Border medium({
    required Color color,
    double borderScale = 1.0,
    BorderStyle style = BorderStyle.solid,
  }) {
    return all(
      width: FondeBorderWidth.medium,
      color: color,
      borderScale: borderScale,
      style: style,
    );
  }

  /// Thick (2px) border.
  static Border thick({
    required Color color,
    double borderScale = 1.0,
    BorderStyle style = BorderStyle.solid,
  }) {
    return all(
      width: FondeBorderWidth.thick,
      color: color,
      borderScale: borderScale,
      style: style,
    );
  }

  /// Calculate the effective border width (with warning).
  static double _getEffectiveWidth(double width, double borderScale) {
    if (kDebugMode && !FondeBorderWidth.isValidWidth(width)) {
      final nearest = FondeBorderWidth.getNearestValidWidth(width);
      debugPrint(
        'FondeBorder Warning: width $width is not valid. '
        'Use one of: ${FondeBorderWidth.allowedValues}. '
        'Using nearest valid value: $nearest',
      );
      return nearest * borderScale;
    }

    return width * borderScale;
  }
}

/// A widget that automatically applies borderScale using Riverpod.
class FondeBorderContainer extends ConsumerWidget {
  /// The child widget.
  final Widget child;

  /// The border settings.
  final Border? border;

  /// The border color.
  final Color? borderColor;

  /// The border width.
  final double borderWidth;

  /// The border radius.
  final BorderRadius? borderRadius;

  /// The background color.
  final Color? backgroundColor;

  /// Whether to disable zoom support.
  final bool disableZoom;

  const FondeBorderContainer({
    super.key,
    required this.child,
    this.border,
    this.borderColor,
    this.borderWidth = FondeBorderWidth.thin,
    this.borderRadius,
    this.backgroundColor,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final borderScale = disableZoom ? 1.0 : 1.0; // default border scale
    final zoomScale = disableZoom ? 1.0 : 1.0; // default zoom scale

    // Determine the border
    final effectiveBorder =
        border ??
        (borderColor != null
            ? FondeBorder.all(
              width: borderWidth,
              color: borderColor!,
              borderScale: borderScale,
            )
            : null);

    // Adjust the border radius
    final effectiveBorderRadius =
        borderRadius != null ? borderRadius! * zoomScale : null;

    return Container(
      decoration: BoxDecoration(
        border: effectiveBorder,
        borderRadius: effectiveBorderRadius,
        color: backgroundColor,
      ),
      child: child,
    );
  }
}
