import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal.dart';
import '../../riverpod/widgets/sidebar_state_providers.dart';
import '../widgets/fonde_icon_button.dart';
import '../icons/icon_theme_providers.dart';

/// Title bar for the primary sidebar.
///
/// A title bar placed at the top of the primary sidebar area, including a
/// sidebar collapse button.
class FondePrimarySidebarToolbar extends ConsumerWidget {
  const FondePrimarySidebarToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    final iconTheme = ref.watch(fondeDefaultIconThemeProvider);

    return Container(
      height: 50, // Same height as the main area title bar
      decoration: BoxDecoration(
        color: appColorScheme.uiAreas.toolbar.background,
        border: Border(
          bottom: BorderSide(
            color: appColorScheme.uiAreas.toolbar.border,
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            _buildPrimarySidebarToggle(ref, iconTheme),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }

  /// Build the primary sidebar collapse button.
  Widget _buildPrimarySidebarToggle(WidgetRef ref, FondeIconTheme iconTheme) {
    return FondeIconButton(
      icon: iconTheme.panelLeftClose, // Collapse icon
      iconSize: 20,
      onPressed: () {
        // Hide the sidebar
        ref.read(fondePrimarySidebarStateProvider.notifier).hide();
      },
      tooltip: 'Close Sidebar',
      padding: EdgeInsets.zero,
      hoverColor: Colors.transparent,
    );
  }
}
