// Tests for FondeIcon.
//
// Verifies icon rendering with various sizes, colors, and configurations.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../../helpers/pump_helpers.dart';

void main() {
  group('FondeIcon', () {
    group('rendering', () {
      testWidgets('renders without crashing with default size', (tester) async {
        await tester.pumpTestApp(const FondeIcon(Icons.star));
        expect(find.byType(FondeIcon), findsOneWidget);
      });

      testWidgets('renders with small preset size', (tester) async {
        await tester.pumpTestApp(
          const FondeIcon(Icons.star, size: FondeIconSize.small),
        );
        expect(find.byType(FondeIcon), findsOneWidget);
      });

      testWidgets('renders with large preset size', (tester) async {
        await tester.pumpTestApp(
          const FondeIcon(Icons.star, size: FondeIconSize.large),
        );
        expect(find.byType(FondeIcon), findsOneWidget);
      });

      testWidgets('renders with xlarge preset size', (tester) async {
        await tester.pumpTestApp(
          const FondeIcon(Icons.star, size: FondeIconSize.xlarge),
        );
        expect(find.byType(FondeIcon), findsOneWidget);
      });

      testWidgets('renders with customSize', (tester) async {
        await tester.pumpTestApp(const FondeIcon(Icons.star, customSize: 28.0));
        expect(find.byType(FondeIcon), findsOneWidget);
      });

      testWidgets('renders with customColor', (tester) async {
        await tester.pumpTestApp(
          const FondeIcon(Icons.star, customColor: Colors.red),
        );
        expect(find.byType(FondeIcon), findsOneWidget);
      });

      testWidgets('renders with semanticLabel without crashing', (
        tester,
      ) async {
        await tester.pumpTestApp(
          const FondeIcon(Icons.star, semanticLabel: 'Star icon'),
        );
        expect(find.byType(FondeIcon), findsOneWidget);
      });

      testWidgets('disableZoom renders without crashing', (tester) async {
        await tester.pumpTestApp(
          const FondeIcon(Icons.star, disableZoom: true),
        );
        expect(find.byType(FondeIcon), findsOneWidget);
      });
    });

    group('FondeIcons constants', () {
      testWidgets('FondeIcons.search renders without crashing', (tester) async {
        await tester.pumpTestApp(FondeIcon(FondeIcons.search));
        expect(find.byType(FondeIcon), findsOneWidget);
      });

      testWidgets('FondeIcons.settings renders without crashing', (
        tester,
      ) async {
        await tester.pumpTestApp(FondeIcon(FondeIcons.settings));
        expect(find.byType(FondeIcon), findsOneWidget);
      });
    });
  });
}
