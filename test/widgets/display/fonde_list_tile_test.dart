// Tests for FondeListTile.
//
// Verifies title/subtitle/leading/trailing rendering, selection state, and onTap.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondeListTile', () {
    group('rendering', () {
      testWidgets('title widget is displayed', (tester) async {
        await tester.pumpTestApp(
          FondeListTile(title: const Text('Item'), isSelected: false),
        );
        expect(find.text('Item'), findsOneWidget);
      });

      testWidgets('subtitle is displayed when provided', (tester) async {
        await tester.pumpTestApp(
          FondeListTile(
            title: const Text('Item'),
            subtitle: const Text('Subtitle text'),
            isSelected: false,
          ),
        );
        expect(find.text('Subtitle text'), findsOneWidget);
      });

      testWidgets('leading widget is displayed', (tester) async {
        await tester.pumpTestApp(
          FondeListTile(
            title: const Text('Item'),
            leading: const Icon(Icons.star),
            isSelected: false,
          ),
        );
        expect(find.byIcon(Icons.star), findsOneWidget);
      });

      testWidgets('trailing widget is displayed', (tester) async {
        await tester.pumpTestApp(
          FondeListTile(
            title: const Text('Item'),
            trailing: const Text('Meta'),
            isSelected: false,
          ),
        );
        expect(find.text('Meta'), findsOneWidget);
      });
    });

    group('selection state', () {
      testWidgets('unselected renders without crashing', (tester) async {
        await tester.pumpTestApp(
          FondeListTile(title: const Text('Item'), isSelected: false),
        );
        expect(find.byType(FondeListTile), findsOneWidget);
      });

      testWidgets('selected renders without crashing', (tester) async {
        await tester.pumpTestApp(
          FondeListTile(title: const Text('Item'), isSelected: true),
        );
        expect(find.byType(FondeListTile), findsOneWidget);
      });
    });

    group('onTap', () {
      testWidgets('tapping calls onTap', (tester) async {
        int callCount = 0;
        await tester.pumpTestApp(
          FondeListTile(
            title: const Text('Tappable'),
            isSelected: false,
            onTap: () => callCount++,
          ),
        );
        await tester.tap(find.text('Tappable'));
        await tester.pump();
        expect(callCount, 1);
      });

      testWidgets('no crash when onTap is null', (tester) async {
        await tester.pumpTestApp(
          FondeListTile(title: const Text('NoTap'), isSelected: false),
        );
        await tester.tap(find.text('NoTap'), warnIfMissed: false);
        await tester.pump();
        expect(find.byType(FondeListTile), findsOneWidget);
      });
    });

    group('dense mode', () {
      testWidgets('dense: true renders without crashing', (tester) async {
        await tester.pumpTestApp(
          FondeListTile(
            title: const Text('Dense'),
            isSelected: false,
            dense: true,
          ),
        );
        expect(find.byType(FondeListTile), findsOneWidget);
      });
    });
  });
}
