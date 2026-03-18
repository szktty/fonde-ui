// Tests for FondeTextField.
//
// Verifies hint text, onChanged callback, TextEditingController sync,
// disabled state, and errorText rendering.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondeTextField', () {
    group('hint text', () {
      testWidgets('hintText is visible when field is empty', (tester) async {
        await tester.pumpTestApp(const FondeTextField(hintText: 'Enter text'));
        expect(find.text('Enter text'), findsOneWidget);
      });
    });

    group('onChanged', () {
      testWidgets('typing calls onChanged with the entered text', (
        tester,
      ) async {
        String? received;
        await tester.pumpTestApp(
          FondeTextField(onChanged: (v) => received = v),
        );
        await tester.enterText(find.byType(FondeTextField), 'hello');
        await tester.pump();
        expect(received, 'hello');
      });
    });

    group('TextEditingController', () {
      testWidgets('controller.text matches entered text', (tester) async {
        final controller = TextEditingController();
        addTearDown(controller.dispose);
        await tester.pumpTestApp(FondeTextField(controller: controller));
        await tester.enterText(find.byType(FondeTextField), 'synced');
        await tester.pump();
        expect(controller.text, 'synced');
      });

      testWidgets('field reflects initial controller text', (tester) async {
        final controller = TextEditingController(text: 'initial');
        addTearDown(controller.dispose);
        await tester.pumpTestApp(FondeTextField(controller: controller));
        expect(find.text('initial'), findsOneWidget);
      });
    });

    group('disabled', () {
      testWidgets('renders without crashing when enabled is false', (
        tester,
      ) async {
        await tester.pumpTestApp(
          const FondeTextField(enabled: false, hintText: 'Disabled'),
        );
        expect(find.byType(FondeTextField), findsOneWidget);
      });
    });

    group('errorText', () {
      testWidgets('errorText is displayed', (tester) async {
        await tester.pumpTestApp(
          const FondeTextField(errorText: 'Required field'),
        );
        expect(find.text('Required field'), findsOneWidget);
      });
    });

    group('onSubmitted', () {
      testWidgets('pressing enter calls onSubmitted', (tester) async {
        String? submitted;
        await tester.pumpTestApp(
          FondeTextField(onSubmitted: (v) => submitted = v),
        );
        await tester.enterText(find.byType(FondeTextField), 'submit me');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();
        expect(submitted, 'submit me');
      });
    });
  });
}
