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
  Color _dialogSelected = const Color(0xFF4B6EF5);

  static const _palette = [
    Color(0xFFEF4444),
    Color(0xFFF97316),
    Color(0xFFEAB308),
    Color(0xFF22C55E),
    Color(0xFF3B82F6),
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
    Color(0xFF6B7280),
    Color(0xFFFFFFFF),
    Color(0xFF000000),
  ];

  String _hexOf(Color c) =>
      '#${c.red.toRadixString(16).padLeft(2, '0')}${c.green.toRadixString(16).padLeft(2, '0')}${c.blue.toRadixString(16).padLeft(2, '0')}'
          .toUpperCase();

  Widget _colorSwatch(Color color) => Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade400),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Color Picker',
          description:
              'FondeColorPicker provides an HSV color picker with saturation-value canvas, '
              'hue slider, palette swatches, eyedropper, and hex input.',
          children: [
            CatalogDemo(
              label: 'Inline',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FondeColorPicker(
                    initialColor: _selected,
                    palette: _palette,
                    showEyeDropper: true,
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
                      _colorSwatch(_selected),
                      const SizedBox(height: 8),
                      FondeText(
                        _hexOf(_selected),
                        variant: FondeTextVariant.smallText,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        CatalogSection(
          title: 'Dialog',
          description:
              'showFondeColorPickerDialog opens a color picker in a FondeDialog.',
          children: [
            CatalogDemo(
              label: 'showFondeColorPickerDialog',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _colorSwatch(_dialogSelected),
                  const SizedBox(width: 8),
                  FondeButton.normal(
                    label: 'Choose Color…',
                    onPressed: () async {
                      final result = await showFondeColorPickerDialog(
                        context: context,
                        initialColor: _dialogSelected,
                        palette: _palette,
                        showEyeDropper: true,
                      );
                      if (result != null) {
                        setState(() => _dialogSelected = result);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  FondeText(
                    _hexOf(_dialogSelected),
                    variant: FondeTextVariant.smallText,
                  ),
                ],
              ),
            ),
          ],
        ),
        CatalogSection(
          title: 'Eyedropper',
          description:
              'FondeEyeDropperButton can be used independently to pick any color '
              'from within the Flutter window.',
          children: [
            CatalogDemo(
              label: 'FondeEyeDropperButton',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _colorSwatch(_selected),
                  const SizedBox(width: 12),
                  FondeEyeDropperButton(
                    onColorPicked: (c) => setState(() => _selected = c),
                  ),
                  const SizedBox(width: 8),
                  FondeText(
                    _hexOf(_selected),
                    variant: FondeTextVariant.smallText,
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
