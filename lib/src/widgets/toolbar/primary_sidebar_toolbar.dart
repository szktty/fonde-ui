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
  const FondePrimarySidebarToolbar({
    this.backgroundColor,
    this.borderColor,
    super.key,
  });

  /// Override the toolbar background color.
  /// When null, defaults to [FondeToolbarColors.background].
  final Color? backgroundColor;

  /// Override the bottom border color.
  /// When null, defaults to [FondeToolbarColors.border].
  final Color? borderColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    final iconTheme = ref.watch(fondeDefaultIconThemeProvider);

    final effectiveBackground =
        backgroundColor ?? appColorScheme.uiAreas.toolbar.background;
    final effectiveBorderColor =
        borderColor ?? appColorScheme.uiAreas.toolbar.border;

    return SizedBox(
      height: 50,
      child: ColoredBox(
        color: effectiveBackground,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Row(
                  children: [
                    _buildPrimarySidebarToggle(ref, iconTheme),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
            if (effectiveBorderColor != Colors.transparent)
              Divider(height: 1, thickness: 1, color: effectiveBorderColor),
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
