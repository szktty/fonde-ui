// Tests for FondeCheckbox.
//
// Verifies rendering in checked/unchecked/null states, onChanged callback,
// tristate cycle, and disabled (onChanged: null) behaviour.

import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondeCheckbox', () {
    group('rendering', () {
      testWidgets('renders without crashing when value is true', (
        tester,
      ) async {
        await tester.pumpTestApp(FondeCheckbox(value: true, onChanged: (_) {}));
        expect(find.byType(FondeCheckbox), findsOneWidget);
      });

      testWidgets('renders without crashing when value is false', (
        tester,
      ) async {
        await tester.pumpTestApp(
          FondeCheckbox(value: false, onChanged: (_) {}),
        );
        expect(find.byType(FondeCheckbox), findsOneWidget);
      });

      testWidgets('renders without crashing when value is null (tristate)', (
        tester,
      ) async {
        await tester.pumpTestApp(
          FondeCheckbox(value: null, onChanged: (_) {}, tristate: true),
        );
        expect(find.byType(FondeCheckbox), findsOneWidget);
      });
    });

    group('onChanged callback', () {
      testWidgets('tapping unchecked checkbox calls onChanged with true', (
        tester,
      ) async {
        bool? received;
        await tester.pumpTestApp(
          FondeCheckbox(value: false, onChanged: (v) => received = v),
        );
        await tester.tap(find.byType(FondeCheckbox));
        await tester.pump();
        expect(received, true);
      });

      testWidgets('tapping checked checkbox calls onChanged with false', (
        tester,
      ) async {
        bool? received;
        await tester.pumpTestApp(
          FondeCheckbox(value: true, onChanged: (v) => received = v),
        );
        await tester.tap(find.byType(FondeCheckbox));
        await tester.pump();
        expect(received, false);
      });
    });

    group('tristate', () {
      testWidgets('tapping null-state tristate calls onChanged with false', (
        tester,
      ) async {
        // Use a flag to distinguish "never called" from "called with null".
        bool callbackInvoked = false;
        bool? received;
        await tester.pumpTestApp(
          FondeCheckbox(
            value: null,
            onChanged: (v) {
              callbackInvoked = true;
              received = v;
            },
            tristate: true,
          ),
        );
        await tester.tap(find.byType(FondeCheckbox));
        await tester.pump();
        expect(callbackInvoked, true);
        expect(received, false);
      });
    });

    group('disabled', () {
      testWidgets('tap has no effect when onChanged is null', (tester) async {
        // Rendering with onChanged: null should not crash and tap should be
        // silently ignored.
        await tester.pumpTestApp(
          const FondeCheckbox(value: false, onChanged: null),
        );
        await tester.tap(find.byType(FondeCheckbox), warnIfMissed: false);
        await tester.pump();
        // No assertion needed — the test passes if no exception is thrown.
        expect(find.byType(FondeCheckbox), findsOneWidget);
      });
    });
  });
}
