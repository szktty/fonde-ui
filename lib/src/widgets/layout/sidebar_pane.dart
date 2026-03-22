import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal.dart';
import '../navigation/sidebar.dart';
import '../toolbar/primary_sidebar_toolbar.dart';

/// A pane that combines a toolbar and sidebar content.
///
/// Used as the [sidebar] of [FondePrimarySide].
class FondeSidebarPane extends ConsumerWidget {
  const FondeSidebarPane({
    required this.child,
    this.toolbar,
    this.sidebarStyle = FondeSidebarStyle.standard,
    super.key,
  });

  /// The sidebar content widget (e.g., [FondeSidebarList]).
  final Widget child;

  /// The toolbar widget shown at the top of the pane.
  /// Defaults to [FondePrimarySidebarToolbar] if not specified.
  final Widget? toolbar;

  /// The sidebar style. When [FondeSidebarStyle.floatingPanel], the default
  /// toolbar background matches the panel background instead of the system
  /// toolbar color, making the toolbar and list visually unified.
  final FondeSidebarStyle sidebarStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget effectiveToolbar;
    if (toolbar != null) {
      effectiveToolbar = toolbar!;
    } else if (sidebarStyle == FondeSidebarStyle.floatingPanel) {
      final appColorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
      final panelBackground = appColorScheme.uiAreas.sideBar.background;
      effectiveToolbar = FondePrimarySidebarToolbar(
        backgroundColor: panelBackground,
        borderColor: appColorScheme.base.divider,
      );
    } else {
      effectiveToolbar = const FondePrimarySidebarToolbar();
    }

    return Column(children: [effectiveToolbar, Expanded(child: child)]);
  }
}
