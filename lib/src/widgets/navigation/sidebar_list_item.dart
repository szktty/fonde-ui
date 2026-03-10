import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal.dart';
import '../widgets/fonde_gesture_detector.dart';

/// The visual style of navigation items.
enum FondeSidebarListItemStyle {
  /// Selected items use a solid background with accent-colored text (default).
  filled,

  /// Selected items use a subtle grey background with accent-colored text.
  subtle,
}

/// A widget that displays a single navigation item.
class FondeSidebarListItem extends ConsumerWidget {
  /// The unique identifier for the item.
  final String id;

  /// The title of the item.
  final String title;

  /// The widget to display at the beginning (e.g., an icon).
  final Widget? leading;

  /// The widget to display at the end (e.g., a badge or action button).
  final Widget? trailing;

  /// Callback for when a tap occurs.
  final VoidCallback? onTap;

  /// Callback for when a tap down occurs.
  final GestureTapDownCallback? onTapDown;

  /// Callback for when a tap up occurs.
  final GestureTapUpCallback? onTapUp;

  /// The selection state.
  final bool isSelected;

  /// The padding.
  final EdgeInsets padding;

  /// The text style for the title.
  final TextStyle? titleStyle;

  /// The background color.
  final Color? backgroundColor;

  /// The background color when selected.
  final Color? selectedBackgroundColor;

  /// The indent on the left side.
  final double indent;

  /// The visual style of the item.
  final FondeSidebarListItemStyle style;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  /// Creates a new [FondeSidebarListItem].
  ///
  /// [id] - The unique identifier for the item.
  /// [title] - The title to display.
  /// [leading] - The widget to display at the beginning.
  /// [trailing] - The widget to display at the end.
  /// [onTap] - Callback for when a tap occurs.
  /// [isSelected] - The selection state.
  /// [padding] - The padding.
  /// [titleStyle] - The text style for the title.
  /// [backgroundColor] - The background color.
  /// [selectedBackgroundColor] - The background color when selected.
  /// [indent] - The indent on the left side.
  const FondeSidebarListItem({
    required this.id,
    required this.title,
    this.leading,
    this.trailing,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.isSelected = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.titleStyle,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.indent = 0,
    this.style = FondeSidebarListItemStyle.filled,
    this.disableZoom = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityConfig = ref.watch(fondeAccessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    // Get the color scope (use the sidebar scope or the default)
    final colorScope = ref.watch(fondeSideBarColorScopeProvider);

    // Get the text theme
    final themeData = ref.watch(fondeEffectiveThemeDataProvider);

    final effectiveSelectedBackground = switch (style) {
      FondeSidebarListItemStyle.filled => colorScope.selection,
      FondeSidebarListItemStyle.subtle => colorScope.subtleSelection,
    };
    final effectiveBackgroundColor = isSelected
        ? selectedBackgroundColor ?? effectiveSelectedBackground
        : backgroundColor;

    final effectiveContentColor = switch (style) {
      FondeSidebarListItemStyle.filled =>
        isSelected ? colorScope.accent : colorScope.text,
      FondeSidebarListItemStyle.subtle =>
        isSelected ? colorScope.accent : colorScope.text,
    };

    final effectiveTitleStyle =
        titleStyle ??
        themeData.textTheme.bodyLarge?.copyWith(color: effectiveContentColor);

    Widget content = Container(
      padding: padding * zoomScale,
      child: Row(
        children: [
          if (leading != null)
            Padding(
              padding: EdgeInsets.only(right: 12 * zoomScale),
              child: IconTheme.merge(
                data: IconThemeData(color: effectiveContentColor),
                child: leading!,
              ),
            ),
          Expanded(
            child: Text(
              title,
              style: effectiveTitleStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );

    // Apply if indent is specified
    if (indent > 0) {
      content = Padding(
        padding: EdgeInsets.only(left: indent * zoomScale),
        child: content,
      );
    }

    return FondeGestureDetector(
      onTap: onTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      cursor: SystemMouseCursors.click,
      behavior: HitTestBehavior.opaque,
      child: Container(color: effectiveBackgroundColor, child: content),
    );
  }
}
