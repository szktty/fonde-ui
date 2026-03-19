// Tests for FondeLinearProgressIndicator and FondeCircularProgressIndicator.
//
// Verifies rendering in determinate, indeterminate, and cancelled states.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondeLinearProgressIndicator', () {
    group('rendering', () {
      testWidgets('renders without crashing with default parameters', (
        tester,
      ) async {
        await tester.pumpTestApp(const FondeLinearProgressIndicator());
        expect(find.byType(FondeLinearProgressIndicator), findsOneWidget);
      });

      testWidgets('determinate: renders with value 0.0', (tester) async {
        await tester.pumpTestApp(
          const FondeLinearProgressIndicator(value: 0.0),
        );
        expect(find.byType(FondeLinearProgressIndicator), findsOneWidget);
      });

      testWidgets('determinate: renders with value 0.5', (tester) async {
        await tester.pumpTestApp(
          const FondeLinearProgressIndicator(value: 0.5),
        );
        expect(find.byType(FondeLinearProgressIndicator), findsOneWidget);
      });

      testWidgets('determinate: renders with value 1.0', (tester) async {
        await tester.pumpTestApp(
          const FondeLinearProgressIndicator(value: 1.0),
        );
        expect(find.byType(FondeLinearProgressIndicator), findsOneWidget);
      });

      testWidgets(
        'indeterminate: renders without crashing when value is null',
        (tester) async {
          await tester.pumpTestApp(
            const FondeLinearProgressIndicator(value: null),
          );
          expect(find.byType(FondeLinearProgressIndicator), findsOneWidget);
        },
      );

      testWidgets('cancelled state renders without crashing', (tester) async {
        await tester.pumpTestApp(
          const FondeLinearProgressIndicator(value: 0.5, isCancelled: true),
        );
        expect(find.byType(FondeLinearProgressIndicator), findsOneWidget);
      });
    });

    group('custom appearance', () {
      testWidgets('custom color renders without crashing', (tester) async {
        await tester.pumpTestApp(
          const FondeLinearProgressIndicator(value: 0.7, color: Colors.green),
        );
        expect(find.byType(FondeLinearProgressIndicator), findsOneWidget);
      });

      testWidgets('custom backgroundColor renders without crashing', (
        tester,
      ) async {
        await tester.pumpTestApp(
          const FondeLinearProgressIndicator(
            value: 0.3,
            backgroundColor: Colors.grey,
          ),
        );
        expect(find.byType(FondeLinearProgressIndicator), findsOneWidget);
      });

      testWidgets('custom height renders without crashing', (tester) async {
        await tester.pumpTestApp(
          const FondeLinearProgressIndicator(value: 0.5, height: 8.0),
        );
        expect(find.byType(FondeLinearProgressIndicator), findsOneWidget);
      });
    });
  });

  group('FondeCircularProgressIndicator', () {
    group('rendering', () {
      testWidgets('renders without crashing with default parameters', (
        tester,
      ) async {
        await tester.pumpTestApp(const FondeCircularProgressIndicator());
        expect(find.byType(FondeCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('determinate: renders with value 0.5', (tester) async {
        await tester.pumpTestApp(
          const FondeCircularProgressIndicator(value: 0.5),
        );
        expect(find.byType(FondeCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('indeterminate: renders when value is null', (tester) async {
        await tester.pumpTestApp(
          const FondeCircularProgressIndicator(value: null),
        );
        expect(find.byType(FondeCircularProgressIndicator), findsOneWidget);
      });
    });

    group('custom appearance', () {
      testWidgets('custom color renders without crashing', (tester) async {
        await tester.pumpTestApp(
          const FondeCircularProgressIndicator(value: 0.5, color: Colors.blue),
        );
        expect(find.byType(FondeCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('custom size renders without crashing', (tester) async {
        await tester.pumpTestApp(
          const FondeCircularProgressIndicator(value: 0.5, size: 40.0),
        );
        expect(find.byType(FondeCircularProgressIndicator), findsOneWidget);
      });

      testWidgets('custom strokeWidth renders without crashing', (
        tester,
      ) async {
        await tester.pumpTestApp(
          const FondeCircularProgressIndicator(value: 0.5, strokeWidth: 4.0),
        );
        expect(find.byType(FondeCircularProgressIndicator), findsOneWidget);
      });
    });
  });
}
