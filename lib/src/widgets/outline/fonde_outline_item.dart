import 'package:flutter/material.dart';
import '../../core/context_extensions.dart';
import '../../internal.dart';

/// An outline item with standard App application styling.
///
/// An expandable item used for hierarchical outline display.
/// By default, the expansion icon is placed on the left, providing visual feedback for the selected state.
class FondeOutlineItem extends StatefulWidget {
  const FondeOutlineItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.children = const <Widget>[],
    this.isExpanded = false,
    this.isSelected = false,
    this.onTap,
    this.onExpansionChanged,
    this.depth = 0,
    this.hasChildren = false,
    this.contentPadding,
    this.expandIconSize = 14.0,
    this.leadingIconSize = 16.0,
    this.animationDuration = const Duration(milliseconds: 150),
    this.disableZoom = false,
  });

  /// The title of the item. Typically a [Text] widget.
  final Widget title;

  /// The subtitle of the item. Optional.
  final Widget? subtitle;

  /// The icon or widget of the item.
  final Widget? leading;

  /// The widget to display at the end of the item.
  final Widget? trailing;

  /// A list of child widgets displayed when expanded.
  final List<Widget> children;

  /// Whether it is currently expanded.
  final bool isExpanded;

  /// Whether it is currently selected.
  final bool isSelected;

  /// Callback when the item is tapped.
  final VoidCallback? onTap;

  /// Callback when the expanded state changes.
  final ValueChanged<bool>? onExpansionChanged;

  /// The depth of the outline hierarchy (indent level).
  final int depth;

  /// Whether there are child elements (for controlling the display of the expansion icon).
  final bool hasChildren;

  /// Content padding.
  final EdgeInsetsGeometry? contentPadding;

  /// The size of the expansion icon.
  final double expandIconSize;

  /// The size of the leading icon.
  final double leadingIconSize;

  /// The duration of the animation.
  final Duration animationDuration;

  /// Whether to disable zoom functionality.
  final bool disableZoom;

  @override
  State<FondeOutlineItem> createState() => _FondeOutlineItemState();
}

class _FondeOutlineItemState extends State<FondeOutlineItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final zoomScale = widget.disableZoom ? 1.0 : context.fondeZoomScale;
    final borderScale = widget.disableZoom ? 1.0 : context.fondeBorderScale;
    final theme = Theme.of(context);

    // Calculate indent based on depth
    final indent = (8.0 + (widget.depth * 16.0)) * zoomScale;

    // Background color for selected/hover state
    final selectedBackground =
        appColorScheme.interactive.list.selectedBackground;
    final hoverBackground =
        appColorScheme.interactive.list.itemBackground.hover;
    final backgroundColor =
        widget.isSelected
            ? selectedBackground
            : _isHovered
            ? hoverBackground
            : Colors.transparent;

    // Text color
    final textColor =
        widget.isSelected
            ? appColorScheme.uiAreas.sideBar.activeItemText
            : appColorScheme.uiAreas.sideBar.inactiveItemText;

    // Expansion icon
    Widget? expandIcon;
    if (widget.hasChildren) {
      expandIcon = GestureDetector(
        onTap: () => widget.onExpansionChanged?.call(!widget.isExpanded),
        child: Container(
          width: 20 * zoomScale,
          height: 20 * zoomScale,
          alignment: Alignment.center,
          child: AnimatedRotation(
            turns: widget.isExpanded ? 0.25 : 0.0,
            duration: widget.animationDuration,
            child: Icon(
              Icons.chevron_right,
              size: widget.expandIconSize * zoomScale,
              color: textColor.withValues(alpha: 0.7),
            ),
          ),
        ),
      );
    } else {
      expandIcon = SizedBox(width: 20 * zoomScale);
    }

    // Main content
    Widget content = MouseRegion(
      cursor:
          widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ColoredBox(
          color: backgroundColor,
          child: Container(
            constraints: BoxConstraints(minHeight: 32 * zoomScale),
            padding: EdgeInsets.only(
              left: indent,
              right: 8.0 * zoomScale,
              top: 4.0 * zoomScale,
              bottom: 4.0 * zoomScale,
            ),
            child: Row(
              children: [
                // Expansion icon
                expandIcon,
                SizedBox(width: 4 * zoomScale),

                // Leading icon
                if (widget.leading != null) ...[
                  IconTheme(
                    data: IconThemeData(
                      size: widget.leadingIconSize * zoomScale,
                      color: textColor,
                    ),
                    child: widget.leading!,
                  ),
                  SizedBox(width: 8 * zoomScale),
                ],

                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DefaultTextStyle(
                        style:
                            theme.textTheme.bodyMedium?.copyWith(
                              color: textColor,
                            ) ??
                            TextStyle(color: textColor),
                        child: widget.title,
                      ),
                      if (widget.subtitle != null)
                        DefaultTextStyle(
                          style:
                              theme.textTheme.bodySmall?.copyWith(
                                color: textColor.withValues(alpha: 0.7),
                              ) ??
                              TextStyle(
                                color: textColor.withValues(alpha: 0.7),
                                fontSize: 12 * zoomScale,
                              ),
                          child: widget.subtitle!,
                        ),
                    ],
                  ),
                ),

                // Trailing widget
                if (widget.trailing != null) ...[
                  SizedBox(width: 8 * zoomScale),
                  IconTheme(
                    data: IconThemeData(
                      size: 16 * zoomScale,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                    child: widget.trailing!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    // Border when selected
    if (widget.isSelected) {
      content = Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: appColorScheme.interactive.input.focusBorder,
              width: 2 * borderScale,
            ),
          ),
        ),
        child: content,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        content,

        // Children (only when expanded)
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.children,
          ),
          crossFadeState:
              widget.isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
          duration: widget.animationDuration,
        ),
      ],
    );
  }
}
