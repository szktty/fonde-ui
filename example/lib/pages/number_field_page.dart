import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class NumberFieldPage extends StatefulWidget {
  const NumberFieldPage({super.key});

  @override
  State<NumberFieldPage> createState() => _NumberFieldPageState();
}

class _NumberFieldPageState extends State<NumberFieldPage> {
  num? _basicValue;
  num? _decimalValue;
  num? _boundedValue = 50;

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Number Field',
          description: 'Numeric input with increment/decrement buttons',
          children: [
            CatalogDemo(
              label: 'Basic',
              child: FondeNumberField(
                initialValue: _basicValue,
                onChanged: (v) => setState(() => _basicValue = v),
              ),
            ),
            CatalogDemo(
              label: 'Decimal',
              description: '2 decimal places, step 0.1',
              child: FondeNumberField(
                initialValue: _decimalValue ?? 1.0,
                decimalPlaces: 2,
                step: 0.1,
                suffix: 'x',
                onChanged: (v) => setState(() => _decimalValue = v),
              ),
            ),
            CatalogDemo(
              label: 'Bounded',
              description: 'Min 0, max 100',
              child: FondeNumberField(
                initialValue: _boundedValue,
                min: 0,
                max: 100,
                suffix: '%',
                onChanged: (v) => setState(() => _boundedValue = v),
              ),
            ),
            const CatalogDemo(
              label: 'Disabled',
              child: FondeNumberField(initialValue: 42, enabled: false),
            ),
          ],
        ),
      ],
    );
  }
}
