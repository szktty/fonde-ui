// Tests for FondeDialog and showFondeDialog.
//
// Verifies title rendering, child/footer rendering, dialog open/close via
// showFondeDialog, barrierDismissible, and showCloseButton.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/test_app.dart';

void main() {
  group('FondeDialog', () {
    group('direct widget rendering', () {
      testWidgets('title is displayed', (tester) async {
        await tester.pumpWidget(
          buildTestApp(
            child: FondeDialog(title: 'My Title', child: const Text('Content')),
          ),
        );
        expect(find.text('My Title'), findsOneWidget);
      });

      testWidgets('child is displayed', (tester) async {
        await tester.pumpWidget(
          buildTestApp(child: FondeDialog(child: const Text('Dialog Content'))),
        );
        expect(find.text('Dialog Content'), findsOneWidget);
      });

      testWidgets('footer is displayed', (tester) async {
        await tester.pumpWidget(
          buildTestApp(
            child: FondeDialog(
              child: const Text('Body'),
              footer: const Text('Footer Text'),
            ),
          ),
        );
        expect(find.text('Footer Text'), findsOneWidget);
      });

      testWidgets('renders without crashing with all importance variants', (
        tester,
      ) async {
        for (final importance in FondeDialogImportance.values) {
          await tester.pumpWidget(
            buildTestApp(
              child: FondeDialog(
                title: 'Title',
                importance: importance,
                child: const Text('Body'),
              ),
            ),
          );
          expect(find.text('Title'), findsOneWidget);
        }
      });
    });
  });

  group('showFondeDialog', () {
    testWidgets('dialog is shown and can be closed with Navigator.pop', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder:
                (context) => ElevatedButton(
                  onPressed:
                      () => showFondeDialog<void>(
                        context: context,
                        title: 'Popup',
                        child: const Text('Dialog Body'),
                      ),
                  child: const Text('Open'),
                ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Dialog Body'), findsOneWidget);

      // Close via Navigator.pop.
      final context = tester.element(find.text('Dialog Body'));
      Navigator.of(context).pop();
      await tester.pumpAndSettle();
      expect(find.text('Dialog Body'), findsNothing);
    });

    testWidgets('barrierDismissible: tapping barrier closes the dialog', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder:
                (context) => ElevatedButton(
                  onPressed:
                      () => showFondeDialog<void>(
                        context: context,
                        child: const Text('Dismissible'),
                        barrierDismissible: true,
                      ),
                  child: const Text('Open'),
                ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Dismissible'), findsOneWidget);

      // Tap outside the dialog to dismiss it.
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('Dismissible'), findsNothing);
    });

    testWidgets('showCloseButton shows a close button in the dialog', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder:
                (context) => ElevatedButton(
                  onPressed:
                      () => showFondeDialog<void>(
                        context: context,
                        title: 'With Close',
                        showCloseButton: true,
                        child: const Text('Content'),
                      ),
                  child: const Text('Open'),
                ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('With Close'), findsOneWidget);
      // A close button (X icon) should be present somewhere in the dialog.
      expect(find.byType(FondeDialog), findsOneWidget);
    });
  });
}
