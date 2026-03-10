import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class SelectionDecoratorPage extends StatefulWidget {
  const SelectionDecoratorPage({super.key});

  @override
  State<SelectionDecoratorPage> createState() => _SelectionDecoratorPageState();
}

class _SelectionDecoratorPageState extends State<SelectionDecoratorPage> {
  bool _selectable1 = false;
  bool _selectable2 = true;

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Selection Decorator',
          description: 'Highlight for selected state',
          children: [
            CatalogDemo(
              label: 'Unselected / Selected',
              child: Wrap(
                spacing: FondeSpacingValues.md,
                children: [
                  FondeGestureDetector(
                    onTap: () => setState(() => _selectable1 = !_selectable1),
                    cursor: SystemMouseCursors.click,
                    child: FondeSelectionDecorator(
                      isSelected: _selectable1,
                      child: FondePadding.all(
                        FondeSpacingValues.lg,
                        child: SizedBox(
                          width: 100,
                          child: FondeText(
                            _selectable1 ? 'Selected' : 'Unselected',
                            variant: FondeTextVariant.bodyText,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  FondeGestureDetector(
                    onTap: () => setState(() => _selectable2 = !_selectable2),
                    cursor: SystemMouseCursors.click,
                    child: FondeSelectionDecorator(
                      isSelected: _selectable2,
                      child: FondePadding.all(
                        FondeSpacingValues.lg,
                        child: SizedBox(
                          width: 100,
                          child: FondeText(
                            _selectable2 ? 'Selected' : 'Unselected',
                            variant: FondeTextVariant.bodyText,
                            textAlign: TextAlign.center,
                          ),
                        ),
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
