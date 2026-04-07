import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class OverflowMenuPage extends StatelessWidget {
  const OverflowMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Overflow Menu',
          description: 'Menu that groups items that do not fit on screen',
          children: [
            CatalogDemo(
              label: 'Basic',
              child: FondeOverflowMenu(
                items: [
                  FondeOverflowMenuItem(
                    title: 'Rename',
                    value: 'rename',
                    icon: LucideIcons.pencil,
                    onSelected: () {},
                  ),
                  FondeOverflowMenuItem(
                    title: 'Duplicate',
                    value: 'duplicate',
                    icon: LucideIcons.copy,
                    onSelected: () {},
                  ),
                  const FondeOverflowMenuDivider(),
                  FondeOverflowMenuItem(
                    title: 'Delete',
                    value: 'delete',
                    icon: LucideIcons.trash2,
                    onSelected: () {},
                  ),
                ],
              ),
            ),
            CatalogDemo(
              label: 'Without icons',
              child: FondeOverflowMenu(
                items: [
                  FondeOverflowMenuItem(
                    title: 'Cut',
                    value: 'cut',
                    onSelected: () {},
                  ),
                  FondeOverflowMenuItem(
                    title: 'Copy',
                    value: 'copy',
                    onSelected: () {},
                  ),
                  FondeOverflowMenuItem(
                    title: 'Paste',
                    value: 'paste',
                    onSelected: () {},
                  ),
                ],
              ),
            ),
            CatalogDemo(
              label: 'With disabled item',
              child: FondeOverflowMenu(
                items: [
                  FondeOverflowMenuItem(
                    title: 'Save',
                    value: 'save',
                    icon: LucideIcons.save,
                    onSelected: () {},
                  ),
                  FondeOverflowMenuItem(
                    title: 'Export',
                    value: 'export',
                    icon: LucideIcons.upload,
                    enabled: false,
                    onSelected: () {},
                  ),
                  FondeOverflowMenuItem(
                    title: 'Share',
                    value: 'share',
                    icon: LucideIcons.share2,
                    onSelected: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
