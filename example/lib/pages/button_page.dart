import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../widgets/catalog_page.dart';

class ButtonPage extends StatelessWidget {
  const ButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Button',
          description: 'Role-based variants and states',
          children: [
            CatalogDemo(
              label: 'normal',
              child: Wrap(
                spacing: 8,
                children: [
                  FondeButton.normal(label: 'Normal', onPressed: () {}),
                  FondeButton.normal(label: 'Disabled'),
                ],
              ),
            ),
            CatalogDemo(
              label: 'primary',
              child: Wrap(
                spacing: 8,
                children: [
                  FondeButton.primary(label: 'Primary', onPressed: () {}),
                  FondeButton.primary(label: 'Disabled'),
                ],
              ),
            ),
            CatalogDemo(
              label: 'cancel',
              child: Wrap(
                spacing: 8,
                children: [
                  FondeButton.cancel(label: 'Cancel', onPressed: () {}),
                  FondeButton.cancel(label: 'Disabled'),
                ],
              ),
            ),
            CatalogDemo(
              label: 'destructive',
              child: Wrap(
                spacing: 8,
                children: [
                  FondeButton.destructive(label: 'Delete', onPressed: () {}),
                  FondeButton.destructive(label: 'Disabled'),
                ],
              ),
            ),
            CatalogDemo(
              label: 'With icon',
              child: Wrap(
                spacing: 8,
                children: [
                  FondeButton.normal(
                    label: 'Leading',
                    leadingIcon: const Icon(LucideIcons.plus, size: 16),
                    onPressed: () {},
                  ),
                  FondeButton.normal(
                    label: 'Trailing',
                    trailingIcon: const Icon(LucideIcons.chevronDown, size: 16),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
        CatalogSection(
          title: 'Button Group',
          description: 'Grouping of buttons',
          children: [
            CatalogDemo(
              label: 'ButtonGroupItem (icon)',
              child: FondeButtonGroup(
                children: [
                  FondeButtonGroupItem(
                    icon: LucideIcons.bold,
                    onPressed: () {},
                  ),
                  FondeButtonGroupItem(
                    icon: LucideIcons.italic,
                    onPressed: () {},
                    isSelected: true,
                  ),
                  FondeButtonGroupItem(
                    icon: LucideIcons.underline,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            CatalogDemo(
              label: 'ButtonGroupItem (label)',
              child: FondeButtonGroup(
                children: [
                  FondeButtonGroupItem(label: 'Cut', onPressed: () {}),
                  FondeButtonGroupItem(label: 'Copy', onPressed: () {}),
                  FondeButtonGroupItem(label: 'Paste', onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
