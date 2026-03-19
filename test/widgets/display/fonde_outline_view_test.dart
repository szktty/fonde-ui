// Tests for FondeOutlineView.
//
// Verifies item rendering, empty state, and onItemTap callback.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

// Simple tree node for tests
class _Node {
  final String id;
  final String label;
  final List<_Node> children;
  const _Node(this.id, this.label, {this.children = const []});
}

Widget _buildOutlineView({
  List<_Node>? items,
  _Node? selectedItem,
  void Function(_Node)? onItemTap,
}) {
  final nodes =
      items ??
      [
        _Node('a', 'Alpha', children: [_Node('a1', 'Alpha-1')]),
        _Node('b', 'Beta'),
        _Node('c', 'Gamma'),
      ];

  return FondeOutlineView<_Node>(
    items: nodes,
    itemBuilder:
        (item, isSelected, isExpanded, hasChildren, depth) => Text(item.label),
    childrenBuilder: (item) => item.children,
    selectedItem: selectedItem,
    onItemTap: onItemTap,
  );
}

void main() {
  group('FondeOutlineView', () {
    group('rendering', () {
      testWidgets('renders without crashing', (tester) async {
        await tester.pumpTestApp(_buildOutlineView());
        expect(find.byType(FondeOutlineView<_Node>), findsOneWidget);
      });

      testWidgets('top-level item labels are displayed', (tester) async {
        await tester.pumpTestApp(_buildOutlineView());
        expect(find.text('Alpha'), findsOneWidget);
        expect(find.text('Beta'), findsOneWidget);
        expect(find.text('Gamma'), findsOneWidget);
      });

      testWidgets('emptyBuilder is shown when items list is empty', (
        tester,
      ) async {
        await tester.pumpTestApp(
          FondeOutlineView<_Node>(
            items: const [],
            itemBuilder:
                (item, isSelected, isExpanded, hasChildren, depth) =>
                    Text(item.label),
            childrenBuilder: (item) => item.children,
            emptyBuilder: () => const Text('No items'),
          ),
        );
        expect(find.text('No items'), findsOneWidget);
      });
    });

    group('onItemTap', () {
      testWidgets('tapping an item fires onItemTap with correct item', (
        tester,
      ) async {
        _Node? tapped;
        await tester.pumpTestApp(
          _buildOutlineView(onItemTap: (item) => tapped = item),
        );
        await tester.tap(find.text('Beta'));
        await tester.pump();
        expect(tapped?.id, 'b');
      });
    });
  });
}
