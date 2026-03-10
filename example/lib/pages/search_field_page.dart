import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class SearchFieldPage extends StatelessWidget {
  const SearchFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Search Field',
          description: 'Search field with suggestions',
          children: [
            CatalogDemo(
              label: 'Basic',
              child: SizedBox(
                width: 320,
                child: FondeSearchField(
                  hint: 'Search...',
                  suggestions: const ['Apple', 'Banana', 'Cherry', 'Date'],
                ),
              ),
            ),
            const CatalogDemo(
              label: 'disabled',
              child: SizedBox(
                width: 320,
                child: FondeSearchField(hint: 'Search...', enabled: false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
