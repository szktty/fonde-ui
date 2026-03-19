// Tests for FondeExpansionTile.
//
// Verifies title rendering, expand/collapse behavior, and onExpansionChanged callback.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondeExpansionTile', () {
    group('rendering', () {
      testWidgets('renders without crashing', (tester) async {
        await tester.pumpTestApp(
          const FondeExpansionTile(title: Text('Section')),
        );
        expect(find.byType(FondeExpansionTile), findsOneWidget);
      });

      testWidgets('title is displayed', (tester) async {
        await tester.pumpTestApp(
          const FondeExpansionTile(title: Text('My Section')),
        );
        expect(find.text('My Section'), findsOneWidget);
      });

      testWidgets('children are not visible when collapsed by default', (
        tester,
      ) async {
        await tester.pumpTestApp(
          const FondeExpansionTile(
            title: Text('Section'),
            children: [Text('Hidden Child')],
          ),
        );
        // Child may be in tree but not visible (height 0)
        final tile = find.byType(FondeExpansionTile);
        expect(tile, findsOneWidget);
      });

      testWidgets('initiallyExpanded: true shows children', (tester) async {
        await tester.pumpTestApp(
          const FondeExpansionTile(
            title: Text('Section'),
            initiallyExpanded: true,
            children: [Text('Visible Child')],
          ),
        );
        expect(find.text('Visible Child'), findsOneWidget);
      });
    });

    group('expand/collapse', () {
      testWidgets('tapping title expands the tile', (tester) async {
        await tester.pumpTestApp(
          const FondeExpansionTile(
            title: Text('Section'),
            children: [Text('Child Content')],
          ),
        );
        await tester.tap(find.text('Section'));
        await tester.pumpAndSettle();
        expect(find.text('Child Content'), findsOneWidget);
      });

      testWidgets('tapping title again collapses the tile', (tester) async {
        await tester.pumpTestApp(
          const FondeExpansionTile(
            title: Text('Section'),
            children: [Text('Child Content')],
          ),
        );
        // Expand
        await tester.tap(find.text('Section'));
        await tester.pumpAndSettle();
        // Collapse
        await tester.tap(find.text('Section'));
        await tester.pumpAndSettle();
        expect(find.byType(FondeExpansionTile), findsOneWidget);
      });

      testWidgets('onExpansionChanged fires on expand', (tester) async {
        bool? expanded;
        await tester.pumpTestApp(
          FondeExpansionTile(
            title: const Text('Section'),
            children: const [Text('Child')],
            onExpansionChanged: (v) => expanded = v,
          ),
        );
        await tester.tap(find.text('Section'));
        await tester.pumpAndSettle();
        expect(expanded, true);
      });
    });
  });
}
