import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class IconButtonPage extends StatelessWidget {
  const IconButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Icon Button',
          description: 'Icon button variants',
          children: [
            CatalogDemo(
              label: 'Default',
              child: Wrap(
                spacing: 8,
                children: [
                  FondeIconButton(icon: LucideIcons.settings, onPressed: () {}),
                  FondeIconButton(
                    icon: LucideIcons.settings,
                    onPressed: () {},
                    enabled: false,
                  ),
                ],
              ),
            ),
            CatalogDemo(
              label: '.circle',
              child: Wrap(
                spacing: 8,
                children: [
                  FondeIconButton.circle(
                    icon: LucideIcons.plus,
                    onPressed: () {},
                  ),
                  FondeIconButton.circle(
                    icon: LucideIcons.x,
                    onPressed: () {},
                    enabled: false,
                  ),
                ],
              ),
            ),
            CatalogDemo(
              label: '.compact',
              child: Wrap(
                spacing: 8,
                children: [
                  FondeIconButton.compact(
                    icon: LucideIcons.pencil,
                    onPressed: () {},
                  ),
                  FondeIconButton.minimal(
                    icon: LucideIcons.trash2,
                    onPressed: () {},
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
