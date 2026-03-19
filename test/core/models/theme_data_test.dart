// Tests for FondeThemeData.
//
// Verifies toThemeData conversion, copyWith isolation, and
// getEffectiveAppColorScheme resolution for all ThemeModes.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

void main() {
  group('FondeThemeData', () {
    group('toThemeData', () {
      test('light preset converts to ThemeData without error', () {
        expect(() => FondeThemePresets.light.toThemeData(), returnsNormally);
      });

      test('dark preset converts to ThemeData without error', () {
        expect(() => FondeThemePresets.dark.toThemeData(), returnsNormally);
      });

      test('system preset converts to ThemeData without error', () {
        expect(() => FondeThemePresets.system.toThemeData(), returnsNormally);
      });

      test('converted ThemeData is non-null', () {
        final themeData = FondeThemePresets.light.toThemeData();
        expect(themeData, isNotNull);
        expect(themeData, isA<ThemeData>());
      });
    });

    group('copyWith', () {
      test('changing name does not affect themeMode', () {
        final original = FondeThemePresets.light;
        final updated = original.copyWith(name: 'custom-light');
        expect(updated.name, 'custom-light');
        expect(updated.themeMode, original.themeMode);
      });

      test('changing name does not affect appColorScheme', () {
        final original = FondeThemePresets.light;
        final updated = original.copyWith(name: 'custom-light');
        expect(updated.appColorScheme, original.appColorScheme);
      });

      test('original is not mutated after copyWith', () {
        final original = FondeThemePresets.light;
        final originalName = original.name;
        original.copyWith(name: 'modified');
        expect(original.name, originalName);
      });
    });

    group('getEffectiveAppColorScheme', () {
      test('light theme returns light scheme for any brightness', () {
        final theme = FondeThemePresets.light;
        expect(
          theme.getEffectiveAppColorScheme(Brightness.light).isDarkMode,
          false,
        );
        expect(
          theme.getEffectiveAppColorScheme(Brightness.dark).isDarkMode,
          false,
        );
      });

      test('dark theme returns dark scheme for any brightness', () {
        final theme = FondeThemePresets.dark;
        expect(
          theme.getEffectiveAppColorScheme(Brightness.light).isDarkMode,
          true,
        );
        expect(
          theme.getEffectiveAppColorScheme(Brightness.dark).isDarkMode,
          true,
        );
      });

      test('system theme follows provided brightness (light)', () {
        final theme = FondeThemePresets.system;
        expect(
          theme.getEffectiveAppColorScheme(Brightness.light).isDarkMode,
          false,
        );
      });

      test('system theme follows provided brightness (dark)', () {
        final theme = FondeThemePresets.system;
        expect(
          theme.getEffectiveAppColorScheme(Brightness.dark).isDarkMode,
          true,
        );
      });
    });

    group('ThemeMode', () {
      test('light preset has ThemeMode.light', () {
        expect(FondeThemePresets.light.themeMode, ThemeMode.light);
      });

      test('dark preset has ThemeMode.dark', () {
        expect(FondeThemePresets.dark.themeMode, ThemeMode.dark);
      });

      test('system preset has ThemeMode.system', () {
        expect(FondeThemePresets.system.themeMode, ThemeMode.system);
      });
    });

    group('presets list', () {
      test('FondeThemePresets.all contains at least light, dark, system', () {
        final names = FondeThemePresets.all.map((t) => t.themeMode).toList();
        expect(
          names,
          containsAll([ThemeMode.light, ThemeMode.dark, ThemeMode.system]),
        );
      });
    });
  });
}
