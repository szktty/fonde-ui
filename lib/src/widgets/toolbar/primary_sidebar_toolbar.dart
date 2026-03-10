import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal.dart';
import '../../riverpod/widgets/sidebar_state_providers.dart';
import '../widgets/fonde_icon_button.dart';
import '../icons/icon_theme_providers.dart';

// Width occupied by macOS traffic light buttons (red, yellow, green).
const double _macOSTrafficLightButtonsWidth = 90.0;
// Safe area on the left side, considering the traffic light buttons.
const double _macOSLeftSafeArea = _macOSTrafficLightButtonsWidth + 8.0;

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          // If available width is not sufficient, display only the collapse button
          final availableWidth = constraints.maxWidth;
          final minRequiredWidth =
              _macOSTrafficLightButtonsWidth + 40; // Considering button width

          if (availableWidth < minRequiredWidth) {
            return const SizedBox.shrink(); // Display nothing if width is insufficient
          }

          return Padding(
            padding: Platform.isMacOS
                ? const EdgeInsets.only(top: 2.0)
                : EdgeInsets.zero,
            child: Row(
              children: [
                // Traffic light safe area (macOS only)
                if (Platform.isMacOS) const SizedBox(width: _macOSLeftSafeArea),
                // Sidebar collapse button at the left edge of the sidebar area
                Center(child: _buildPrimarySidebarToggle(ref, iconTheme)),
                // Remaining space
                const Expanded(child: SizedBox()),
              ],
            ),
          );
        },
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
