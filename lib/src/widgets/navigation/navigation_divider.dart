import 'package:flutter/material.dart';
import '../../core/context_extensions.dart';
import '../../internal.dart';

/// Divider between navigation items.
class FondeNavigationDivider extends StatelessWidget {
  /// Color of the divider.
  final Color? color;

  /// Total height (including padding) above and below the divider.
  final double height;

  /// Thickness of the divider.
  final double thickness;

  /// Indent on the left side of the divider.
  final double indent;

  /// Indent on the right side of the divider.
  final double endIndent;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  /// Creates a new [FondeNavigationDivider].
  ///
  /// [color] - Color of the divider.
  /// [height] - Total height (including padding) above and below the divider.
  /// [thickness] - Thickness of the divider.
  /// [indent] - Indent on the left side of the divider.
  /// [endIndent] - Indent on the right side of the divider.
  const FondeNavigationDivider({
    super.key,
    this.color,
    this.height = 16,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context) {
    final zoomScale = disableZoom ? 1.0 : context.fondeZoomScale;
    final borderScale = disableZoom ? 1.0 : context.fondeBorderScale;

    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.dividerColor.withValues(alpha: 0.2);

    return Padding(
      padding: EdgeInsets.only(
        top: (height / 2) * zoomScale,
        bottom: (height / 2) * zoomScale,
      ),
      child: Divider(
        color: effectiveColor,
        height: 0,
        thickness: thickness * borderScale,
        indent: indent * zoomScale,
        endIndent: endIndent * zoomScale,
      ),
    );
  }
}
