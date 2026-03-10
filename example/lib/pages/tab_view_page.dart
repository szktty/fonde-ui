import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../widgets/catalog_page.dart';

class TabViewPage extends StatelessWidget {
  const TabViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Tab View',
          description: 'Tab switching view',
          children: [
            CatalogDemo(
              label: 'Basic (3 tabs)',
              child: SizedBox(
                height: 200,
                child: FondeTabView(
                  tabs: const [
                    FondeTab(id: 'tab1', label: 'Files'),
                    FondeTab(id: 'tab2', label: 'Edit'),
                    FondeTab(id: 'tab3', label: 'View'),
                  ],
                  contents: [
                    FondeTabContent(
                      id: 'tab1',
                      content: const Center(child: Text('Files tab content')),
                    ),
                    FondeTabContent(
                      id: 'tab2',
                      content: const Center(child: Text('Edit tab content')),
                    ),
                    FondeTabContent(
                      id: 'tab3',
                      content: const Center(child: Text('View tab content')),
                    ),
                  ],
                ),
              ),
            ),
            CatalogDemo(
              label: 'With icons',
              child: SizedBox(
                height: 200,
                child: FondeTabView(
                  tabs: const [
                    FondeTab(
                      id: 'tab_a',
                      label: 'Code',
                      icon: LucideIcons.code,
                    ),
                    FondeTab(
                      id: 'tab_b',
                      label: 'Preview',
                      icon: LucideIcons.eye,
                    ),
                  ],
                  contents: [
                    FondeTabContent(
                      id: 'tab_a',
                      content: const Center(child: Text('Code view')),
                    ),
                    FondeTabContent(
                      id: 'tab_b',
                      content: const Center(child: Text('Preview view')),
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
