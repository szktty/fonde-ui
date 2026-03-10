import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal.dart';
import '../widgets/fonde_gesture_detector.dart';
import '../icons/icon_theme_providers.dart';
import 'sidebar_list_item.dart';

/// A collapsible group of navigation items.
class FondeSidebarListGroup extends ConsumerStatefulWidget {
  /// The unique identifier for the widget.
  final String id;

  /// The title of the group.
  final String title;

  /// The child widgets of the group.
  final List<Widget> children;

  /// The icon for the group.
  final Widget? icon;

  /// Whether to expand initially.
  final bool initiallyExpanded;

  /// Whether it is currently expanded (for external control).
  final bool isExpanded;

  /// Callback for when the expansion state changes.
  final ValueChanged<bool>? onExpansionChanged;

  /// The text style for the title.
  final TextStyle? titleStyle;

  /// The background color.
  final Color? backgroundColor;

  /// An additional widget to display on the right.
  final Widget? trailing;

  /// The expansion icon.
  final Widget? expansionIcon;

  /// The size of the indent for child items.
  final double childrenIndent;

  /// The duration of the animation (Note: always Duration.zero due to Design Principle #6).
  final Duration animationDuration;

  /// The selection state.
  final bool isSelected;

  /// The background color when selected.
  final Color? selectedBackgroundColor;

  /// The visual style of the group header.
  final FondeSidebarListItemStyle style;

  /// Callback for when the group header is tapped (for selection).
  final VoidCallback? onTap;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  /// Creates a new [FondeSidebarListGroup].
  ///
  /// [id] - The unique identifier for the group.
  /// [title] - The title to display.
  /// [children] - The child widgets of the group.
  /// [icon] - The icon for the group.
  /// [initiallyExpanded] - Whether to expand initially.
  /// [isExpanded] - Whether it is currently expanded (for external control).
  /// [onExpansionChanged] - Callback for when the expansion state changes.
  /// [titleStyle] - The text style for the title.
  /// [backgroundColor] - The background color.
  /// [trailing] - An additional widget to display on the right.
  /// [expansionIcon] - A custom expansion icon.
  /// [childrenIndent] - The size of the indent for child items.
  /// [animationDuration] - The duration of the animation.
  const FondeSidebarListGroup({
    required this.id,
    required this.title,
    required this.children,
    this.icon,
    this.initiallyExpanded = false,
    this.isExpanded = false,
    this.onExpansionChanged,
    this.titleStyle,
    this.backgroundColor,
    this.trailing,
    this.expansionIcon,
    this.childrenIndent = 24.0,
    this.animationDuration = Duration.zero,
    this.isSelected = false,
    this.selectedBackgroundColor,
    this.style = FondeSidebarListItemStyle.filled,
    this.onTap,
    this.disableZoom = false,
    super.key,
  });

  @override
  ConsumerState<FondeSidebarListGroup> createState() => _NavigationGroupState();
}

class _NavigationGroupState extends ConsumerState<FondeSidebarListGroup> {
  late bool _isExpandedState;

  @override
  void initState() {
    super.initState();
    _isExpandedState = widget.initiallyExpanded || widget.isExpanded;
  }

  @override
  void didUpdateWidget(FondeSidebarListGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the expansion state is changed from the outside, reflect it.
    if (widget.isExpanded != _isExpandedState) {
      setState(() {
        _isExpandedState = widget.isExpanded;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accessibilityConfig = ref.watch(fondeAccessibilityConfigProvider);
    final iconTheme = ref.watch(fondeDefaultIconThemeProvider);
    final zoomScale = widget.disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    // Height factor (no animation, direct state change)
    final heightFactor = _isExpandedState ? 1.0 : 0.0;

    final theme = Theme.of(context);
    final colorScope = ref.watch(fondeSideBarColorScopeProvider);
    final effectiveSelectedBackground = switch (widget.style) {
      FondeSidebarListItemStyle.filled => colorScope.selection,
      FondeSidebarListItemStyle.subtle => colorScope.subtleSelection,
    };
    final effectiveBackgroundColor =
        widget.isSelected
            ? widget.selectedBackgroundColor ?? effectiveSelectedBackground
            : widget.backgroundColor;
    final effectiveContentColor =
        widget.isSelected ? colorScope.accent : colorScope.text;
    final effectiveTitleStyle =
        widget.titleStyle ??
        (theme.textTheme.titleSmall ?? const TextStyle(fontSize: 14)).copyWith(
          fontWeight: FontWeight.w500,
          color: effectiveContentColor,
        );

    // Custom expansion icon or default chevron icon (no animation)
    Widget expansionIcon() {
      if (widget.expansionIcon != null) {
        return widget.expansionIcon!;
      } else {
        return Icon(
          _isExpandedState ? iconTheme.chevronDown : iconTheme.chevronRight,
          size: 18 * zoomScale,
          color: effectiveContentColor,
        );
      }
    }

    void toggleExpansion() {
      final newExpandedState = !_isExpandedState;
      setState(() {
        _isExpandedState = newExpandedState;
      });
      widget.onExpansionChanged?.call(newExpandedState);
    }

    // Header part: expansion icon (toggle) + content area (select)
    final header = Container(
      color: effectiveBackgroundColor,
      child: Row(
        children: [
          // Expansion icon: tapping toggles expand/collapse
          FondeGestureDetector(
            onTapUp: (_) => toggleExpansion(),
            cursor: SystemMouseCursors.click,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.only(
                left: 16 * zoomScale,
                top: 8 * zoomScale,
                bottom: 8 * zoomScale,
                right: 8 * zoomScale,
              ),
              child: expansionIcon(),
            ),
          ),
          // Content area: tapping selects the group
          Expanded(
            child: FondeGestureDetector(
              onTapUp: (_) => widget.onTap?.call(),
              cursor: SystemMouseCursors.click,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.only(
                  right: 16 * zoomScale,
                  top: 8 * zoomScale,
                  bottom: 8 * zoomScale,
                ),
                child: Row(
                  children: [
                    if (widget.icon != null)
                      Padding(
                        padding: EdgeInsets.only(right: 12 * zoomScale),
                        child: IconTheme.merge(
                          data: IconThemeData(color: effectiveContentColor),
                          child: widget.icon!,
                        ),
                      ),
                    Expanded(
                      child: Text(widget.title, style: effectiveTitleStyle),
                    ),
                    if (widget.trailing != null) widget.trailing!,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // Indented child widgets
    final indentedChildren =
        widget.children.map((child) {
          return Padding(
            padding: EdgeInsets.only(left: widget.childrenIndent * zoomScale),
            child: child,
          );
        }).toList();

    // The part containing the child elements
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        if (_isExpandedState)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: indentedChildren,
          ),
      ],
    );
  }
}
