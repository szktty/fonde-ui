import 'package:flutter/material.dart';
import 'models/fonde_theme_data.dart';
import 'models/fonde_color_scheme.dart';
import 'presets.dart';

/// Utility class for theme-related operations.
class FondeThemeUtils {
  /// Retrieves the FondeColorScheme that should actually be applied based on system brightness settings.
  static FondeColorScheme getEffectiveAppColorScheme(
    FondeThemeData themeData,
    Brightness platformBrightness,
  ) {
    return themeData.getEffectiveAppColorScheme(platformBrightness);
  }

  /// Retrieves a preset theme by its name.
  static FondeThemeData getPresetByName(String name) {
    return FondeThemePresets.all.firstWhere(
      (theme) => theme.name == name,
      orElse: () => FondeThemePresets.system,
    );
  }

  // Method intended for internal use only.
  // Do not use from outside the package.
  // Let the core_themes package handle brightness determination; do not access directly from outside.
  static Brightness _getEffectiveBrightness(
    ThemeMode themeMode,
    Brightness platformBrightness,
  ) {
    switch (themeMode) {
      case ThemeMode.system:
        return platformBrightness;
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
    }
  }
}
