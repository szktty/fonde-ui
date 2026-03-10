import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class TagsFieldPage extends StatelessWidget {
  const TagsFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Tags Field',
          description: 'Tag input field',
          children: [
            CatalogDemo(
              label: 'Basic',
              child: SizedBox(
                width: 320,
                child: FondeTagsField(
                  initialTags: const ['Flutter', 'Dart'],
                  hintText: 'Add a tag...',
                  onTagsChanged: (_) {},
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
