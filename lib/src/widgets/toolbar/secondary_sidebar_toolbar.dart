import 'package:flutter/material.dart';
import '../../internal.dart';
import '../widgets/fonde_icon_button.dart';

/// Title bar for the secondary sidebar.
class FondeSecondarySidebarToolbar extends StatelessWidget {
  const FondeSecondarySidebarToolbar({this.actions = const [], super.key});

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final iconTheme = context.fondeIconTheme;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: appColorScheme.uiAreas.toolbar.background,
        border: Border(
          bottom: BorderSide(
            color: appColorScheme.uiAreas.toolbar.border,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          ...actions.map(
            (action) => Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: action,
            ),
          ),
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FondeIconButton(
              icon: iconTheme.panelRightClose,
              iconSize: 20,
              onPressed: () {
                FondeSidebarControllerScope.secondaryOf(context)?.hide();
              },
              tooltip: 'Close Details Panel',
              padding: EdgeInsets.zero,
              hoverColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
