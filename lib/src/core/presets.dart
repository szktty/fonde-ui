import 'dart:ui';
import 'package:flutter/material.dart';
import 'models/fonde_color_scheme.dart';
import 'models/fonde_theme_data.dart';
import 'models/fonde_typography_config.dart';
import 'models/fonde_font_config.dart';

/// Collection of theme presets.
class FondeThemePresets {
  /// Theme that follows system settings.
  ///
  /// The actual color scheme is resolved by [getEffectiveAppColorScheme] based on platformBrightness.
  /// The initial value sets the color scheme according to the current platform's brightness setting.
  static FondeThemeData get system {
    // Get the current platform's brightness setting
    final platformBrightness = PlatformDispatcher.instance.platformBrightness;
    final initialColorScheme = getColorSchemeForBrightness(platformBrightness);

    return FondeThemeData(
      name: 'System Default',
      themeMode: ThemeMode.system,
      appColorScheme: initialColorScheme,
      typography: _defaultTypography,
    );
  }

  /// Light mode theme.
  static final FondeThemeData light = FondeThemeData(
    name: 'Light Mode',
    themeMode: ThemeMode.light,
    appColorScheme: _lightColorScheme,
    typography: _defaultTypography,
  );

  /// Dark mode theme.
  static final FondeThemeData dark = FondeThemeData(
    name: 'Dark Mode',
    themeMode: ThemeMode.dark,
    appColorScheme: _darkColorScheme,
    typography: _defaultTypography,
  );

  /// List of all preset themes.
  static final List<FondeThemeData> all = [system, light, dark];

  /// Get the appropriate color scheme based on brightness mode.
  static FondeColorScheme getColorSchemeForBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? _darkColorScheme : _lightColorScheme;
  }

  /// Default typography settings.
  static final FondeTypographyConfig _defaultTypography = FondeTypographyConfig(
    uiFont: const FondeFontConfig(
      fontFamily: 'Roboto',
      size: 14.0,
      weight: FontWeight.w400,
      letterSpacing: 0.25,
      lineHeight: 1.2,
    ),
    textFont: const FondeFontConfig(
      fontFamily: 'Roboto',
      size: 16.0,
      weight: FontWeight.w400,
      letterSpacing: 0.5,
      lineHeight: 1.5,
    ),
    codeBlockFont: const FondeFontConfig(
      fontFamily: 'RobotoMono',
      size: 14.0,
      weight: FontWeight.w400,
      letterSpacing: 0.0,
      lineHeight: 1.5,
    ),
  );

  /// Color scheme for light mode.
  static final FondeColorScheme _lightColorScheme =
      FondeColorScheme.fromColorScheme(
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B7280),
          brightness: Brightness.light,
        ),
      );

  /// Color scheme for dark mode.
  static final FondeColorScheme _darkColorScheme =
      FondeColorScheme.fromColorScheme(
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B7280),
          brightness: Brightness.dark,
        ),
      );
}
