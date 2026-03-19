// Tests for FondeTagView.
//
// Verifies label rendering, selected/unselected state, and custom color.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondeTagView', () {
    group('label rendering', () {
      testWidgets('label is displayed', (tester) async {
        await tester.pumpTestApp(const FondeTagView(label: 'My Tag'));
        expect(find.text('My Tag'), findsOneWidget);
      });

      testWidgets('renders without crashing with empty label', (tester) async {
        await tester.pumpTestApp(const FondeTagView(label: ''));
        expect(find.byType(FondeTagView), findsOneWidget);
      });
    });

    group('selection state', () {
      testWidgets('unselected state renders without crashing', (tester) async {
        await tester.pumpTestApp(
          const FondeTagView(label: 'Tag', isSelected: false),
        );
        expect(find.byType(FondeTagView), findsOneWidget);
      });

      testWidgets('selected state renders without crashing', (tester) async {
        await tester.pumpTestApp(
          const FondeTagView(label: 'Tag', isSelected: true),
        );
        expect(find.byType(FondeTagView), findsOneWidget);
      });
    });

    group('custom color', () {
      testWidgets('custom color renders without crashing', (tester) async {
        await tester.pumpTestApp(
          const FondeTagView(label: 'Colored Tag', color: Colors.purple),
        );
        expect(find.text('Colored Tag'), findsOneWidget);
      });
    });
  });
}
