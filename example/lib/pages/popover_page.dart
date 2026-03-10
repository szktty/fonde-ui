import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class PopoverPage extends StatelessWidget {
  const PopoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Popover',
          description: 'Popover display',
          children: [
            CatalogDemo(
              label: 'Basic',
              child: Builder(
                builder:
                    (ctx) => FondeButton.normal(
                      label: 'Show Popover',
                      onPressed:
                          () => FondePopover.show(
                            context: ctx,
                            bodyBuilder:
                                (context) => const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text('Popover content.'),
                                ),
                          ),
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
