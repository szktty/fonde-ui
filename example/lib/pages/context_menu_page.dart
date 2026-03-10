import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class ContextMenuPage extends StatelessWidget {
  const ContextMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Context Menu',
          description: 'Context menu (generic trigger + icon button trigger)',
          children: [
            CatalogDemo(
              label: 'FondeContextMenuButton',
              child: FondeContextMenuButton(
                tooltip: 'More options',
                items: [
                  FondeContextMenuItem(label: 'Edit', onPressed: () {}),
                  FondeContextMenuItem(label: 'Duplicate', onPressed: () {}),
                  const FondeContextMenuDivider(),
                  FondeContextMenuItem(
                    label: 'Delete',
                    onPressed: () {},
                    isDangerous: true,
                  ),
                ],
              ),
            ),
            CatalogDemo(
              label: 'Custom trigger',
              child: FondeContextMenu(
                items: [
                  FondeContextMenuItem(label: 'Cut', onPressed: () {}),
                  FondeContextMenuItem(label: 'Copy', onPressed: () {}),
                  FondeContextMenuItem(label: 'Paste', onPressed: () {}),
                ],
                builder: (context, controller, child) {
                  return FondeButton.normal(
                    label: 'Open Menu',
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
