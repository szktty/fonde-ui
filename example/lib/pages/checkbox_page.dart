import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class CheckboxPage extends StatefulWidget {
  const CheckboxPage({super.key});

  @override
  State<CheckboxPage> createState() => _CheckboxPageState();
}

class _CheckboxPageState extends State<CheckboxPage> {
  bool _checkbox1 = false;
  bool? _checkboxTri;

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Checkbox',
          description: 'Checkbox',
          children: [
            CatalogDemo(
              label: 'Basic',
              child: Wrap(
                spacing: 24,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FondeCheckbox(
                        value: _checkbox1,
                        onChanged:
                            (v) => setState(() => _checkbox1 = v ?? false),
                      ),
                      const SizedBox(width: 8),
                      const Text('Checkbox'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FondeCheckbox(value: false, onChanged: null),
                      const SizedBox(width: 8),
                      const Text('disabled'),
                    ],
                  ),
                ],
              ),
            ),
            CatalogDemo(
              label: 'tristate',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FondeCheckbox(
                    value: _checkboxTri,
                    tristate: true,
                    onChanged: (v) => setState(() => _checkboxTri = v),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _checkboxTri == null
                        ? 'indeterminate'
                        : _checkboxTri!
                        ? 'checked'
                        : 'unchecked',
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
