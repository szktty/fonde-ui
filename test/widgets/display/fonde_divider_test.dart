// Tests for FondeDivider.
//
// Verifies rendering with default and custom parameters.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondeDivider', () {
    group('rendering', () {
      testWidgets('renders without crashing with default parameters', (
        tester,
      ) async {
        await tester.pumpTestApp(const FondeDivider());
        expect(find.byType(FondeDivider), findsOneWidget);
      });

      testWidgets('renders with custom color', (tester) async {
        await tester.pumpTestApp(const FondeDivider(color: Colors.red));
        expect(find.byType(FondeDivider), findsOneWidget);
      });

      testWidgets('renders with indent and endIndent', (tester) async {
        await tester.pumpTestApp(
          const FondeDivider(indent: 16.0, endIndent: 16.0),
        );
        expect(find.byType(FondeDivider), findsOneWidget);
      });
    });
  });
}
