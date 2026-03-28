import 'package:flutter/material.dart';
import '../../internal.dart';
import '../../core/context_extensions.dart';
import '../widgets/fonde_gesture_detector.dart';

/// A list tile that handles selection state and applies appropriate theme colors.
class FondeListTile extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final bool dense;
  final EdgeInsetsGeometry? contentPadding;
  final bool enableHover;
  final Color? hoverColor;

  /// Whether to disable zoom functionality.
  final bool disableZoom;

  const FondeListTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    required this.isSelected,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.dense = false,
    this.contentPadding,
    this.enableHover = true,
    this.hoverColor,
    this.disableZoom = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get FondeColorScheme and accessibility config
    final appColorScheme = context.fondeColorScheme;
    final zoomScale = disableZoom ? 1.0 : context.fondeZoomScale;

    // Determine hover color (temporary implementation)
    final theme = Theme.of(context);
    final effectiveHoverColor =
        enableHover ? (hoverColor ?? theme.hoverColor) : Colors.transparent;

    final tile = Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      child: ListTile(
        leading: leading,
        trailing: trailing,
        title: title,
        subtitle: subtitle,
        selected: isSelected,
        selectedTileColor: appColorScheme.interactive.list.selectedBackground,
        selectedColor: appColorScheme.interactive.list.selectedText,
        hoverColor: effectiveHoverColor,
        splashColor: Colors.transparent,
        enabled: onTap != null || onDoubleTap != null,
        onTap: onDoubleTap != null ? null : onTap,
        onLongPress: onLongPress,
        dense: dense,
        contentPadding:
            contentPadding != null ? contentPadding! * zoomScale : null,
      ),
    );

    if (onDoubleTap != null) {
      return FondeGestureDetector(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        behavior: HitTestBehavior.translucent,
        child: tile,
      );
    }
    return tile;
  }
}
