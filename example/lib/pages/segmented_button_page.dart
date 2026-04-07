import 'package:flutter/material.dart' show ButtonSegment;
import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class SegmentedButtonPage extends StatefulWidget {
  const SegmentedButtonPage({super.key});

  @override
  State<SegmentedButtonPage> createState() => _SegmentedButtonPageState();
}

class _SegmentedButtonPageState extends State<SegmentedButtonPage> {
  Set<String> _selected = {'a'};

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Segmented Button',
          description: 'Switching between multiple options',
          children: [
            CatalogDemo(
              label: '3 segments',
              child: FondeSegmentedButton<String>(
                selected: _selected,
                onSelectionChanged: (v) => setState(() => _selected = v),
                segments: const [
                  ButtonSegment(value: 'a', label: Text('Day')),
                  ButtonSegment(value: 'b', label: Text('Week')),
                  ButtonSegment(value: 'c', label: Text('Month')),
                ],
              ),
            ),
            CatalogDemo(
              label: 'With icons',
              child: FondeSegmentedButton<String>(
                selected: _selected,
                onSelectionChanged: (v) => setState(() => _selected = v),
                segments: const [
                  ButtonSegment(
                    value: 'a',
                    label: Text('List'),
                    icon: Icon(LucideIcons.list),
                  ),
                  ButtonSegment(
                    value: 'b',
                    label: Text('Grid'),
                    icon: Icon(LucideIcons.layoutGrid),
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
