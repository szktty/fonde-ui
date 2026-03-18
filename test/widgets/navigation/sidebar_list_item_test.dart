// Tests for FondeSidebarListItem.
//
// Verifies title rendering, selected/unselected states, onTap callback, and
// leading/trailing widget rendering.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondeSidebarListItem', () {
    group('title', () {
      testWidgets('title text is displayed', (tester) async {
        await tester.pumpTestApp(
          const FondeSidebarListItem(id: '1', title: 'My Item'),
        );
        expect(find.text('My Item'), findsOneWidget);
      });
    });

    group('selected state', () {
      testWidgets('renders without crashing when isSelected is true', (
        tester,
      ) async {
        await tester.pumpTestApp(
          const FondeSidebarListItem(
            id: '1',
            title: 'Selected',
            isSelected: true,
          ),
        );
        expect(find.text('Selected'), findsOneWidget);
      });

      testWidgets('renders without crashing when isSelected is false', (
        tester,
      ) async {
        await tester.pumpTestApp(
          const FondeSidebarListItem(
            id: '1',
            title: 'Not Selected',
            isSelected: false,
          ),
        );
        expect(find.text('Not Selected'), findsOneWidget);
      });
    });

    group('onTap', () {
      testWidgets('tapping invokes onTap exactly once', (tester) async {
        int callCount = 0;
        await tester.pumpTestApp(
          FondeSidebarListItem(
            id: '1',
            title: 'Tappable',
            onTap: () => callCount++,
          ),
        );
        await tester.tap(find.text('Tappable'));
        await tester.pump();
        expect(callCount, 1);
      });

      testWidgets('renders without crashing when onTap is null', (
        tester,
      ) async {
        await tester.pumpTestApp(
          const FondeSidebarListItem(id: '1', title: 'No Tap'),
        );
        expect(find.text('No Tap'), findsOneWidget);
      });
    });

    group('leading and trailing', () {
      testWidgets('leading widget is rendered', (tester) async {
        await tester.pumpTestApp(
          const FondeSidebarListItem(
            id: '1',
            title: 'Item',
            leading: Icon(Icons.folder),
          ),
        );
        expect(find.byIcon(Icons.folder), findsOneWidget);
      });

      testWidgets('trailing widget is rendered', (tester) async {
        await tester.pumpTestApp(
          const FondeSidebarListItem(
            id: '1',
            title: 'Item',
            trailing: Icon(Icons.chevron_right),
          ),
        );
        expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      });
    });
  });
}
