import 'package:flutter/material.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class TooltipPage extends StatelessWidget {
  const TooltipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Tooltip (Enhanced)',
          description:
              'FondeTooltip supports title, optional description, and keyboard shortcut badge. '
              'Hover over the buttons to see them.',
          children: [
            const CatalogDemo(
              label: 'Title only',
              child: FondeTooltip(
                title: 'Save file',
                child: _DemoButton(label: 'Hover me'),
              ),
            ),
            const CatalogDemo(
              label: 'Title + shortcut',
              child: FondeTooltip(
                title: 'Save',
                shortcut: '⌘S',
                child: _DemoButton(label: 'Save'),
              ),
            ),
            const CatalogDemo(
              label: 'Title + description + shortcut',
              child: FondeTooltip(
                title: 'Format Document',
                description:
                    'Applies automatic code formatting to the entire document.',
                shortcut: '⌘⇧F',
                child: _DemoButton(label: 'Format'),
              ),
            ),
            const CatalogDemo(
              label: 'On icon button',
              child: FondeTooltip(
                title: 'New File',
                shortcut: '⌘N',
                child: FondeIconButton(
                  icon: LucideIcons.filePlus,
                  onPressed: null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DemoButton extends StatelessWidget {
  const _DemoButton({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return FondeButton.normal(label: label, onPressed: () {});
  }
}
