import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal.dart';

/// A status bar widget displayed at the bottom of the screen.
///
/// Typically added to [FondeScaffold] via the [statusBar] parameter.
/// Supports left, center, and right sections for displaying status text,
/// progress indicators, or action buttons.
class FondeStatusBar extends ConsumerWidget {
  const FondeStatusBar({
    super.key,
    this.leading,
    this.center,
    this.trailing,
    this.height = 24.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0),
    this.backgroundColor,
    this.borderColor,
    this.disableZoom = false,
  });

  /// Widget placed at the left side of the status bar.
  final Widget? leading;

  /// Widget placed in the center of the status bar.
  final Widget? center;

  /// Widget placed at the right side of the status bar.
  final Widget? trailing;

  /// Height of the status bar. Defaults to 24.
  final double height;

  /// Horizontal padding inside the status bar.
  final EdgeInsetsGeometry padding;

  /// Background color. Defaults to the toolbar background color.
  final Color? backgroundColor;

  /// Top border color. Defaults to the toolbar border color.
  final Color? borderColor;

  /// Whether to disable zoom scaling.
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(fondeAccessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    final effectiveBackground =
        backgroundColor ?? appColorScheme.uiAreas.toolbar.background;
    final effectiveBorder =
        borderColor ?? appColorScheme.uiAreas.toolbar.border;

    return Container(
      height: height * zoomScale,
      decoration: BoxDecoration(
        color: effectiveBackground,
        border: Border(top: BorderSide(color: effectiveBorder, width: 1.0)),
      ),
      padding: padding,
      child: Row(
        children: [
          if (leading != null) leading!,
          if (center != null) Expanded(child: Center(child: center!)),
          if (center == null && leading != null) const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// A single item in the status bar (icon + optional label).
///
/// Useful for building status indicators like encoding, line number, etc.
class FondeStatusBarItem extends ConsumerWidget {
  const FondeStatusBarItem({
    super.key,
    this.icon,
    this.label,
    this.onTap,
    this.tooltip,
    this.disableZoom = false,
  }) : assert(
         icon != null || label != null,
         'At least one of icon or label must be provided',
       );

  final IconData? icon;
  final String? label;
  final VoidCallback? onTap;
  final String? tooltip;
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(fondeAccessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    final foreground = appColorScheme.uiAreas.toolbar.foreground;

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) Icon(icon, size: 12.0 * zoomScale, color: foreground),
        if (icon != null && label != null) SizedBox(width: 4.0 * zoomScale),
        if (label != null)
          Text(
            label!,
            style: TextStyle(fontSize: 11.0 * zoomScale, color: foreground),
          ),
      ],
    );

    if (onTap != null) {
      content = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.0 * zoomScale),
            child: content,
          ),
        ),
      );
    } else {
      content = Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.0 * zoomScale),
        child: content,
      );
    }

    if (tooltip != null) {
      content = Tooltip(message: tooltip!, child: content);
    }

    return content;
  }
}

/// A vertical divider for use inside [FondeStatusBar].
class FondeStatusBarDivider extends ConsumerWidget {
  const FondeStatusBarDivider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    return SizedBox(
      width: 1.0,
      child: ColoredBox(color: appColorScheme.base.divider),
    );
  }
}
