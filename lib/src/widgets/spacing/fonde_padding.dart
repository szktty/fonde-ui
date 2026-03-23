import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'fonde_spacing.dart';

/// A padding widget that conforms to the 4px grid system.
/// Used as a replacement for the standard Padding widget to prevent grid
/// system violations.
class FondePadding extends StatelessWidget {
  /// The padding value.
  final EdgeInsetsGeometry padding;

  /// The child widget.
  final Widget child;

  /// Whether to disable zoom support.
  final bool disableZoom;

  /// Displays invalid values as a warning only during development.
  final bool strictMode;

  const FondePadding({
    super.key,
    required this.padding,
    required this.child,
    this.disableZoom = false,
    this.strictMode = kDebugMode,
  });

  /// Apply the same padding in all directions.
  FondePadding.all(
    double value, {
    super.key,
    required this.child,
    this.disableZoom = false,
    this.strictMode = kDebugMode,
  }) : padding = EdgeInsets.all(value);

  /// Apply padding horizontally and vertically.
  FondePadding.symmetric({
    super.key,
    required this.child,
    double horizontal = 0.0,
    double vertical = 0.0,
    this.disableZoom = false,
    this.strictMode = kDebugMode,
  }) : padding = EdgeInsets.symmetric(
         horizontal: horizontal,
         vertical: vertical,
       );

  /// Apply individual padding in each direction.
  FondePadding.only({
    super.key,
    required this.child,
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
    this.disableZoom = false,
    this.strictMode = kDebugMode,
  }) : padding = EdgeInsets.only(
         left: left,
         top: top,
         right: right,
         bottom: bottom,
       );

  /// Factory constructors that use predefined spacing values.

  /// Extra Small (4px) padding.
  const FondePadding.xs({
    super.key,
    required this.child,
    this.disableZoom = false,
  }) : padding = const EdgeInsets.all(FondeSpacingValues.xs),
       strictMode = false;

  /// Small (8px) padding.
  const FondePadding.sm({
    super.key,
    required this.child,
    this.disableZoom = false,
  }) : padding = const EdgeInsets.all(FondeSpacingValues.sm),
       strictMode = false;

  /// Medium (12px) padding.
  const FondePadding.md({
    super.key,
    required this.child,
    this.disableZoom = false,
  }) : padding = const EdgeInsets.all(FondeSpacingValues.md),
       strictMode = false;

  /// Large (16px) padding.
  const FondePadding.lg({
    super.key,
    required this.child,
    this.disableZoom = false,
  }) : padding = const EdgeInsets.all(FondeSpacingValues.lg),
       strictMode = false;

  /// Extra Large (20px) padding.
  const FondePadding.xl({
    super.key,
    required this.child,
    this.disableZoom = false,
  }) : padding = const EdgeInsets.all(FondeSpacingValues.xl),
       strictMode = false;

  /// XXL (24px) padding.
  const FondePadding.xxl({
    super.key,
    required this.child,
    this.disableZoom = false,
  }) : padding = const EdgeInsets.all(FondeSpacingValues.xxl),
       strictMode = false;

  /// XXXL (32px) padding.
  const FondePadding.xxxl({
    super.key,
    required this.child,
    this.disableZoom = false,
  }) : padding = const EdgeInsets.all(FondeSpacingValues.xxxl),
       strictMode = false;

  @override
  Widget build(BuildContext context) {
    final zoomScale = disableZoom ? 1.0 : 1.0; // default zoom scale

    // Validate and adjust padding values
    final effectivePadding = _getEffectivePadding(zoomScale);

    // Display warning in debug mode
    if (kDebugMode && strictMode) {
      _validatePadding();
    }

    return Padding(padding: effectivePadding, child: child);
  }

  EdgeInsetsGeometry _getEffectivePadding(double zoomScale) {
    if (padding is EdgeInsets) {
      final edgeInsets = padding as EdgeInsets;

      if (strictMode) {
        // Adjust invalid values to the nearest valid value
        return EdgeInsets.only(
          left: _adjustSpacing(edgeInsets.left) * zoomScale,
          top: _adjustSpacing(edgeInsets.top) * zoomScale,
          right: _adjustSpacing(edgeInsets.right) * zoomScale,
          bottom: _adjustSpacing(edgeInsets.bottom) * zoomScale,
        );
      } else {
        return EdgeInsets.only(
          left: edgeInsets.left * zoomScale,
          top: edgeInsets.top * zoomScale,
          right: edgeInsets.right * zoomScale,
          bottom: edgeInsets.bottom * zoomScale,
        );
      }
    }

    // For other EdgeInsetsGeometry (e.g., EdgeInsetsDirectional)
    // Apply only the zoom scale
    return padding * zoomScale;
  }

  double _adjustSpacing(double value) {
    if (!FondeSpacingValues.isValidSpacing(value)) {
      return FondeSpacingValues.getNearestValidSpacing(value);
    }
    return value;
  }

  void _validatePadding() {
    if (padding is EdgeInsets) {
      final edgeInsets = padding as EdgeInsets;
      final violations = <String>[];

      if (!FondeSpacingValues.isValidSpacing(edgeInsets.left)) {
        violations.add(
          'left: ${edgeInsets.left} -> ${FondeSpacingValues.getNearestValidSpacing(edgeInsets.left)}',
        );
      }
      if (!FondeSpacingValues.isValidSpacing(edgeInsets.top)) {
        violations.add(
          'top: ${edgeInsets.top} -> ${FondeSpacingValues.getNearestValidSpacing(edgeInsets.top)}',
        );
      }
      if (!FondeSpacingValues.isValidSpacing(edgeInsets.right)) {
        violations.add(
          'right: ${edgeInsets.right} -> ${FondeSpacingValues.getNearestValidSpacing(edgeInsets.right)}',
        );
      }
      if (!FondeSpacingValues.isValidSpacing(edgeInsets.bottom)) {
        violations.add(
          'bottom: ${edgeInsets.bottom} -> ${FondeSpacingValues.getNearestValidSpacing(edgeInsets.bottom)}',
        );
      }

      if (violations.isNotEmpty) {
        debugPrint(
          'FondePadding Warning: Invalid padding values detected:\n'
          '${violations.join('\n')}\n'
          'Valid values: ${FondeSpacingValues.allowedValues}',
        );
      }
    }
  }
}
