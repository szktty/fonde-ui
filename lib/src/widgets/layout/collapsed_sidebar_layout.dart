import 'package:flutter/material.dart';
import '../widgets/fonde_divider.dart';
import 'launch_bar_wrapper.dart';

/// Layout when the sidebar is hidden.
///
/// Composed of three elements: toolbar, launch bar, and main content.
class FondeCollapsedSidebarLayout extends StatelessWidget {
  const FondeCollapsedSidebarLayout({
    required this.toolbar,
    required this.mainContent,
    this.launchBar,
    this.showLaunchBar = true,
    this.zoomScale = 1.0,
    this.borderScale = 1.0,
    this.disableZoom = false,
    super.key,
  });

  /// The main toolbar widget.
  final Widget toolbar;

  /// The main content widget.
  final Widget mainContent;

  /// The launch bar widget (optional).
  final Widget? launchBar;

  /// Whether to show the launch bar.
  final bool showLaunchBar;

  /// The zoom scale.
  final double zoomScale;

  /// The scale of the border.
  final double borderScale;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  @override
  Widget build(BuildContext context) {
    final hasLaunchBar = launchBar != null && showLaunchBar;

    return Row(
      children: [
        // Launch Bar - full height, fixed width.
        if (hasLaunchBar)
          FondeLaunchBarWrapper(zoomScale: zoomScale, child: launchBar!),

        // Border between Launch Bar and main area.
        if (hasLaunchBar)
          FondeVerticalDivider(
            width: 1.0 * borderScale,
            disableZoom: disableZoom,
          ),

        // Main area: toolbar + content
        Expanded(
          child: Column(children: [toolbar, Expanded(child: mainContent)]),
        ),
      ],
    );
  }
}
