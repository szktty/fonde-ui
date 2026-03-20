import 'package:flutter/material.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class SliderPage extends StatefulWidget {
  const SliderPage({super.key});

  @override
  State<SliderPage> createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  double _basic = 0.4;
  double _stepped = 3.0;
  double _labeled = 60.0;
  RangeValues _range = const RangeValues(20, 70);

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Slider',
          description:
              'Theme-aware slider applying the active accent color. '
              'Also available as FondeRangeSlider for range selection.',
          children: [
            CatalogDemo(
              label: 'Basic (${(_basic * 100).round()}%)',
              child: FondeSlider(
                value: _basic,
                onChanged: (v) => setState(() => _basic = v),
              ),
            ),
            CatalogDemo(
              label: 'Stepped — ${_stepped.round()} / 10',
              child: FondeSlider(
                value: _stepped,
                min: 0,
                max: 10,
                divisions: 10,
                label: _stepped.round().toString(),
                onChanged: (v) => setState(() => _stepped = v),
              ),
            ),
            CatalogDemo(
              label: 'With suffix label (${_labeled.round()} px)',
              child: FondeSlider(
                value: _labeled,
                min: 0,
                max: 200,
                onChanged: (v) => setState(() => _labeled = v),
              ),
            ),
            const CatalogDemo(
              label: 'Disabled',
              child: FondeSlider(value: 0.6, onChanged: null, enabled: false),
            ),
            CatalogDemo(
              label:
                  'Range Slider (${_range.start.round()} – ${_range.end.round()})',
              child: FondeRangeSlider(
                values: _range,
                min: 0,
                max: 100,
                labels: RangeLabels(
                  _range.start.round().toString(),
                  _range.end.round().toString(),
                ),
                onChanged: (v) => setState(() => _range = v),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
