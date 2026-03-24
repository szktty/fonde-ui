import 'package:flutter/material.dart';
import '../../internal.dart';

/// App-style tab bar.
/// Wraps Flutter's TabBar to provide app-specific accessibility and styling.
class FondeTabBar extends StatelessWidget {
  /// List of tabs.
  final List<FondeTab> tabs;

  /// The ID of the currently selected tab.
  final String selectedTabId;

  /// Callback for when a tab is selected.
  final void Function(String tabId) onTabSelected;

  /// Callback for when a tab is closed (optional).
  final void Function(String tabId)? onTabClosed;

  /// The height of the tab bar.
  final double height;

  /// Background color.
  final Color? backgroundColor;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  /// Tab alignment method (e.g., center alignment).
  final TabAlignment alignment;

  const FondeTabBar({
    super.key,
    required this.tabs,
    required this.selectedTabId,
    required this.onTabSelected,
    this.onTabClosed,
    this.height = 48.0,
    this.backgroundColor,
    this.disableZoom = false,
    this.alignment = TabAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final zoomScale = disableZoom ? 1.0 : context.fondeZoomScale;

    final effectiveBackgroundColor =
        backgroundColor ?? appColorScheme.base.background;

    // Get the index of the selected tab
    final selectedIndex = tabs
        .indexWhere((tab) => tab.id == selectedTabId)
        .clamp(0, tabs.length - 1);

    return Container(
      height: height * zoomScale,
      color: effectiveBackgroundColor,
      child: DefaultTabController(
        length: tabs.length,
        initialIndex: selectedIndex,
        animationDuration: Duration.zero,
        child: TabBar(
          isScrollable: true,
          tabAlignment: alignment,
          tabs: _buildTabs(zoomScale, appColorScheme),
          onTap: (index) => onTabSelected(tabs[index].id),
          indicatorColor: appColorScheme.theme.primaryColor,
          labelColor: appColorScheme.base.foreground,
          unselectedLabelColor: appColorScheme.base.foreground,
          dividerHeight: 0,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 2.0,
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ),
    );
  }

  /// Build the list of tabs.
  List<Widget> _buildTabs(double zoomScale, FondeColorScheme appColorScheme) {
    return tabs.map((tab) {
      final isSelected = tab.id == selectedTabId;

      return Tab(
        height: height * zoomScale,
        child: Container(
          constraints:
              tab.label != null
                  ? BoxConstraints(
                    minWidth: 120.0 * zoomScale,
                    maxWidth: double.infinity,
                  )
                  : null, // No constraint if only an icon
          padding:
              tab.label != null
                  ? EdgeInsets.symmetric(horizontal: 8.0 * zoomScale)
                  : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              if (tab.icon != null) ...[
                Icon(
                  tab.icon!,
                  size: 24.0 * zoomScale,
                  color:
                      isSelected
                          ? appColorScheme.theme.primaryColor
                          : appColorScheme.base.foreground,
                ),
                if (tab.label != null) SizedBox(width: 6.0 * zoomScale),
              ],
              // Label
              if (tab.label != null)
                Flexible(
                  child: Text(
                    tab.label!,
                    style: TextStyle(
                      fontSize: 14.0 * zoomScale,
                      fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              // Close button
              if (tab.closeable && onTabClosed != null) ...[
                SizedBox(width: 4.0 * zoomScale),
                GestureDetector(
                  onTap: () => onTabClosed!(tab.id),
                  child: Container(
                    width: 16.0 * zoomScale,
                    height: 16.0 * zoomScale,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.close,
                      size: 12.0 * zoomScale,
                      color: appColorScheme.base.foreground,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }).toList();
  }
}

/// Individual tab definition.
class FondeTab {
  /// The unique identifier for the tab.
  final String id;

  /// The text to display on the tab (optional).
  final String? label;

  /// The icon to display on the tab (optional).
  final IconData? icon;

  /// Whether the tab can be closed.
  final bool closeable;

  /// The tooltip for the tab.
  final String? tooltip;

  const FondeTab({
    required this.id,
    this.label,
    this.icon,
    this.closeable = true,
    this.tooltip,
  }) : assert(
         label != null || icon != null,
         'Either label or icon must be provided',
       );
}
