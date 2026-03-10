import 'package:flutter/material.dart';
import '../widgets/fonde_divider.dart';
import 'launch_bar_wrapper.dart';

/// The primary side area composing the launch bar and sidebar pane.
///
/// The launch bar spans full height on the left.
/// The sidebar pane (toolbar + content) occupies the remaining width.
class FondePrimarySide extends StatelessWidget {
  const FondePrimarySide({
    this.launchBar,
    this.sidebar,
    this.showLaunchBar = true,
    this.showSidebar = true,
    this.zoomScale = 1.0,
    this.borderScale = 1.0,
    this.disableZoom = false,
    super.key,
  });

  /// Launch bar widget (optional).
  final Widget? launchBar;

  /// Sidebar pane widget (optional). Typically a [FondeSidebarPane].
  final Widget? sidebar;

  /// Whether to show the launch bar.
  final bool showLaunchBar;

  /// Whether to show the sidebar.
  final bool showSidebar;

  /// The zoom scale.
  final double zoomScale;

  /// The scale of the border.
  final double borderScale;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  bool get _shouldShow {
    return (launchBar != null && showLaunchBar) ||
        (sidebar != null && showSidebar);
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldShow) return const SizedBox.shrink();

    final hasLaunchBar = launchBar != null && showLaunchBar;
    final hasSidebar = sidebar != null && showSidebar;

    return Row(
      children: [
        // Launch Bar - full height, fixed width.
        if (hasLaunchBar)
          FondeLaunchBarWrapper(zoomScale: zoomScale, child: launchBar!),

        // Border between Launch Bar and Sidebar.
        if (hasLaunchBar && hasSidebar)
          FondeVerticalDivider(
            width: 1.0 * borderScale,
            disableZoom: disableZoom,
          ),

        // Sidebar pane (toolbar + content).
        if (hasSidebar) Expanded(child: sidebar!),
      ],
    );
  }
}
