// Tests for FondeSearchField.
//
// FondeSearchField wraps the `searchfield` package which uses internal timers.
// Tests are limited to smoke-testing (render without crash) to avoid
// flakiness from pending timers. Interaction tests for text input and clear
// button are deferred until the searchfield dependency can be mocked or
// replaced.

import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondeSearchField', () {
    group('smoke tests', () {
      testWidgets('renders without crashing with default parameters', (
        tester,
      ) async {
        await tester.pumpTestApp(const FondeSearchField());
        expect(find.byType(FondeSearchField), findsOneWidget);
      });

      testWidgets('renders without crashing with hint text', (tester) async {
        await tester.pumpTestApp(const FondeSearchField(hint: 'Search...'));
        expect(find.byType(FondeSearchField), findsOneWidget);
      });

      testWidgets('renders without crashing when disabled', (tester) async {
        await tester.pumpTestApp(const FondeSearchField(enabled: false));
        expect(find.byType(FondeSearchField), findsOneWidget);
      });

      testWidgets('renders without crashing with suggestions', (tester) async {
        await tester.pumpTestApp(
          const FondeSearchField(suggestions: ['Apple', 'Banana', 'Cherry']),
        );
        expect(find.byType(FondeSearchField), findsOneWidget);
      });

      testWidgets('renders without crashing with onClear callback', (
        tester,
      ) async {
        await tester.pumpTestApp(FondeSearchField(onClear: () {}));
        expect(find.byType(FondeSearchField), findsOneWidget);
      });
    });
  });
}
