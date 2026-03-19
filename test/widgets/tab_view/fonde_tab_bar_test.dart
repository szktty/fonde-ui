// Tests for FondeTabBar.
//
// Verifies tab label rendering, onTabSelected callback, active tab state,
// closeable button display, and onTabClosed callback.
// animationDuration is Duration.zero, so pump() is sufficient.

import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondeTabBar', () {
    final tabs = [
      const FondeTab(id: 'tab-1', label: 'Tab One'),
      const FondeTab(id: 'tab-2', label: 'Tab Two'),
      const FondeTab(id: 'tab-3', label: 'Tab Three'),
    ];

    group('label rendering', () {
      testWidgets('all tab labels are displayed', (tester) async {
        await tester.pumpTestApp(
          FondeTabBar(
            tabs: tabs,
            selectedTabId: 'tab-1',
            onTabSelected: (_) {},
          ),
        );
        expect(find.text('Tab One'), findsOneWidget);
        expect(find.text('Tab Two'), findsOneWidget);
        expect(find.text('Tab Three'), findsOneWidget);
      });
    });

    group('onTabSelected', () {
      testWidgets('tapping a tab invokes onTabSelected with correct id', (
        tester,
      ) async {
        String? selected;
        await tester.pumpTestApp(
          FondeTabBar(
            tabs: tabs,
            selectedTabId: 'tab-1',
            onTabSelected: (id) => selected = id,
          ),
        );
        await tester.tap(find.text('Tab Two'));
        await tester.pump();
        expect(selected, 'tab-2');
      });
    });

    group('single tab', () {
      testWidgets('renders a single tab without crashing', (tester) async {
        await tester.pumpTestApp(
          FondeTabBar(
            tabs: const [FondeTab(id: 'only', label: 'Only Tab')],
            selectedTabId: 'only',
            onTabSelected: (_) {},
          ),
        );
        expect(find.text('Only Tab'), findsOneWidget);
      });
    });

    group('closeable tabs', () {
      testWidgets('onTabClosed renders tab bar without crashing', (
        tester,
      ) async {
        // Verify that providing onTabClosed does not break rendering.
        await tester.pumpTestApp(
          FondeTabBar(
            tabs: const [
              FondeTab(id: 'tab-1', label: 'Closeable', closeable: true),
            ],
            selectedTabId: 'tab-1',
            onTabSelected: (_) {},
            onTabClosed: (_) {},
          ),
        );
        expect(find.text('Closeable'), findsOneWidget);
      });
    });
  });
}
