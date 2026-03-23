import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import '../../core/context_extensions.dart';
import '../../internal.dart';
import '../widgets/fonde_gesture_detector.dart';

/// The visual style of navigation items.
enum FondeSidebarListItemStyle {
  /// Selected items use a solid background with accent-colored text (default).
  filled,

  /// Selected items use a subtle grey background with accent-colored text.
  subtle,

  /// Selected items use a floating rounded rectangle (macOS-style inset card).
  /// Hover state also shows a subtle rounded rectangle.
  inset,
}

/// A widget that displays a single navigation item.
class FondeSidebarListItem extends StatefulWidget {
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
  State<FondeSidebarListItem> createState() => _FondeSidebarListItemState();
}

class _FondeSidebarListItemState extends State<FondeSidebarListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final zoomScale = widget.disableZoom ? 1.0 : context.fondeZoomScale;

    // Get the color scope (use the sidebar scope or the default)
    final colorScope = context.fondeColorScope;

    // Get the text theme
    final themeData = Theme.of(context);

    final Color? effectiveBackgroundColor;
    final Color effectiveContentColor;

    switch (widget.style) {
      case FondeSidebarListItemStyle.filled:
        effectiveBackgroundColor =
            widget.isSelected
                ? widget.selectedBackgroundColor ?? colorScope.selection
                : widget.backgroundColor;
        effectiveContentColor =
            widget.isSelected ? colorScope.accent : colorScope.text;
      case FondeSidebarListItemStyle.subtle:
        effectiveBackgroundColor =
            widget.isSelected
                ? widget.selectedBackgroundColor ?? colorScope.subtleSelection
                : widget.backgroundColor;
        effectiveContentColor =
            widget.isSelected ? colorScope.accent : colorScope.text;
      case FondeSidebarListItemStyle.inset:
        effectiveBackgroundColor = null; // handled by inset decoration
        effectiveContentColor =
            widget.isSelected ? colorScope.accent : colorScope.text;
    }

    final effectiveTitleStyle =
        widget.titleStyle ??
        themeData.textTheme.bodyLarge?.copyWith(color: effectiveContentColor);

    Widget content = Padding(
      padding: widget.padding * zoomScale,
      child: Row(
        children: [
          if (widget.leading != null)
            Padding(
              padding: EdgeInsets.only(right: 12 * zoomScale),
              child: IconTheme.merge(
                data: IconThemeData(color: effectiveContentColor),
                child: widget.leading!,
              ),
            ),
          Expanded(
            child: Text(
              widget.title,
              style: effectiveTitleStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.trailing != null) widget.trailing!,
        ],
      ),
    );

    // Apply if indent is specified
    if (widget.indent > 0) {
      content = Padding(
        padding: EdgeInsets.only(left: widget.indent * zoomScale),
        child: content,
      );
    }

    if (widget.style == FondeSidebarListItemStyle.inset) {
      final insetColor =
          widget.isSelected
              ? widget.selectedBackgroundColor ?? colorScope.selection
              : _isHovered
              ? colorScope.hover
              : null;

      content = MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          decoration:
              insetColor != null
                  ? ShapeDecoration(
                    color: insetColor,
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                        cornerRadius: 6.0 * zoomScale,
                        cornerSmoothing: 0.6,
                      ),
                    ),
                  )
                  : null,
          child: content,
        ),
      );

      return FondeGestureDetector(
        onTap: widget.onTap,
        onTapDown: widget.onTapDown,
        onTapUp: widget.onTapUp,
        cursor: SystemMouseCursors.basic,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return FondeGestureDetector(
      onTap: widget.onTap,
      onTapDown: widget.onTapDown,
      onTapUp: widget.onTapUp,
      cursor: SystemMouseCursors.basic,
      behavior: HitTestBehavior.opaque,
      child: Container(color: effectiveBackgroundColor, child: content),
    );
  }
}
