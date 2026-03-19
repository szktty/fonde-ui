// Tests for FondeText.
//
// Verifies text rendering, variant mapping, color, overflow, and maxLines.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondeText', () {
    group('text content', () {
      testWidgets('renders the provided text', (tester) async {
        await tester.pumpTestApp(
          const FondeText('Hello World', variant: FondeTextVariant.bodyText),
        );
        expect(find.text('Hello World'), findsOneWidget);
      });

      testWidgets('renders empty string without crashing', (tester) async {
        await tester.pumpTestApp(
          const FondeText('', variant: FondeTextVariant.bodyText),
        );
        expect(find.byType(FondeText), findsOneWidget);
      });
    });

    group('variant rendering', () {
      // Spot-check a representative set of variants to ensure no crash.
      const variants = [
        FondeTextVariant.pageTitle,
        FondeTextVariant.bodyText,
        FondeTextVariant.captionText,
        FondeTextVariant.smallText,
        FondeTextVariant.buttonLabel,
        FondeTextVariant.codeBlock,
        FondeTextVariant.entityLabelPrimary,
        FondeTextVariant.tableHeader,
      ];

      for (final variant in variants) {
        testWidgets('renders without crashing for variant $variant', (
          tester,
        ) async {
          await tester.pumpTestApp(FondeText('Sample', variant: variant));
          expect(find.byType(FondeText), findsOneWidget);
        });
      }
    });

    group('color', () {
      testWidgets('accepts a custom color without crashing', (tester) async {
        await tester.pumpTestApp(
          const FondeText(
            'Colored',
            variant: FondeTextVariant.bodyText,
            color: Colors.red,
          ),
        );
        expect(find.text('Colored'), findsOneWidget);
      });
    });

    group('maxLines and overflow', () {
      testWidgets('maxLines: 1 with ellipsis overflow does not crash', (
        tester,
      ) async {
        await tester.pumpTestApp(
          const FondeText(
            'This is a very long text that may overflow the available space',
            variant: FondeTextVariant.bodyText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
        expect(find.byType(FondeText), findsOneWidget);
      });
    });

    group('fontWeight override', () {
      testWidgets('bold fontWeight renders without crashing', (tester) async {
        await tester.pumpTestApp(
          const FondeText(
            'Bold text',
            variant: FondeTextVariant.bodyText,
            fontWeight: FontWeight.bold,
          ),
        );
        expect(find.text('Bold text'), findsOneWidget);
      });
    });

    group('textAlign', () {
      testWidgets('center alignment renders without crashing', (tester) async {
        await tester.pumpTestApp(
          const FondeText(
            'Centered',
            variant: FondeTextVariant.bodyText,
            textAlign: TextAlign.center,
          ),
        );
        expect(find.text('Centered'), findsOneWidget);
      });
    });
  });
}
