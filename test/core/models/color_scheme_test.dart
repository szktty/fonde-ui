// Tests for FondeColorScheme.
//
// Verifies brightness detection, conversion from Flutter ColorScheme, and
// effective color scheme resolution for ThemeMode.system.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

void main() {
  group('FondeColorScheme', () {
    group('brightness / isDarkMode', () {
      test('isDarkMode is false when brightness is light', () {
        final scheme = FondeThemePresets.light.appColorScheme;
        expect(scheme.brightness, Brightness.light);
        expect(scheme.isDarkMode, false);
      });

      test('isDarkMode is true when brightness is dark', () {
        final scheme = FondeThemePresets.dark.appColorScheme;
        expect(scheme.brightness, Brightness.dark);
        expect(scheme.isDarkMode, true);
      });
    });

    group('fromColorScheme', () {
      test('conversion from light ColorScheme succeeds', () {
        final colorScheme = ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        );
        expect(
          () => FondeColorScheme.fromColorScheme(colorScheme),
          returnsNormally,
        );
      });

      test('conversion from dark ColorScheme succeeds', () {
        final colorScheme = ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        );
        expect(
          () => FondeColorScheme.fromColorScheme(colorScheme),
          returnsNormally,
        );
      });

      test('brightness is preserved after conversion', () {
        final colorScheme = ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        );
        final fondeScheme = FondeColorScheme.fromColorScheme(colorScheme);
        expect(fondeScheme.brightness, Brightness.dark);
      });
    });

    group('getEffectiveAppColorScheme (ThemeMode.system)', () {
      test('returns light scheme when brightness is light', () {
        final theme = FondeThemePresets.system;
        final scheme = theme.getEffectiveAppColorScheme(Brightness.light);
        expect(scheme.isDarkMode, false);
      });

      test('returns dark scheme when brightness is dark', () {
        final theme = FondeThemePresets.system;
        final scheme = theme.getEffectiveAppColorScheme(Brightness.dark);
        expect(scheme.isDarkMode, true);
      });
    });

    group('light vs dark preset color differences', () {
      test('light and dark schemes have different backgrounds', () {
        final light = FondeThemePresets.light.appColorScheme;
        final dark = FondeThemePresets.dark.appColorScheme;
        // The base backgrounds must differ between light and dark themes.
        expect(light.base.background, isNot(dark.base.background));
      });
    });
  });
}
