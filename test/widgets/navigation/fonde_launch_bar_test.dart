// Tests for FondeLaunchBar.
//
// Verifies item rendering, selection state, and onTap callback.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondeLaunchBar', () {
    List<FondeLaunchBarItem> _topItems() => [
      FondeLaunchBarItem(
        icon: Icons.home,
        label: 'Home',
        logicalIndex: 0,
        onTap: () {},
      ),
      FondeLaunchBarItem(
        icon: Icons.search,
        label: 'Search',
        logicalIndex: 1,
        onTap: () {},
      ),
    ];

    List<FondeLaunchBarItem> _bottomItems() => [
      FondeLaunchBarItem(
        icon: Icons.settings,
        label: 'Settings',
        logicalIndex: 99,
        onTap: () {},
      ),
    ];

    group('rendering', () {
      testWidgets('renders without crashing', (tester) async {
        await tester.pumpTestApp(
          FondeLaunchBar(topItems: _topItems(), bottomItems: _bottomItems()),
        );
        expect(find.byType(FondeLaunchBar), findsOneWidget);
      });

      testWidgets('top item icons are rendered', (tester) async {
        await tester.pumpTestApp(
          FondeLaunchBar(topItems: _topItems(), bottomItems: const []),
        );
        expect(find.byIcon(Icons.home), findsOneWidget);
        expect(find.byIcon(Icons.search), findsOneWidget);
      });

      testWidgets('bottom item icons are rendered', (tester) async {
        await tester.pumpTestApp(
          FondeLaunchBar(topItems: const [], bottomItems: _bottomItems()),
        );
        expect(find.byIcon(Icons.settings), findsOneWidget);
      });

      testWidgets('renders with selectedIndex without crashing', (
        tester,
      ) async {
        await tester.pumpTestApp(
          FondeLaunchBar(
            topItems: _topItems(),
            bottomItems: _bottomItems(),
            selectedIndex: 0,
          ),
        );
        expect(find.byType(FondeLaunchBar), findsOneWidget);
      });
    });

    group('onTap', () {
      testWidgets('tapping an item calls its onTap', (tester) async {
        int count = 0;
        final items = [
          FondeLaunchBarItem(
            icon: Icons.home,
            label: 'Home',
            logicalIndex: 0,
            onTap: () => count++,
          ),
        ];
        await tester.pumpTestApp(
          FondeLaunchBar(topItems: items, bottomItems: const []),
        );
        await tester.tap(find.byIcon(Icons.home));
        await tester.pump();
        expect(count, 1);
      });

      testWidgets('disabled item does not call onTap', (tester) async {
        int count = 0;
        final items = [
          FondeLaunchBarItem(
            icon: Icons.home,
            label: 'Home',
            logicalIndex: 0,
            enabled: false,
            onTap: () => count++,
          ),
        ];
        await tester.pumpTestApp(
          FondeLaunchBar(topItems: items, bottomItems: const []),
        );
        await tester.tap(find.byIcon(Icons.home), warnIfMissed: false);
        await tester.pump();
        expect(count, 0);
      });
    });
  });
}
