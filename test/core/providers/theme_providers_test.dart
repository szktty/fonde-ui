// Tests for theme-related Riverpod providers.
//
// Uses ProviderContainer directly — no widget mounting required.
// Verifies initial state, setTheme mutations, and derived provider values.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:fonde_ui/fonde_ui_riverpod.dart';

void main() {
  group('Theme providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
    });
    group('fondeActiveThemeProvider', () {
      test('initial value is the system preset', () {
        final theme = container.read(fondeActiveThemeProvider);
        expect(theme.themeMode, ThemeMode.system);
      });

      test('setTheme(dark) changes the active theme to dark', () {
        container
            .read(fondeActiveThemeProvider.notifier)
            .setTheme(FondeThemePresets.dark);
        final theme = container.read(fondeActiveThemeProvider);
        expect(theme.themeMode, ThemeMode.dark);
      });

      test('setTheme(light) changes the active theme to light', () {
        container
            .read(fondeActiveThemeProvider.notifier)
            .setTheme(FondeThemePresets.light);
        final theme = container.read(fondeActiveThemeProvider);
        expect(theme.themeMode, ThemeMode.light);
      });

      test('setTheme can be called multiple times', () {
        final notifier = container.read(fondeActiveThemeProvider.notifier);
        notifier.setTheme(FondeThemePresets.dark);
        notifier.setTheme(FondeThemePresets.light);
        expect(
          container.read(fondeActiveThemeProvider).themeMode,
          ThemeMode.light,
        );
      });
    });

    group('fondeEffectiveColorSchemeProvider', () {
      test('returns a FondeColorScheme without error', () {
        expect(
          () => container.read(fondeEffectiveColorSchemeProvider),
          returnsNormally,
        );
      });

      test('after setting light theme, isDarkMode is false', () {
        container
            .read(fondeActiveThemeProvider.notifier)
            .setTheme(FondeThemePresets.light);
        final scheme = container.read(fondeEffectiveColorSchemeProvider);
        expect(scheme.isDarkMode, false);
      });

      test('after setting dark theme, isDarkMode is true', () {
        container
            .read(fondeActiveThemeProvider.notifier)
            .setTheme(FondeThemePresets.dark);
        final scheme = container.read(fondeEffectiveColorSchemeProvider);
        expect(scheme.isDarkMode, true);
      });
    });

    group('fondeEffectiveThemeDataProvider', () {
      test('returns a ThemeData without error', () {
        expect(
          () => container.read(fondeEffectiveThemeDataProvider),
          returnsNormally,
        );
      });

      test('returns a ThemeData instance', () {
        final themeData = container.read(fondeEffectiveThemeDataProvider);
        expect(themeData, isA<ThemeData>());
      });
    });

    group('fondeAccessibilityConfigProvider', () {
      test('initial zoomScale is 1.0', () {
        final config = container.read(fondeAccessibilityConfigProvider);
        expect(config.zoomScale, 1.0);
      });

      test('updateConfig changes zoomScale', () {
        container
            .read(fondeAccessibilityConfigProvider.notifier)
            .updateConfig(const FondeAccessibilityConfig(zoomScale: 1.5));
        final config = container.read(fondeAccessibilityConfigProvider);
        expect(config.zoomScale, 1.5);
      });
    });
  });
}
