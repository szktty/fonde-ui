// Tests for FondeButton.
//
// Verifies label rendering, onPressed callback, disabled state, and that all
// named constructors render without crashing.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondeButton', () {
    group('label rendering', () {
      testWidgets('label is displayed', (tester) async {
        await tester.pumpTestApp(
          FondeButton.normal(label: 'Click Me', onPressed: () {}),
        );
        expect(find.text('Click Me'), findsOneWidget);
      });
    });

    group('onPressed', () {
      testWidgets('tap invokes onPressed exactly once', (tester) async {
        int callCount = 0;
        await tester.pumpTestApp(
          FondeButton.normal(label: 'Tap', onPressed: () => callCount++),
        );
        await tester.tap(find.text('Tap'));
        await tester.pump();
        expect(callCount, 1);
      });

      testWidgets('multiple taps invoke onPressed multiple times', (
        tester,
      ) async {
        int callCount = 0;
        await tester.pumpTestApp(
          FondeButton.normal(label: 'Tap', onPressed: () => callCount++),
        );
        await tester.tap(find.text('Tap'));
        await tester.tap(find.text('Tap'));
        await tester.pump();
        expect(callCount, 2);
      });
    });

    group('disabled state', () {
      testWidgets('tap does not invoke onPressed when enabled is false', (
        tester,
      ) async {
        int callCount = 0;
        await tester.pumpTestApp(
          FondeButton.normal(
            label: 'Disabled',
            onPressed: () => callCount++,
            enabled: false,
          ),
        );
        await tester.tap(find.text('Disabled'), warnIfMissed: false);
        await tester.pump();
        expect(callCount, 0);
      });

      testWidgets('renders without crashing when onPressed is null', (
        tester,
      ) async {
        await tester.pumpTestApp(const FondeButton.normal(label: 'No Op'));
        expect(find.text('No Op'), findsOneWidget);
      });
    });

    group('named constructors', () {
      testWidgets('FondeButton.primary renders without crashing', (
        tester,
      ) async {
        await tester.pumpTestApp(
          FondeButton.primary(label: 'Primary', onPressed: () {}),
        );
        expect(find.text('Primary'), findsOneWidget);
      });

      testWidgets('FondeButton.cancel renders without crashing', (
        tester,
      ) async {
        await tester.pumpTestApp(
          FondeButton.cancel(label: 'Cancel', onPressed: () {}),
        );
        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('FondeButton.destructive renders without crashing', (
        tester,
      ) async {
        await tester.pumpTestApp(
          FondeButton.destructive(label: 'Delete', onPressed: () {}),
        );
        expect(find.text('Delete'), findsOneWidget);
      });
    });

    group('leading and trailing icons', () {
      testWidgets('leadingIcon is rendered', (tester) async {
        await tester.pumpTestApp(
          FondeButton.normal(
            label: 'With Icon',
            onPressed: () {},
            leadingIcon: const Icon(Icons.add),
          ),
        );
        expect(find.byIcon(Icons.add), findsOneWidget);
      });
    });
  });
}
