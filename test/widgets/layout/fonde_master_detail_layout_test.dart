// Tests for FondeMasterDetailLayout.
//
// Verifies master list rendering, detail rendering, and item selection.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

Widget _buildLayout({
  String? initialSelectedId,
  bool showDetailOnInit = false,
}) {
  return FondeMasterDetailLayout(
    items: const ['item1', 'item2', 'item3'],
    masterItemBuilder: (context, itemId, isSelected, onSelect) {
      return GestureDetector(
        onTap: onSelect,
        child: Container(
          padding: const EdgeInsets.all(8),
          color: isSelected ? Colors.blue.shade100 : Colors.transparent,
          child: Text('Item $itemId'),
        ),
      );
    },
    detailBuilder: (context, selectedId, showMaster) {
      return selectedId != null
          ? Text('Detail: $selectedId')
          : const Text('No selection');
    },
    initialSelectedId: initialSelectedId,
    showDetailOnInit: showDetailOnInit,
  );
}

void main() {
  group('FondeMasterDetailLayout', () {
    group('rendering', () {
      testWidgets('renders without crashing', (tester) async {
        await tester.pumpTestApp(_buildLayout());
        expect(find.byType(FondeMasterDetailLayout), findsOneWidget);
      });

      testWidgets('master list items are displayed', (tester) async {
        await tester.pumpTestApp(_buildLayout());
        expect(find.text('Item item1'), findsOneWidget);
        expect(find.text('Item item2'), findsOneWidget);
        expect(find.text('Item item3'), findsOneWidget);
      });

      testWidgets('no-selection detail is shown by default', (tester) async {
        await tester.pumpTestApp(_buildLayout());
        expect(find.text('No selection'), findsOneWidget);
      });

      testWidgets('initialSelectedId shows detail immediately', (tester) async {
        await tester.pumpTestApp(
          _buildLayout(initialSelectedId: 'item2', showDetailOnInit: true),
        );
        await tester.pumpAndSettle();
        expect(find.text('Detail: item2'), findsOneWidget);
      });
    });

    group('item selection', () {
      testWidgets('tapping a master item shows its detail', (tester) async {
        await tester.pumpTestApp(_buildLayout());
        await tester.tap(find.text('Item item1'));
        await tester.pumpAndSettle();
        expect(find.text('Detail: item1'), findsOneWidget);
      });
    });
  });
}
