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

  // fill style samples
  bool _filled = false;
  bool _outline = false;
  bool _iconOnly = false;

  // shape samples
  bool _rectFilled = false;
  bool _rectOutline = false;
  bool _circleFilled = false;
  bool _circleOutline = false;

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
            CatalogDemo(
              label: 'Fill style',
              child: Wrap(
                spacing: 24,
                runSpacing: 12,
                children: [
                  _LabeledCheckbox(
                    label: 'filled (default)',
                    value: _filled,
                    fillStyle: FondeCheckboxFillStyle.filled,
                    onChanged: (v) => setState(() => _filled = v ?? false),
                  ),
                  _LabeledCheckbox(
                    label: 'outline',
                    value: _outline,
                    fillStyle: FondeCheckboxFillStyle.outline,
                    onChanged: (v) => setState(() => _outline = v ?? false),
                  ),
                  _LabeledCheckbox(
                    label: 'iconOnly',
                    value: _iconOnly,
                    fillStyle: FondeCheckboxFillStyle.iconOnly,
                    onChanged: (v) => setState(() => _iconOnly = v ?? false),
                  ),
                ],
              ),
            ),
            CatalogDemo(
              label: 'Shape',
              child: Wrap(
                spacing: 24,
                runSpacing: 12,
                children: [
                  _LabeledCheckbox(
                    label: 'rectangle / filled',
                    value: _rectFilled,
                    shape: FondeCheckboxShape.rectangle,
                    fillStyle: FondeCheckboxFillStyle.filled,
                    onChanged: (v) => setState(() => _rectFilled = v ?? false),
                  ),
                  _LabeledCheckbox(
                    label: 'rectangle / outline',
                    value: _rectOutline,
                    shape: FondeCheckboxShape.rectangle,
                    fillStyle: FondeCheckboxFillStyle.outline,
                    onChanged: (v) => setState(() => _rectOutline = v ?? false),
                  ),
                  _LabeledCheckbox(
                    label: 'circle / filled',
                    value: _circleFilled,
                    shape: FondeCheckboxShape.circle,
                    fillStyle: FondeCheckboxFillStyle.filled,
                    onChanged:
                        (v) => setState(() => _circleFilled = v ?? false),
                  ),
                  _LabeledCheckbox(
                    label: 'circle / outline',
                    value: _circleOutline,
                    shape: FondeCheckboxShape.circle,
                    fillStyle: FondeCheckboxFillStyle.outline,
                    onChanged:
                        (v) => setState(() => _circleOutline = v ?? false),
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

class _LabeledCheckbox extends StatelessWidget {
  const _LabeledCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
    this.shape = FondeCheckboxShape.rectangle,
    this.fillStyle = FondeCheckboxFillStyle.filled,
  });

  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final FondeCheckboxShape shape;
  final FondeCheckboxFillStyle fillStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FondeCheckbox(
          value: value,
          shape: shape,
          fillStyle: fillStyle,
          onChanged: onChanged,
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
