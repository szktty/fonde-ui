import 'package:flutter/material.dart';
import '../../internal.dart';
import '../widgets/fonde_icon_button.dart';

/// Title bar for the primary sidebar.
class FondePrimarySidebarToolbar extends StatelessWidget {
  const FondePrimarySidebarToolbar({
    this.backgroundColor,
    this.borderColor,
    super.key,
  });

  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final iconTheme = context.fondeIconTheme;

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
                    FondeIconButton(
                      icon: iconTheme.panelLeftClose,
                      iconSize: 20,
                      onPressed: () {
                        FondeSidebarControllerScope.primaryOf(context)?.hide();
                      },
                      tooltip: 'Close Sidebar',
                      padding: EdgeInsets.zero,
                      hoverColor: Colors.transparent,
                    ),
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
}
