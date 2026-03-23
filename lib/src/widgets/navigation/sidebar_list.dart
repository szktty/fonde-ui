import 'package:flutter/material.dart';
import '../../core/context_extensions.dart';
import '../../internal.dart';
import 'sidebar.dart';
import 'sidebar_list_item.dart';
import 'sidebar_list_group.dart';

/// A container for navigation items.
///
/// This widget functions as a container for navigation items, and manages a
/// scrollable area.
class FondeSidebarList extends StatelessWidget {
  /// A list of navigation items.
  final List<Widget> children;

  /// The padding of the container.
  final EdgeInsets padding;

  /// The background color.
  final Color? backgroundColor;

  /// The scroll physics.
  final ScrollPhysics? physics;

  /// Whether to size the scroll area to the size of its children.
  final bool shrinkWrap;

  /// The ID of the selected item.
  final String? selectedItemId;

  /// The ID of the expanded group.
  final List<String> expandedGroupIds;

  /// Callback for when an item is selected.
  final void Function(String)? onItemSelected;

  /// Callback for when a group is expanded/collapsed.
  final void Function(String)? onGroupToggled;

  /// The default indent for child elements.
  final double defaultIndent;

  /// The visual style applied to all navigation items and groups.
  final FondeSidebarListItemStyle style;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  /// Creates a [FondeSidebarList].
  ///
  /// [children] - A list of navigation items.
  /// [padding] - The padding of the container.
  /// [backgroundColor] - The background color.
  /// [physics] - The scroll physics.
  /// [shrinkWrap] - Whether to size the scroll area to the size of its children.
  /// [selectedItemId] - The ID of the selected item.
  /// [expandedGroupIds] - A list of IDs of expanded groups.
  /// [onItemSelected] - Callback for when an item is selected.
  /// [onGroupToggled] - Callback for when a group is expanded.
  /// [defaultIndent] - The default indent for child elements.
  const FondeSidebarList({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(8),
    this.backgroundColor,
    this.physics,
    this.shrinkWrap = false,
    this.selectedItemId,
    this.expandedGroupIds = const [],
    this.onItemSelected,
    this.onGroupToggled,
    this.defaultIndent = 24.0,
    this.style = FondeSidebarListItemStyle.filled,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context) {
    final zoomScale = disableZoom ? 1.0 : context.fondeZoomScale;

    final colorScheme = context.fondeColorScheme;
    final isFloatingPanel = FondeFloatingPanelScope.of(context);
    final resolvedBackground =
        backgroundColor ??
        (isFloatingPanel
            ? Colors.transparent
            : colorScheme.uiAreas.sideBar.background);

    return Container(
      color: resolvedBackground,
      child: ListView(
        padding: padding * zoomScale,
        physics: physics,
        shrinkWrap: shrinkWrap,
        children: _processChildren(children, zoomScale),
      ),
    );
  }

  /// Process child widgets to apply selection and expansion states.
  List<Widget> _processChildren(List<Widget> items, double zoomScale) {
    return items.map((child) {
      if (child is FondeSidebarListItem) {
        return _processNavigationItem(child, zoomScale);
      } else if (child is FondeSidebarListGroup) {
        return _processNavigationGroup(child, zoomScale);
      } else {
        return child; // Return NavigationDivider, etc. as is.
      }
    }).toList();
  }

  /// Process NavigationItem.
  Widget _processNavigationItem(FondeSidebarListItem item, double zoomScale) {
    final isSelected = selectedItemId != null && item.id == selectedItemId;
    final indent = (item.indent > 0 ? item.indent : defaultIndent) * zoomScale;

    return FondeSidebarListItem(
      id: item.id,
      title: item.title,
      leading: item.leading,
      trailing: item.trailing,
      isSelected: isSelected,
      onTapDown: item.onTapDown,
      onTapUp: (_) => onItemSelected?.call(item.id),
      onTap: item.onTap,
      padding: item.padding,
      titleStyle: item.titleStyle,
      backgroundColor: item.backgroundColor,
      selectedBackgroundColor: item.selectedBackgroundColor,
      indent: indent,
      style:
          item.style != FondeSidebarListItemStyle.filled ? item.style : style,
      disableZoom: disableZoom,
    );
  }

  /// Process NavigationGroup.
  Widget _processNavigationGroup(
    FondeSidebarListGroup group,
    double zoomScale,
  ) {
    final isExpanded = expandedGroupIds.contains(group.id);
    final isSelected = selectedItemId != null && group.id == selectedItemId;

    return FondeSidebarListGroup(
      id: group.id,
      title: group.title,
      icon: group.icon,
      isExpanded: isExpanded,
      isSelected: isSelected,
      onExpansionChanged: (expanded) {
        onGroupToggled?.call(group.id);
        group.onExpansionChanged?.call(expanded);
      },
      onTap: () {
        onItemSelected?.call(group.id);
        group.onTap?.call();
      },
      titleStyle: group.titleStyle,
      backgroundColor: group.backgroundColor,
      selectedBackgroundColor: group.selectedBackgroundColor,
      trailing: group.trailing,
      expansionIcon: group.expansionIcon,
      childrenIndent: group.childrenIndent,
      style:
          group.style != FondeSidebarListItemStyle.filled ? group.style : style,
      disableZoom: disableZoom,
      children: _processChildren(group.children, zoomScale),
    );
  }
}
