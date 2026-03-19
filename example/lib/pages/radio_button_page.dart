import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class RadioButtonPage extends StatefulWidget {
  const RadioButtonPage({super.key});

  @override
  State<RadioButtonPage> createState() => _RadioButtonPageState();
}

class _RadioButtonPageState extends State<RadioButtonPage> {
  String _selected = 'option1';
  String? _selectedNullable;

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Radio Button',
          description: 'Radio Button',
          children: [
            CatalogDemo(
              label: 'Basic',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FondeRadioButton<String>(
                        value: 'option1',
                        groupValue: _selected,
                        onChanged: (v) => setState(() => _selected = v!),
                      ),
                      const SizedBox(width: 8),
                      const Text('Option 1'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FondeRadioButton<String>(
                        value: 'option2',
                        groupValue: _selected,
                        onChanged: (v) => setState(() => _selected = v!),
                      ),
                      const SizedBox(width: 8),
                      const Text('Option 2'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FondeRadioButton<String>(
                        value: 'option3',
                        groupValue: _selected,
                        onChanged: (v) => setState(() => _selected = v!),
                      ),
                      const SizedBox(width: 8),
                      const Text('Option 3'),
                    ],
                  ),
                ],
              ),
            ),
            CatalogDemo(
              label: 'Disabled',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FondeRadioButton<String>(
                        value: 'a',
                        groupValue: 'a',
                        onChanged: null,
                      ),
                      const SizedBox(width: 8),
                      const Text('Selected (disabled)'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FondeRadioButton<String>(
                        value: 'b',
                        groupValue: 'a',
                        onChanged: null,
                      ),
                      const SizedBox(width: 8),
                      const Text('Unselected (disabled)'),
                    ],
                  ),
                ],
              ),
            ),
            CatalogDemo(
              label: 'Nullable group value',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FondeRadioButton<String>(
                        value: 'yes',
                        groupValue: _selectedNullable,
                        onChanged: (v) => setState(() => _selectedNullable = v),
                      ),
                      const SizedBox(width: 8),
                      const Text('Yes'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FondeRadioButton<String>(
                        value: 'no',
                        groupValue: _selectedNullable,
                        onChanged: (v) => setState(() => _selectedNullable = v),
                      ),
                      const SizedBox(width: 8),
                      const Text('No'),
                    ],
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
