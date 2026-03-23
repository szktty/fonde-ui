import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import '../../core/context_extensions.dart';
import '../../internal.dart';
import '../toolbar/primary_sidebar_toolbar.dart';

/// InheritedWidget that marks a floating panel scope.
///
/// Used by [FondeSidebarList] to detect when it is inside a floating panel
/// and should use a transparent background instead of the default sidebar color.
class FondeFloatingPanelScope extends InheritedWidget {
  const FondeFloatingPanelScope({required super.child, super.key});

  static bool of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<FondeFloatingPanelScope>() !=
        null;
  }

  @override
  bool updateShouldNotify(FondeFloatingPanelScope oldWidget) => false;
}

/// The visual style of the sidebar.
enum FondeSidebarStyle {
  /// Standard sidebar with a flat background and a right divider (default).
  standard,

  /// macOS-style floating panel: toolbar and content float together as a
  /// rounded rectangle over a lighter outer background.
  floatingPanel,
}

/// A general-purpose widget that represents the application's sidebar.
///
/// Can be used as a primary or secondary sidebar.
/// Applies the appropriate background color based on the theme.
///
/// When [style] is [FondeSidebarStyle.floatingPanel], the sidebar renders a
/// toolbar ([FondePrimarySidebarToolbar] by default) and the [child] together
/// inside a single floating rounded-rectangle panel. The outer area uses the
/// main background color (Level 1) so the panel appears to float.
class FondeSidebar extends StatelessWidget {
  /// The main content to display within the sidebar (e.g. [FondeSidebarList]).
  final Widget child;

  /// The width of the sidebar (default: 280.0).
  final double width;

  /// The background color of the sidebar. If not specified, it is obtained from the theme.
  final Color? backgroundColor;

  /// The border of the sidebar. By default, a divider is displayed on the right side.
  /// Ignored when [style] is [FondeSidebarStyle.floatingPanel].
  final Border? border;

  /// The visual style of the sidebar.
  final FondeSidebarStyle style;

  /// Custom toolbar to display at the top of the floating panel.
  /// Only used when [style] is [FondeSidebarStyle.floatingPanel].
  /// Defaults to [FondePrimarySidebarToolbar] with panel background color.
  final Widget? toolbar;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  const FondeSidebar({
    required this.child,
    this.width = 280.0,
    this.backgroundColor,
    this.border,
    this.style = FondeSidebarStyle.standard,
    this.toolbar,
    this.disableZoom = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final zoomScale = disableZoom ? 1.0 : context.fondeZoomScale;
    final borderScale = disableZoom ? 1.0 : context.fondeBorderScale;

    final appColorScheme = context.fondeColorScheme;

    if (style == FondeSidebarStyle.floatingPanel) {
      final outerBackground =
          appColorScheme.uiAreas.sideBar.floatingPanelOuterBackground;
      final panelBackground =
          backgroundColor ??
          appColorScheme.uiAreas.sideBar.floatingPanelBackground;
      final shadowColor = appColorScheme.base.shadow;
      final panelMargin = 8.0 * zoomScale;
      final cornerRadius = 10.0 * zoomScale;
      final effectiveToolbar =
          toolbar ??
          FondePrimarySidebarToolbar(
            backgroundColor: panelBackground,
            borderColor: Colors.transparent,
          );

      return Container(
        width: width * zoomScale,
        color: outerBackground,
        padding: EdgeInsets.all(panelMargin),
        child: Container(
          decoration: ShapeDecoration(
            color: panelBackground,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: cornerRadius,
                cornerSmoothing: 0.6,
              ),
            ),
            shadows: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 8.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              effectiveToolbar,
              Expanded(
                child: ColoredBox(
                  color: panelBackground,
                  child: FondeFloatingPanelScope(child: child),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Standard style
    final resolvedBackgroundColor =
        backgroundColor ?? appColorScheme.uiAreas.sideBar.background;
    final resolvedBorder =
        border ??
        Border(
          right: BorderSide(
            color: appColorScheme.base.divider,
            width: 1.0 * borderScale,
          ),
        );

    Widget content = child;
    if (toolbar != null) {
      content = Column(children: [toolbar!, Expanded(child: child)]);
    }

    return Container(
      width: width * zoomScale,
      decoration: BoxDecoration(
        color: resolvedBackgroundColor,
        border: resolvedBorder,
      ),
      child: content,
    );
  }
}
