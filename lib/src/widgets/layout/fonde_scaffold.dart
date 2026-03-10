import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_split_view/multi_split_view.dart';
import '../../internal.dart';

import '../../riverpod/widgets/sidebar_width_provider.dart';
import '../../riverpod/widgets/sidebar_state_providers.dart';
import '../icons/icon_theme_providers.dart';
import '../toolbar/primary_sidebar_toolbar.dart';
import '../toolbar/secondary_sidebar_toolbar.dart';
import '../widgets/fonde_icon_button.dart';
import 'collapsed_sidebar_layout.dart';
import 'main_content_area.dart';
import 'primary_side.dart';
import 'sidebar_pane.dart';

/// The top-level scaffold layout of a fonde_ui application.
///
/// Layout configuration:
/// - Top: Toolbar (fixed height)
/// - Bottom: Main layout
///   - Launch bar (variable width)
///   - Primary sidebar (variable width)
///   - Main content (flex)
///   - Secondary sidebar (variable width, optional)
class FondeScaffold extends ConsumerStatefulWidget {
  const FondeScaffold({
    required this.toolbar,
    required this.content,
    this.launchBar,
    this.primarySidebar,
    this.secondarySidebar,
    this.showLaunchBar = true,
    this.showPrimarySidebar = true,
    this.showSecondarySidebar = true,
    this.disableZoom = false,
    this.useSafeArea,
    super.key,
  });

  final Widget toolbar;
  final Widget content;
  final Widget? launchBar;
  final Widget? primarySidebar;
  final Widget? secondarySidebar;

  /// Whether to show the launch bar.
  final bool showLaunchBar;

  /// Whether to show the primary sidebar.
  final bool showPrimarySidebar;

  /// Whether to show the secondary sidebar.
  final bool showSecondarySidebar;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  /// Whether to wrap the scaffold in a [SafeArea].
  /// Defaults to `true` on iOS and Android, `false` otherwise.
  /// Set explicitly to override the default behaviour.
  final bool? useSafeArea;

  @override
  ConsumerState<FondeScaffold> createState() => _FondeScaffoldState();
}

bool get _isMobilePlatform =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);

class _FondeScaffoldState extends ConsumerState<FondeScaffold> {
  bool get _effectiveUseSafeArea => widget.useSafeArea ?? _isMobilePlatform;

  Widget _wrapSafeArea(Widget child) =>
      _effectiveUseSafeArea ? SafeArea(child: child) : child;
  @override
  Widget build(BuildContext context) {
    final accessibilityConfig = ref.watch(fondeAccessibilityConfigProvider);
    final zoomScale = widget.disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = widget.disableZoom
        ? 1.0
        : accessibilityConfig.borderScale;
    final appColorScheme = ref.watch(fondeEffectiveColorSchemeProvider);

    // Watch the visibility state of the sidebars
    final sidebarVisible =
        widget.showPrimarySidebar &&
        ref.watch(fondePrimarySidebarStateProvider);
    final secondarySidebarVisible = ref.watch(
      fondeSecondarySidebarStateProvider,
    );

    // If the sidebar is hidden, use CollapsedSidebarLayout
    if (!sidebarVisible) {
      final iconTheme = ref.watch(fondeDefaultIconThemeProvider);
      final openButton = FondeIconButton(
        icon: iconTheme.panelLeft,
        iconSize: 20,
        onPressed: () {
          ref.read(fondePrimarySidebarStateProvider.notifier).show();
        },
        tooltip: 'Open Sidebar',
        padding: EdgeInsets.zero,
        hoverColor: Colors.transparent,
      );
      return _wrapSafeArea(
        FondeCollapsedSidebarLayout(
          toolbar: Stack(
            children: [
              widget.toolbar,
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Center(child: openButton),
              ),
            ],
          ),
          mainContent: _buildMainContent(context, zoomScale, 288.0 * zoomScale),
          launchBar: widget.launchBar,
          showLaunchBar: widget.showLaunchBar,
          zoomScale: zoomScale,
          borderScale: borderScale,
          disableZoom: widget.disableZoom,
        ),
      );
    }

    // Get the sidebar width from the provider
    final primarySidebarBaseWidth = ref.watch(sidebarWidthProvider);
    final primarySidebarTotalWidth = primarySidebarBaseWidth * zoomScale;

    final secondarySidebarBaseWidth = ref.watch(secondarySidebarWidthProvider);
    final secondarySidebarTotalWidth = secondarySidebarBaseWidth * zoomScale;

    // If the secondary sidebar is visible, split into 3 parts, otherwise 2 parts
    final areas = <Area>[
      Area(
        id: 'primary_sidebar',
        size: primarySidebarTotalWidth,
        min: 240.0 * zoomScale,
        max: 480.0 * zoomScale,
      ),
      Area(id: 'main'),
      if (widget.secondarySidebar != null &&
          widget.showSecondarySidebar &&
          secondarySidebarVisible)
        Area(
          id: 'secondary_sidebar',
          size: secondarySidebarTotalWidth,
          min: 200.0 * zoomScale,
          max: 400.0 * zoomScale,
        ),
    ];

    // Controller for MultiSplitView
    final controller = MultiSplitViewController(areas: areas);

    return _wrapSafeArea(
      MultiSplitViewTheme(
        data: MultiSplitViewThemeData(
          dividerThickness: 2.0 * borderScale,
          dividerPainter: DividerPainters.background(
            color: appColorScheme.base.divider,
            highlightedColor: appColorScheme.theme.primaryColor,
          ),
          dividerHandleBuffer: 6,
        ),
        child: MultiSplitView(
          controller: controller,
          onDividerDragUpdate: (dividerIndex) {
            // Update the state when the sidebar width is changed
            final areas = controller.areas;
            if (dividerIndex == 0 && areas.isNotEmpty) {
              // Primary sidebar width change
              final newWidth = areas[0].size! / zoomScale;
              ref.read(sidebarWidthProvider.notifier).setWidth(newWidth);
            } else if (dividerIndex == 1 && areas.length > 2) {
              // Secondary sidebar width change
              final newWidth = areas[2].size! / zoomScale;
              ref
                  .read(secondarySidebarWidthProvider.notifier)
                  .setWidth(newWidth);
            }
          },
          builder: (context, area) {
            switch (area.id) {
              case 'primary_sidebar':
                return FondePrimarySide(
                  launchBar: widget.launchBar,
                  sidebar: widget.primarySidebar != null
                      ? FondeSidebarPane(child: widget.primarySidebar!)
                      : null,
                  showLaunchBar: widget.showLaunchBar,
                  showSidebar: widget.showPrimarySidebar,
                  zoomScale: zoomScale,
                  borderScale: borderScale,
                  disableZoom: widget.disableZoom,
                );
              case 'main':
                return Column(
                  children: [
                    // Toolbar (fixed height)
                    widget.toolbar,

                    // Main content
                    Expanded(
                      child: FondeMainContentArea(child: widget.content),
                    ),
                  ],
                );
              case 'secondary_sidebar':
                return Column(
                  children: [
                    // Toolbar for the secondary sidebar
                    const FondeSecondarySidebarToolbar(),

                    // Content of the secondary sidebar
                    Expanded(
                      child: widget.secondarySidebar ?? const SizedBox.shrink(),
                    ),
                  ],
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  /// Build the main content area (for CollapsedSidebarLayout).
  Widget _buildMainContent(
    BuildContext context,
    double zoomScale,
    double secondaryWidth,
  ) {
    return Row(
      children: [
        // Main Content - fill the remaining space
        Expanded(
          child: FondeMainContentArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 480 * zoomScale),
              child: widget.content,
            ),
          ),
        ),

        // Secondary Sidebar - show only if it exists and is visible
        if (widget.secondarySidebar != null && widget.showSecondarySidebar)
          SizedBox(width: secondaryWidth, child: widget.secondarySidebar!),
      ],
    );
  }
}
