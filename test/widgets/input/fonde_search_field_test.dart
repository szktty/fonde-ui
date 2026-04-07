// Tests for FondeSearchField.
//
// Tests are limited to smoke-testing (render without crash).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondeSearchField', () {
    group('smoke tests', () {
      testWidgets('renders without crashing with default parameters', (
        tester,
      ) async {
        await tester.pumpTestApp(const FondeSearchField());
        expect(find.byType(FondeSearchField), findsOneWidget);
      });

      testWidgets('renders without crashing with hint text', (tester) async {
        await tester.pumpTestApp(const FondeSearchField(hint: 'Search...'));
        expect(find.byType(FondeSearchField), findsOneWidget);
      });

      testWidgets('renders without crashing when disabled', (tester) async {
        await tester.pumpTestApp(const FondeSearchField(enabled: false));
        expect(find.byType(FondeSearchField), findsOneWidget);
      });

      testWidgets('renders without crashing with suggestionOverlayBuilder', (
        tester,
      ) async {
        await tester.pumpTestApp(
          FondeSearchField(
            suggestionOverlayBuilder:
                (context, controller, close) => const SizedBox(),
          ),
        );
        expect(find.byType(FondeSearchField), findsOneWidget);
      });

      testWidgets('renders without crashing with onClear callback', (
        tester,
      ) async {
        await tester.pumpTestApp(FondeSearchField(onClear: () {}));
        expect(find.byType(FondeSearchField), findsOneWidget);
      });
    });
  });
}
