import 'package:flutter/material.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

const _suggestions = ['Apple', 'Banana', 'Cherry', 'Date'];

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
                  suggestionOverlayBuilder: (context, controller, close) {
                    final query = controller.text.toLowerCase();
                    final filtered =
                        query.isEmpty
                            ? _suggestions
                            : _suggestions
                                .where((s) => s.toLowerCase().contains(query))
                                .toList();
                    if (filtered.isEmpty) return null;
                    return Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(6),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 320,
                          maxHeight: 200,
                        ),
                        child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          shrinkWrap: true,
                          children: [
                            for (final s in filtered)
                              InkWell(
                                onTap: () {
                                  controller.text = s;
                                  controller.selection =
                                      TextSelection.collapsed(offset: s.length);
                                  close();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Text(s),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
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
