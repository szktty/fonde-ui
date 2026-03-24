import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Base widget that enforces accessibility support.
/// Serves as the foundation for other components, standardizing zoom support
/// and semantic information.
abstract class FondeAccessibleWidget extends StatelessWidget {
  /// Whether to disable zoom support.
  final bool disableZoom;

  /// Whether to disable semantic information (for testing).
  final bool disableSemantics;

  const FondeAccessibleWidget({
    super.key,
    this.disableZoom = false,
    this.disableSemantics = false,
  });

  @override
  Widget build(BuildContext context) {
    final widget = buildAccessibleWidget(context: context);

    if (disableSemantics) {
      return widget;
    }

    return buildSemantics(context, widget);
  }

  /// Method to build the actual widget. To be implemented in subclasses.
  Widget buildAccessibleWidget({required BuildContext context});

  /// Method to build semantic information. Override in subclasses as needed.
  Widget buildSemantics(BuildContext context, Widget child) {
    return child;
  }

  /// Get a zoom-enabled value.
  double getScaledValue(double value, double zoomScale) {
    return disableZoom ? value : value * zoomScale;
  }

  /// Get zoom-enabled EdgeInsets.
  EdgeInsets getScaledPadding(EdgeInsets padding, double zoomScale) {
    if (disableZoom) return padding;
    return padding * zoomScale;
  }

  /// Get zoom-enabled BorderRadius.
  BorderRadius getScaledBorderRadius(BorderRadius radius, double zoomScale) {
    if (disableZoom) return radius;
    return radius * zoomScale;
  }

  /// Get zoom-enabled border width.
  double getScaledBorderWidth(
    double width,
    double zoomScale,
    double borderScale,
  ) {
    if (disableZoom) return width;
    return width * zoomScale * borderScale;
  }
}

/// Base class for interactive widgets.
abstract class FondeInteractiveWidget extends FondeAccessibleWidget {
  final VoidCallback? onTap;
  final bool enforceMinTapTarget;
  final bool focusable;
  final String? tooltip;
  final String? semanticLabel;
  final bool enabled;

  const FondeInteractiveWidget({
    super.key,
    this.onTap,
    this.enforceMinTapTarget = true,
    this.focusable = true,
    this.tooltip,
    this.semanticLabel,
    this.enabled = true,
    super.disableZoom,
    super.disableSemantics,
  });

  @override
  Widget buildSemantics(BuildContext context, Widget child) {
    if (disableSemantics) return child;

    return Semantics(
      button: onTap != null,
      enabled: enabled,
      label: semanticLabel,
      hint: tooltip,
      onTap: enabled ? onTap : null,
      focusable: focusable && enabled,
      child: child,
    );
  }

  Widget buildWithMinTapTarget(Widget child, double zoomScale) {
    if (!enforceMinTapTarget || onTap == null) return child;
    return _MinTapTargetWrapper(
      minSize: getScaledValue(44.0, zoomScale),
      child: child,
    );
  }
}

class _MinTapTargetWrapper extends StatelessWidget {
  final double minSize;
  final Widget child;

  const _MinTapTargetWrapper({required this.minSize, required this.child});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minSize, minHeight: minSize),
      child: child,
    );
  }
}

class FondeFocusManager {
  static void focusNext(BuildContext context) =>
      FocusScope.of(context).nextFocus();
  static void focusPrevious(BuildContext context) =>
      FocusScope.of(context).previousFocus();
  static void requestFocus(BuildContext context, FocusNode focusNode) =>
      FocusScope.of(context).requestFocus(focusNode);
  static void unfocus(BuildContext context) => FocusScope.of(context).unfocus();
}

class FondeLiveRegion extends StatelessWidget {
  final Widget child;
  final LiveRegionImportance importance;
  final String? announcement;

  const FondeLiveRegion({
    super.key,
    required this.child,
    this.importance = LiveRegionImportance.polite,
    this.announcement,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(liveRegion: true, child: child);
  }
}

enum LiveRegionImportance { polite, assertive, off }

class FondeAccessibilityUtils {
  static double calculateContrastRatio(Color foreground, Color background) {
    final fgL = _getLuminance(foreground);
    final bgL = _getLuminance(background);
    final lighter = fgL > bgL ? fgL : bgL;
    final darker = fgL > bgL ? bgL : fgL;
    return (lighter + 0.05) / (darker + 0.05);
  }

  static double _getLuminance(Color color) {
    final r = _linear((color.toARGB32() >> 16 & 0xFF) / 255.0);
    final g = _linear((color.toARGB32() >> 8 & 0xFF) / 255.0);
    final b = _linear((color.toARGB32() & 0xFF) / 255.0);
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  static double _linear(double v) =>
      v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();

  static bool isWcagAACompliant(
    Color fg,
    Color bg, {
    bool isLargeText = false,
  }) => calculateContrastRatio(fg, bg) >= (isLargeText ? 3.0 : 4.5);

  static bool isWcagAAACompliant(
    Color fg,
    Color bg, {
    bool isLargeText = false,
  }) => calculateContrastRatio(fg, bg) >= (isLargeText ? 4.5 : 7.0);

  static void debugContrastRatio(Color fg, Color bg, String ctx) {
    if (!kDebugMode) return;
    final ratio = calculateContrastRatio(fg, bg);
    if (!isWcagAACompliant(fg, bg)) {
      debugPrint('Accessibility Warning ($ctx): ratio $ratio < 4.5:1');
    }
  }
}
