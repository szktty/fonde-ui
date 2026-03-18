// Tests for FondePanel.
//
// Verifies content/header/footer rendering and custom appearance.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondePanel', () {
    group('content rendering', () {
      testWidgets('content is displayed', (tester) async {
        await tester.pumpTestApp(
          FondePanel(content: const Text('Panel Content')),
        );
        expect(find.text('Panel Content'), findsOneWidget);
      });

      testWidgets('header is displayed when provided', (tester) async {
        await tester.pumpTestApp(
          FondePanel(
            header: const Text('Panel Header'),
            content: const Text('Content'),
          ),
        );
        expect(find.text('Panel Header'), findsOneWidget);
      });

      testWidgets('footer is displayed when provided', (tester) async {
        await tester.pumpTestApp(
          FondePanel(
            content: const Text('Content'),
            footer: const Text('Panel Footer'),
          ),
        );
        expect(find.text('Panel Footer'), findsOneWidget);
      });

      testWidgets('renders with all sections simultaneously', (tester) async {
        await tester.pumpTestApp(
          FondePanel(
            header: const Text('Header'),
            content: const Text('Body'),
            footer: const Text('Footer'),
          ),
        );
        expect(find.text('Header'), findsOneWidget);
        expect(find.text('Body'), findsOneWidget);
        expect(find.text('Footer'), findsOneWidget);
      });
    });

    group('custom appearance', () {
      testWidgets('custom backgroundColor renders without crashing', (
        tester,
      ) async {
        await tester.pumpTestApp(
          FondePanel(
            backgroundColor: Colors.blue.shade100,
            content: const Text('Colored Panel'),
          ),
        );
        expect(find.byType(FondePanel), findsOneWidget);
      });

      testWidgets('custom cornerRadius renders without crashing', (
        tester,
      ) async {
        await tester.pumpTestApp(
          FondePanel(cornerRadius: 12.0, content: const Text('Rounded Panel')),
        );
        expect(find.byType(FondePanel), findsOneWidget);
      });

      testWidgets('custom width and height render without crashing', (
        tester,
      ) async {
        await tester.pumpTestApp(
          FondePanel(
            width: 200.0,
            height: 100.0,
            content: const Text('Sized Panel'),
          ),
        );
        expect(find.byType(FondePanel), findsOneWidget);
      });
    });
  });
}
