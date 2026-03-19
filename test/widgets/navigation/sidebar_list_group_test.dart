// Tests for FondeSidebarListGroup.
//
// Implementation notes:
// - The header is split into two tap zones:
//   * Chevron icon (left): calls toggleExpansion
//   * Title text (right): calls onTap (selection), NOT toggleExpansion
// - Children are wrapped in SizeTransition + ClipRect. The child Text widget
//   has its own intrinsic size (non-zero), but SizeTransition clips/constrains
//   the visible height. We therefore check the SizeTransition widget's
//   rendered height on screen rather than the child's intrinsic size.
// - The group uses a 100ms animation; pumpAndSettle() is required.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

/// Returns the on-screen height of the [SizeTransition] that wraps the
/// children, measured via the global position of 'Child Item' text.
///
/// SizeTransition clips the child, so when collapsed the text is positioned
/// outside the visible area. We verify expansion by checking whether the
/// text's top edge is visible (within the Scaffold's bounds).
bool _isChildVisible(WidgetTester tester, String childText) {
  // The text widget always exists in the tree (SizeTransition keeps it).
  // Check whether it is scrolled/clipped out by comparing its global rect
  // top edge against the SizeTransition ancestor's bottom edge.
  final childBox =
      tester.renderObject(find.text(childText)) as dynamic; // RenderBox
  final childOffset = (childBox as dynamic).localToGlobal(Offset.zero);
  // SizeTransition clips children from the top. When size is 0, the child
  // is shifted upward and its globalY is negative or equals the parent top.
  // A simple heuristic: if the rendered top Y >= 0 and the widget is in the
  // visible area, consider it visible.
  final sizeTransitionFinder = find.byType(SizeTransition);
  if (sizeTransitionFinder.evaluate().isEmpty) return false;
  final stBox = tester.renderObject(sizeTransitionFinder.first) as dynamic;
  final stSize = (stBox as dynamic).size as Size;
  // If the SizeTransition has non-zero height, children are visible.
  return stSize.height > 1.0;
}

void main() {
  group('FondeSidebarListGroup', () {
    group('initial state', () {
      testWidgets(
        'SizeTransition has zero height when initiallyExpanded is false',
        (tester) async {
          await tester.pumpTestApp(
            const FondeSidebarListGroup(
              id: 'g1',
              title: 'Group',
              children: [FondeSidebarListItem(id: 'c1', title: 'Child Item')],
            ),
          );
          await tester.pumpAndSettle();
          expect(_isChildVisible(tester, 'Child Item'), false);
        },
      );

      testWidgets(
        'SizeTransition has non-zero height when initiallyExpanded is true',
        (tester) async {
          await tester.pumpTestApp(
            const FondeSidebarListGroup(
              id: 'g1',
              title: 'Group',
              initiallyExpanded: true,
              children: [FondeSidebarListItem(id: 'c1', title: 'Child Item')],
            ),
          );
          await tester.pumpAndSettle();
          expect(_isChildVisible(tester, 'Child Item'), true);
        },
      );

      testWidgets('group title is always visible', (tester) async {
        await tester.pumpTestApp(
          const FondeSidebarListGroup(
            id: 'g1',
            title: 'My Group',
            children: [],
          ),
        );
        expect(find.text('My Group'), findsOneWidget);
      });
    });

    group('expand / collapse via chevron icon', () {
      testWidgets('tapping the chevron expands a collapsed group', (
        tester,
      ) async {
        await tester.pumpTestApp(
          const FondeSidebarListGroup(
            id: 'g1',
            title: 'Collapsible',
            children: [FondeSidebarListItem(id: 'c1', title: 'Child')],
          ),
        );
        await tester.pumpAndSettle();
        expect(_isChildVisible(tester, 'Child'), false);

        // Tap the leftmost icon in the group header (the expansion chevron).
        await tester.tap(find.byType(Icon).first);
        await tester.pumpAndSettle();
        expect(_isChildVisible(tester, 'Child'), true);
      });

      testWidgets('tapping the chevron collapses an expanded group', (
        tester,
      ) async {
        await tester.pumpTestApp(
          const FondeSidebarListGroup(
            id: 'g1',
            title: 'Collapsible',
            initiallyExpanded: true,
            children: [FondeSidebarListItem(id: 'c1', title: 'Child')],
          ),
        );
        await tester.pumpAndSettle();
        expect(_isChildVisible(tester, 'Child'), true);

        await tester.tap(find.byType(Icon).first);
        await tester.pumpAndSettle();
        expect(_isChildVisible(tester, 'Child'), false);
      });
    });

    group('onExpansionChanged', () {
      testWidgets('called with true when chevron expands the group', (
        tester,
      ) async {
        bool? received;
        await tester.pumpTestApp(
          FondeSidebarListGroup(
            id: 'g1',
            title: 'Group',
            onExpansionChanged: (v) => received = v,
            children: const [FondeSidebarListItem(id: 'c1', title: 'Child')],
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byType(Icon).first);
        await tester.pumpAndSettle();
        expect(received, true);
      });

      testWidgets('called with false when chevron collapses the group', (
        tester,
      ) async {
        bool? received;
        await tester.pumpTestApp(
          FondeSidebarListGroup(
            id: 'g1',
            title: 'Expandable Group',
            initiallyExpanded: true,
            onExpansionChanged: (v) => received = v,
            children: const [FondeSidebarListItem(id: 'c1', title: 'Child')],
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byType(Icon).first);
        await tester.pumpAndSettle();
        expect(received, false);
      });
    });

    group('onTap (selection)', () {
      testWidgets('tapping the title calls onTap', (tester) async {
        int callCount = 0;
        await tester.pumpTestApp(
          FondeSidebarListGroup(
            id: 'g1',
            title: 'Selectable',
            onTap: () => callCount++,
            children: const [],
          ),
        );
        await tester.tap(find.text('Selectable'));
        await tester.pump();
        expect(callCount, 1);
      });
    });
  });
}
