import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Constants for spacing values conforming to the 4px grid system.
class FondeSpacingValues {
  const FondeSpacingValues._();

  /// Extra Small (4px) - icon spacing
  static const double xs = 4.0;

  /// Small (8px) - inner element padding
  static const double sm = 8.0;

  /// Medium (12px) - inner component margin
  static const double md = 12.0;

  /// Large (16px) - inner section margin
  static const double lg = 16.0;

  /// Extra Large (20px) - special use
  static const double xl = 20.0;

  /// XXL (24px) - section spacing
  static const double xxl = 24.0;

  /// XXXL (32px) - large section spacing
  static const double xxxl = 32.0;

  /// All allowed spacing values.
  static const List<double> allowedValues = [
    0.0,
    xs,
    sm,
    md,
    lg,
    xl,
    xxl,
    xxxl,
  ];

  /// Check if the value conforms to the 4px grid system.
  static bool isValidSpacing(double value) {
    return allowedValues.contains(value);
  }

  /// Get the nearest valid spacing value.
  static double getNearestValidSpacing(double value) {
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
}

/// A spacing widget that enforces the 4px grid system.
/// Used as a replacement for SizedBox, it displays a warning or error for values
/// that do not conform to the grid system.
class FondeSpacing extends ConsumerWidget {
  /// Horizontal spacing.
  final double? width;

  /// Vertical spacing.
  final double? height;

  /// Whether to disable zoom support.
  final bool disableZoom;

  /// Displays invalid values as a warning only during development (uses the
  /// nearest valid value in production).
  final bool strictMode;

  const FondeSpacing({
    super.key,
    this.width,
    this.height,
    this.disableZoom = false,
    this.strictMode = kDebugMode,
  });

  /// Square spacing (width = height).
  const FondeSpacing.square(
    double size, {
    super.key,
    this.disableZoom = false,
    this.strictMode = kDebugMode,
  }) : width = size,
       height = size;

  /// Horizontal-only spacing.
  const FondeSpacing.horizontal(
    this.width, {
    super.key,
    this.disableZoom = false,
    this.strictMode = kDebugMode,
  }) : height = null;

  /// Vertical-only spacing.
  const FondeSpacing.vertical(
    this.height, {
    super.key,
    this.disableZoom = false,
    this.strictMode = kDebugMode,
  }) : width = null;

  /// Factory constructors that use predefined spacing values.

  /// Extra Small (4px)
  const FondeSpacing.xs({super.key, this.disableZoom = false})
    : width = FondeSpacingValues.xs,
      height = FondeSpacingValues.xs,
      strictMode = false;

  /// Small (8px)
  const FondeSpacing.sm({super.key, this.disableZoom = false})
    : width = FondeSpacingValues.sm,
      height = FondeSpacingValues.sm,
      strictMode = false;

  /// Medium (12px)
  const FondeSpacing.md({super.key, this.disableZoom = false})
    : width = FondeSpacingValues.md,
      height = FondeSpacingValues.md,
      strictMode = false;

  /// Large (16px)
  const FondeSpacing.lg({super.key, this.disableZoom = false})
    : width = FondeSpacingValues.lg,
      height = FondeSpacingValues.lg,
      strictMode = false;

  /// Extra Large (20px)
  const FondeSpacing.xl({super.key, this.disableZoom = false})
    : width = FondeSpacingValues.xl,
      height = FondeSpacingValues.xl,
      strictMode = false;

  /// XXL (24px)
  const FondeSpacing.xxl({super.key, this.disableZoom = false})
    : width = FondeSpacingValues.xxl,
      height = FondeSpacingValues.xxl,
      strictMode = false;

  /// XXXL (32px)
  const FondeSpacing.xxxl({super.key, this.disableZoom = false})
    : width = FondeSpacingValues.xxxl,
      height = FondeSpacingValues.xxxl,
      strictMode = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zoomScale = disableZoom ? 1.0 : 1.0; // default zoom scale

    // Validate and adjust spacing values
    final effectiveWidth = _getEffectiveSpacing(width, zoomScale);
    final effectiveHeight = _getEffectiveSpacing(height, zoomScale);

    // Display warning in debug mode
    if (kDebugMode && strictMode) {
      _validateSpacing();
    }

    return SizedBox(width: effectiveWidth, height: effectiveHeight);
  }

  double? _getEffectiveSpacing(double? value, double zoomScale) {
    if (value == null) return null;

    if (strictMode && !FondeSpacingValues.isValidSpacing(value)) {
      // In debug mode, use the nearest valid value.
      final nearestValue = FondeSpacingValues.getNearestValidSpacing(value);
      return nearestValue * zoomScale;
    }

    return value * zoomScale;
  }

  void _validateSpacing() {
    if (width != null && !FondeSpacingValues.isValidSpacing(width!)) {
      debugPrint(
        'FondeSpacing Warning: width $width is not valid. '
        'Use one of: ${FondeSpacingValues.allowedValues}. '
        'Nearest valid value: ${FondeSpacingValues.getNearestValidSpacing(width!)}',
      );
    }

    if (height != null && !FondeSpacingValues.isValidSpacing(height!)) {
      debugPrint(
        'FondeSpacing Warning: height $height is not valid. '
        'Use one of: ${FondeSpacingValues.allowedValues}. '
        'Nearest valid value: ${FondeSpacingValues.getNearestValidSpacing(height!)}',
      );
    }
  }
}
