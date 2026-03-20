import 'package:flutter/material.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({super.key});

  @override
  State<ColorPickerPage> createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  Color _selected = const Color(0xFF4B6EF5);
  Color _selectedAlpha = const Color(0xFF4B6EF5);

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Color Picker',
          description:
              'FondeColorPicker provides an HSV color picker with saturation-value canvas, '
              'hue slider, optional alpha slider, and hex input.',
          children: [
            CatalogDemo(
              label: 'Inline picker',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FondeColorPicker(
                    initialColor: _selected,
                    onColorChanged: (c) => setState(() => _selected = c),
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FondeText(
                        'Selected color',
                        variant: FondeTextVariant.captionText,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: _selected,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FondeText(
                        '#${_selected.red.toRadixString(16).padLeft(2, '0')}${_selected.green.toRadixString(16).padLeft(2, '0')}${_selected.blue.toRadixString(16).padLeft(2, '0')}'
                            .toUpperCase(),
                        variant: FondeTextVariant.smallText,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CatalogDemo(
              label: 'With alpha channel',
              child: FondeColorPicker(
                initialColor: _selectedAlpha,
                showAlpha: true,
                onColorChanged: (c) => setState(() => _selectedAlpha = c),
              ),
            ),
            CatalogDemo(
              label: 'Dialog (showFondeColorPickerDialog)',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _selected,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FondeButton.normal(
                    label: 'Choose Color…',
                    onPressed: () async {
                      final result = await showFondeColorPickerDialog(
                        context: context,
                        initialColor: _selected,
                      );
                      if (result != null) {
                        setState(() => _selected = result);
                      }
                    },
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
