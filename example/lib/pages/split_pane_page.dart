import 'package:flutter/material.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class SplitPanePage extends StatelessWidget {
  const SplitPanePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Split Pane',
          description:
              'FondeSplitPane provides resizable horizontal or vertical splits inside content areas. '
              'Drag the divider to resize.',
          children: [
            CatalogDemo(
              label: 'Horizontal (2 panes)',
              child: SizedBox(
                height: 180,
                child: FondeSplitPane(
                  axis: Axis.horizontal,
                  children: [
                    _PaneBox(label: 'Left Pane'),
                    _PaneBox(label: 'Right Pane'),
                  ],
                ),
              ),
            ),
            CatalogDemo(
              label: 'Vertical (2 panes)',
              child: SizedBox(
                height: 200,
                child: FondeSplitPane(
                  axis: Axis.vertical,
                  initialSizes: [0.4, 0.6],
                  children: [
                    _PaneBox(label: 'Top Pane'),
                    _PaneBox(label: 'Bottom Pane'),
                  ],
                ),
              ),
            ),
            CatalogDemo(
              label: 'Horizontal (3 panes)',
              child: SizedBox(
                height: 160,
                child: FondeSplitPane(
                  axis: Axis.horizontal,
                  children: [
                    _PaneBox(label: 'Pane 1'),
                    _PaneBox(label: 'Pane 2'),
                    _PaneBox(label: 'Pane 3'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PaneBox extends StatelessWidget {
  const _PaneBox({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withValues(alpha: 0.06),
      child: Center(
        child: FondeText(label, variant: FondeTextVariant.captionText),
      ),
    );
  }
}
