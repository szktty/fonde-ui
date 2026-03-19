// Tests for FondeToast and FondeSnackBar.
//
// Both are static utility classes. Tests verify they can be called without
// crashing inside a valid widget context.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondeSnackBar', () {
    group('show', () {
      testWidgets('show() displays a snack bar message', (tester) async {
        await tester.pumpTestApp(
          Builder(
            builder: (context) {
              return FondeButton.normal(
                label: 'Show',
                onPressed: () {
                  FondeSnackBar.show(context: context, message: 'Hello!');
                },
              );
            },
          ),
        );
        await tester.tap(find.text('Show'));
        await tester.pump();
        expect(find.text('Hello!'), findsOneWidget);
      });

      testWidgets('showSuccess() displays a success message', (tester) async {
        await tester.pumpTestApp(
          Builder(
            builder: (context) {
              return FondeButton.normal(
                label: 'Show',
                onPressed: () {
                  FondeSnackBar.showSuccess(context: context, message: 'Done!');
                },
              );
            },
          ),
        );
        await tester.tap(find.text('Show'));
        await tester.pump();
        expect(find.text('Done!'), findsOneWidget);
      });

      testWidgets('showError() displays an error message', (tester) async {
        await tester.pumpTestApp(
          Builder(
            builder: (context) {
              return FondeButton.normal(
                label: 'Show',
                onPressed: () {
                  FondeSnackBar.showError(context: context, message: 'Error!');
                },
              );
            },
          ),
        );
        await tester.tap(find.text('Show'));
        await tester.pump();
        expect(find.text('Error!'), findsOneWidget);
      });
    });
  });
}
