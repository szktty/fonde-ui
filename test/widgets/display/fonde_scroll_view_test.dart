// Tests for FondeScrollView.
//
// Verifies child rendering, scroll directions, and scrollbar visibility option.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondeScrollView', () {
    group('rendering', () {
      testWidgets('renders child without crashing', (tester) async {
        await tester.pumpTestApp(
          const FondeScrollView(child: Text('Scrollable Content')),
        );
        expect(find.text('Scrollable Content'), findsOneWidget);
      });

      testWidgets('vertical scroll direction renders without crashing', (
        tester,
      ) async {
        await tester.pumpTestApp(
          const FondeScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(height: 2000, child: Text('Tall Content')),
          ),
        );
        expect(find.byType(FondeScrollView), findsOneWidget);
      });

      testWidgets('horizontal scroll direction renders without crashing', (
        tester,
      ) async {
        await tester.pumpTestApp(
          const FondeScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(width: 2000, child: Text('Wide Content')),
          ),
        );
        expect(find.byType(FondeScrollView), findsOneWidget);
      });

      testWidgets('showScrollbar: false renders without crashing', (
        tester,
      ) async {
        await tester.pumpTestApp(
          const FondeScrollView(
            showScrollbar: false,
            child: Text('No Scrollbar'),
          ),
        );
        expect(find.byType(FondeScrollView), findsOneWidget);
      });

      testWidgets('custom padding renders without crashing', (tester) async {
        await tester.pumpTestApp(
          const FondeScrollView(
            padding: EdgeInsets.all(16.0),
            child: Text('Padded'),
          ),
        );
        expect(find.text('Padded'), findsOneWidget);
      });
    });
  });
}
