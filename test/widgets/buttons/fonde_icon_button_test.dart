// Tests for FondeIconButton.
//
// Verifies icon rendering, onPressed callback, disabled state, tooltip, and
// that all named constructors render without crashing.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondeIconButton', () {
    group('icon rendering', () {
      testWidgets('icon is displayed', (tester) async {
        await tester.pumpTestApp(
          FondeIconButton(icon: Icons.settings, onPressed: () {}),
        );
        expect(find.byIcon(Icons.settings), findsOneWidget);
      });
    });

    group('onPressed', () {
      testWidgets('tap invokes onPressed exactly once', (tester) async {
        int callCount = 0;
        await tester.pumpTestApp(
          FondeIconButton(icon: Icons.add, onPressed: () => callCount++),
        );
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();
        expect(callCount, 1);
      });
    });

    group('disabled state', () {
      testWidgets('tap does not invoke onPressed when enabled is false', (
        tester,
      ) async {
        int callCount = 0;
        await tester.pumpTestApp(
          FondeIconButton(
            icon: Icons.add,
            onPressed: () => callCount++,
            enabled: false,
          ),
        );
        await tester.tap(find.byIcon(Icons.add), warnIfMissed: false);
        await tester.pump();
        expect(callCount, 0);
      });

      testWidgets('renders without crashing when onPressed is null', (
        tester,
      ) async {
        await tester.pumpTestApp(const FondeIconButton(icon: Icons.close));
        expect(find.byIcon(Icons.close), findsOneWidget);
      });
    });

    group('tooltip', () {
      testWidgets('tooltip is set on the widget tree', (tester) async {
        await tester.pumpTestApp(
          FondeIconButton(
            icon: Icons.info,
            onPressed: () {},
            tooltip: 'More info',
          ),
        );
        expect(find.byTooltip('More info'), findsOneWidget);
      });
    });

    group('named constructors', () {
      testWidgets('FondeIconButton.compact renders without crashing', (
        tester,
      ) async {
        await tester.pumpTestApp(
          FondeIconButton.compact(icon: Icons.menu, onPressed: () {}),
        );
        expect(find.byIcon(Icons.menu), findsOneWidget);
      });

      testWidgets('FondeIconButton.minimal renders without crashing', (
        tester,
      ) async {
        await tester.pumpTestApp(
          FondeIconButton.minimal(icon: Icons.menu, onPressed: () {}),
        );
        expect(find.byIcon(Icons.menu), findsOneWidget);
      });

      testWidgets('FondeIconButton.circle renders without crashing', (
        tester,
      ) async {
        await tester.pumpTestApp(
          FondeIconButton.circle(icon: Icons.close, onPressed: () {}),
        );
        expect(find.byIcon(Icons.close), findsOneWidget);
      });
    });
  });
}
