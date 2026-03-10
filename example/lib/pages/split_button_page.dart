import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class SplitButtonPage extends StatelessWidget {
  const SplitButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Split Button',
          description: 'Main action + dropdown',
          children: [
            CatalogDemo(
              label: 'Basic',
              child: FondeSplitButton(
                primaryLabel: 'Publish',
                onPrimaryPressed: () {},
                actions: [
                  FondeSplitButtonAction(label: 'Save Draft', onPressed: () {}),
                  FondeSplitButtonAction(
                    label: 'Schedule...',
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
