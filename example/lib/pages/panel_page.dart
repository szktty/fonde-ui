import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class PanelPage extends StatefulWidget {
  const PanelPage({super.key});

  @override
  State<PanelPage> createState() => _PanelPageState();
}

class _PanelPageState extends State<PanelPage> {
  bool _panelSelected1 = false;
  bool _panelSelected2 = true;

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Panel',
          description: 'Panel with header, content, and footer structure',
          children: [
            CatalogDemo(
              label: 'Basic',
              child: FondePanel(
                content: FondePadding.all(
                  FondeSpacingValues.lg,
                  child: const FondeText(
                    'Panel content',
                    variant: FondeTextVariant.bodyText,
                  ),
                ),
              ),
            ),
            CatalogDemo(
              label: 'With header',
              child: FondePanel(
                header: FondePadding.all(
                  FondeSpacingValues.md,
                  child: const FondeText(
                    'Header',
                    variant: FondeTextVariant.sectionTitleSecondary,
                  ),
                ),
                content: FondePadding.all(
                  FondeSpacingValues.md,
                  child: const FondeText(
                    'Panel body content.',
                    variant: FondeTextVariant.bodyText,
                  ),
                ),
                footer: FondePadding.all(
                  FondeSpacingValues.md,
                  child: const FondeText(
                    'Footer',
                    variant: FondeTextVariant.captionText,
                  ),
                ),
              ),
            ),
            CatalogDemo(
              label: 'Tappable',
              child: FondePanel(
                onTap: () {},
                content: FondePadding.all(
                  FondeSpacingValues.lg,
                  child: const FondeText(
                    'Tap me',
                    variant: FondeTextVariant.bodyText,
                  ),
                ),
              ),
            ),
            CatalogDemo(
              label: 'Selected state',
              child: Wrap(
                spacing: FondeSpacingValues.md,
                children: [
                  FondePanel(
                    isSelected: _panelSelected1,
                    onTap:
                        () => setState(() {
                          _panelSelected1 = true;
                          _panelSelected2 = false;
                        }),
                    content: FondePadding.all(
                      FondeSpacingValues.lg,
                      child: const FondeText(
                        'Panel A',
                        variant: FondeTextVariant.bodyText,
                      ),
                    ),
                  ),
                  FondePanel(
                    isSelected: _panelSelected2,
                    onTap:
                        () => setState(() {
                          _panelSelected1 = false;
                          _panelSelected2 = true;
                        }),
                    content: FondePadding.all(
                      FondeSpacingValues.lg,
                      child: const FondeText(
                        'Panel B',
                        variant: FondeTextVariant.bodyText,
                      ),
                    ),
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
