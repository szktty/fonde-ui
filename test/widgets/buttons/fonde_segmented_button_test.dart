// Tests for FondeSegmentedButton.
//
// Verifies segment rendering, selection state, and onSelectionChanged callback.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondeSegmentedButton', () {
    List<ButtonSegment<String>> _segments() => const [
      ButtonSegment(value: 'a', label: Text('Alpha')),
      ButtonSegment(value: 'b', label: Text('Beta')),
      ButtonSegment(value: 'c', label: Text('Gamma')),
    ];

    group('rendering', () {
      testWidgets('renders without crashing', (tester) async {
        await tester.pumpTestApp(
          FondeSegmentedButton<String>(
            segments: _segments(),
            selected: const {'a'},
            onSelectionChanged: (_) {},
          ),
        );
        expect(find.byType(FondeSegmentedButton<String>), findsOneWidget);
      });

      testWidgets('all segment labels are visible', (tester) async {
        await tester.pumpTestApp(
          FondeSegmentedButton<String>(
            segments: _segments(),
            selected: const {'a'},
            onSelectionChanged: (_) {},
          ),
        );
        expect(find.text('Alpha'), findsOneWidget);
        expect(find.text('Beta'), findsOneWidget);
        expect(find.text('Gamma'), findsOneWidget);
      });
    });

    group('selection', () {
      testWidgets(
        'onSelectionChanged fires when tapping an unselected segment',
        (tester) async {
          Set<String>? received;
          await tester.pumpTestApp(
            FondeSegmentedButton<String>(
              segments: _segments(),
              selected: const {'a'},
              onSelectionChanged: (s) => received = s,
            ),
          );
          await tester.tap(find.text('Beta'));
          await tester.pump();
          expect(received, isNotNull);
        },
      );

      testWidgets('single item can be pre-selected', (tester) async {
        await tester.pumpTestApp(
          FondeSegmentedButton<String>(
            segments: _segments(),
            selected: const {'b'},
            onSelectionChanged: (_) {},
          ),
        );
        expect(find.byType(FondeSegmentedButton<String>), findsOneWidget);
      });
    });
  });
}
