// Tests for FondeScaffold.
//
// FondeScaffold requires FondeApp (ProviderScope + MaterialApp) as ancestor.
// Tests use FondeApp directly rather than buildTestApp.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

void main() {
  group('FondeScaffold', () {
    group('smoke tests', () {
      testWidgets('renders with minimal required parameters', (tester) async {
        await tester.pumpWidget(
          FondeApp(
            title: 'Test',
            home: FondeScaffold(
              toolbar: const Text('Toolbar'),
              content: const Text('Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(FondeScaffold), findsOneWidget);
      });

      testWidgets('content is displayed', (tester) async {
        await tester.pumpWidget(
          FondeApp(
            title: 'Test',
            home: FondeScaffold(
              toolbar: const SizedBox.shrink(),
              content: const Text('Main Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Main Content'), findsOneWidget);
      });

      testWidgets('renders with primarySidebar', (tester) async {
        await tester.pumpWidget(
          FondeApp(
            title: 'Test',
            home: FondeScaffold(
              toolbar: const SizedBox.shrink(),
              content: const SizedBox.shrink(),
              primarySidebar: const Text('Sidebar'),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(FondeScaffold), findsOneWidget);
      });

      testWidgets('renders with showPrimarySidebar: false', (tester) async {
        await tester.pumpWidget(
          FondeApp(
            title: 'Test',
            home: FondeScaffold(
              toolbar: const SizedBox.shrink(),
              content: const Text('Content Hidden Sidebar'),
              showPrimarySidebar: false,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(FondeScaffold), findsOneWidget);
      });
    });
  });
}
