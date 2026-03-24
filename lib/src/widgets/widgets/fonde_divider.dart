import 'package:flutter/material.dart';
import '../../core/context_extensions.dart';
import '../../internal.dart';

/// App common Divider
class FondeDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;
  final Color? paddingColor;
  final bool disableZoom;

  const FondeDivider({
    super.key,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    this.paddingColor,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final accessibilityConfig = context.fondeAccessibility;
    final dividerColor = color ?? appColorScheme.base.divider;
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = disableZoom ? 1.0 : accessibilityConfig.borderScale;

    if (paddingColor != null) {
      return Container(
        height: height != null ? height! * zoomScale : 0,
        color: paddingColor,
        child: Divider(
          height: height != null ? height! * zoomScale : 0,
          thickness:
              thickness != null ? thickness! * borderScale : 2.0 * borderScale,
          indent: indent != null ? indent! * zoomScale : null,
          endIndent: endIndent != null ? endIndent! * zoomScale : null,
          color: dividerColor,
        ),
      );
    }

    return Divider(
      height: height != null ? height! * zoomScale : 0,
      thickness:
          thickness != null ? thickness! * borderScale : 2.0 * borderScale,
      indent: indent != null ? indent! * zoomScale : null,
      endIndent: endIndent != null ? endIndent! * zoomScale : null,
      color: dividerColor,
    );
  }
}

/// Vertical FondeDivider
class FondeVerticalDivider extends StatelessWidget {
  final double? width;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;
  final Color? paddingColor;
  final bool disableZoom;

  const FondeVerticalDivider({
    super.key,
    this.width,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    this.paddingColor,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final accessibilityConfig = context.fondeAccessibility;
    final dividerColor = color ?? appColorScheme.base.divider;
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = disableZoom ? 1.0 : accessibilityConfig.borderScale;

    if (paddingColor != null) {
      return Container(
        width: width != null ? width! * zoomScale : null,
        color: paddingColor,
        child: VerticalDivider(
          width: width != null ? width! * zoomScale : null,
          thickness:
              thickness != null ? thickness! * borderScale : 2.0 * borderScale,
          indent: indent != null ? indent! * zoomScale : null,
          endIndent: endIndent != null ? endIndent! * zoomScale : null,
          color: dividerColor,
        ),
      );
    }

    return VerticalDivider(
      width: width != null ? width! * zoomScale : null,
      thickness:
          thickness != null ? thickness! * borderScale : 2.0 * borderScale,
      indent: indent != null ? indent! * zoomScale : null,
      endIndent: endIndent != null ? endIndent! * zoomScale : null,
      color: dividerColor,
    );
  }
}
