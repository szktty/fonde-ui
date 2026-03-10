import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../widgets/catalog_page.dart';

class ListTilePage extends StatelessWidget {
  const ListTilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'List Tile',
          description: 'List item',
          children: [
            CatalogDemo(
              label: 'Basic',
              child: SizedBox(
                width: 400,
                child: Column(
                  children: [
                    FondeListTile(
                      title: const FondeText(
                        'Title only',
                        variant: FondeTextVariant.bodyText,
                      ),
                      isSelected: false,
                      onTap: () {},
                    ),
                    FondeListTile(
                      title: const FondeText(
                        'With subtitle',
                        variant: FondeTextVariant.bodyText,
                      ),
                      isSelected: false,
                      subtitle: const FondeText(
                        'Subtitle text',
                        variant: FondeTextVariant.captionText,
                      ),
                      onTap: () {},
                    ),
                    FondeListTile(
                      title: const FondeText(
                        'With leading',
                        variant: FondeTextVariant.bodyText,
                      ),
                      isSelected: false,
                      leading: const Icon(LucideIcons.folder, size: 16),
                      onTap: () {},
                    ),
                    FondeListTile(
                      title: const FondeText(
                        'Selected',
                        variant: FondeTextVariant.bodyText,
                      ),
                      isSelected: true,
                      leading: const Icon(LucideIcons.check, size: 16),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
