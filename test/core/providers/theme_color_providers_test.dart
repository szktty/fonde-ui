// Tests for theme color (accent) Riverpod providers.
//
// Uses ProviderContainer directly — no widget mounting required.
// Verifies initial accent color, setThemeColor mutations, and that derived
// color scheme providers update accordingly.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:fonde_ui/fonde_ui_riverpod.dart';

void main() {
  group('Theme color providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
    });
    group('fondeThemeColorProvider', () {
      test('has a defined initial value', () {
        expect(() => container.read(fondeThemeColorProvider), returnsNormally);
        expect(
          container.read(fondeThemeColorProvider),
          isA<FondeThemeColorType>(),
        );
      });

      test('setThemeColor(indigo) changes the value to indigo', () {
        container
            .read(fondeThemeColorProvider.notifier)
            .setThemeColor(FondeThemeColorType.indigo);
        expect(
          container.read(fondeThemeColorProvider),
          FondeThemeColorType.indigo,
        );
      });

      test('setThemeColor(red) changes the value to red', () {
        container
            .read(fondeThemeColorProvider.notifier)
            .setThemeColor(FondeThemeColorType.red);
        expect(
          container.read(fondeThemeColorProvider),
          FondeThemeColorType.red,
        );
      });

      test('accent color can be changed multiple times', () {
        final notifier = container.read(fondeThemeColorProvider.notifier);
        notifier.setThemeColor(FondeThemeColorType.green);
        notifier.setThemeColor(FondeThemeColorType.violet);
        expect(
          container.read(fondeThemeColorProvider),
          FondeThemeColorType.violet,
        );
      });
    });

    group('effectiveColorSchemeWithThemeProvider', () {
      test('returns a FondeColorScheme without error', () {
        expect(
          () => container.read(effectiveColorSchemeWithThemeProvider),
          returnsNormally,
        );
      });

      test('color scheme changes after accent color change', () {
        final before = container.read(effectiveColorSchemeWithThemeProvider);
        // Change to a different accent color.
        final currentColor = container.read(fondeThemeColorProvider);
        final newColor =
            currentColor == FondeThemeColorType.indigo
                ? FondeThemeColorType.red
                : FondeThemeColorType.indigo;
        container
            .read(fondeThemeColorProvider.notifier)
            .setThemeColor(newColor);
        final after = container.read(effectiveColorSchemeWithThemeProvider);
        expect(after.theme.primaryColor, isNot(before.theme.primaryColor));
      });
    });
  });
}
