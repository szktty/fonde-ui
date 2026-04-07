import 'package:flutter/material.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class TextFieldPage extends StatelessWidget {
  const TextFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Text Field',
          description: 'Text input field',
          children: [
            const CatalogDemo(
              label: 'Basic',
              child: SizedBox(
                width: 320,
                child: FondeTextField(hintText: 'Placeholder'),
              ),
            ),
            const CatalogDemo(
              label: 'disabled',
              child: SizedBox(
                width: 320,
                child: FondeTextField(hintText: 'disabled', enabled: false),
              ),
            ),
            const CatalogDemo(
              label: 'readonly',
              child: SizedBox(
                width: 320,
                child: FondeTextField(hintText: 'Read only', readOnly: true),
              ),
            ),
            const CatalogDemo(
              label: 'Error state',
              child: SizedBox(
                width: 320,
                child: FondeTextField(
                  hintText: 'Enter a value',
                  errorText: 'This field is required',
                ),
              ),
            ),
            const CatalogDemo(
              label: 'Tab focus (3 fields)',
              child: SizedBox(width: 320, child: _TabFocusDemo()),
            ),
          ],
        ),
      ],
    );
  }
}

class _TabFocusDemo extends StatelessWidget {
  const _TabFocusDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: const [
        FondeTextField(hintText: 'Field 1'),
        SizedBox(height: 8),
        FondeTextField(hintText: 'Field 2'),
        SizedBox(height: 8),
        FondeTextField(hintText: 'Field 3'),
      ],
    );
  }
}
