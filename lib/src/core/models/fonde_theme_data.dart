import 'package:flutter/material.dart';
import 'fonde_typography_config.dart';
import 'fonde_color_scheme.dart';
import '../presets.dart';

/// A class representing theme settings.
class FondeThemeData {
  final String name;
  final FondeTypographyConfig? typography;
  final ThemeMode themeMode;
  final FondeColorScheme appColorScheme;

  /// Getter for compatibility with old API.
  FondeColorScheme get appColors => appColorScheme;

  /// Getter for compatibility with old API.
  /// Mimics the colorScheme property of the ThemeConfig class.
  ColorScheme get colorScheme => appColorScheme.toColorScheme();

  const FondeThemeData({
    required this.name,
    this.typography,
    required this.themeMode,
    required this.appColorScheme,
  });

  /// Creates a copy and modifies the specified properties.
  FondeThemeData copyWith({
    String? name,
    FondeTypographyConfig? typography,
    ThemeMode? themeMode,
    FondeColorScheme? appColorScheme,
    bool clearTypography = false,
  }) {
    return FondeThemeData(
      name: name ?? this.name,
      typography: clearTypography ? null : (typography ?? this.typography),
      themeMode: themeMode ?? this.themeMode,
      appColorScheme: appColorScheme ?? this.appColorScheme,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeThemeData &&
        other.name == name &&
        other.typography == typography &&
        other.appColorScheme == appColorScheme &&
        other.themeMode == themeMode;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        typography.hashCode ^
        appColorScheme.hashCode ^
        themeMode.hashCode;
  }

  /// Retrieves the FondeColorScheme that should actually be applied based on system brightness settings.
  FondeColorScheme getEffectiveAppColorScheme(Brightness platformBrightness) {
    // Determine the brightness mode to apply based on the theme mode.
    final effectiveBrightness = _getEffectiveBrightness(
      themeMode,
      platformBrightness,
    );

    // If the current FondeColorScheme's brightness mode differs, retrieve the corresponding FondeColorScheme.
    if (appColorScheme.brightness != effectiveBrightness) {
      // For themes that follow system settings, use the appropriate preset based on brightness mode.
      if (themeMode == ThemeMode.system) {
        // Retrieve dark mode or light mode color scheme from presets.
        return FondeThemePresets.getColorSchemeForBrightness(
          effectiveBrightness,
        );
      } else {
        // Generate a standard ColorScheme and use it to create a new FondeColorScheme.
        // Note: This method only switches brightness mode, and actual color values may not be changed appropriately.
        final colorScheme = appColorScheme.toColorScheme();
        final newColorScheme = colorScheme.copyWith(
          brightness: effectiveBrightness,
        );
        return FondeColorScheme.fromColorScheme(newColorScheme);
      }
    }

    return appColorScheme;
  }

  // Method intended for internal use only.
  // Retrieves the brightness mode that should actually be applied based on the theme mode.
  Brightness _getEffectiveBrightness(
    ThemeMode mode,
    Brightness platformBrightness,
  ) {
    switch (mode) {
      case ThemeMode.system:
        return platformBrightness;
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
    }
  }

  /// Determines if this theme is a user custom theme.
  bool get isCustomTheme => name == 'Custom Theme';

  /// Converts to Flutter's ThemeData.
  ThemeData toThemeData() {
    // Based on the color scheme, ThemeMode is applied at the app value layer.
    final ColorScheme effectiveColorScheme = appColorScheme.toColorScheme();

    // Reflect typography settings.
    TextTheme? textTheme;

    if (typography != null) {
      // Use typography.toTextTheme().
      textTheme = typography!.toTextTheme();
    }
    return ThemeData(
      useMaterial3: true,
      colorScheme: effectiveColorScheme,
      brightness: effectiveColorScheme.brightness,
      textTheme: textTheme,
      // Font family settings.
      fontFamily: typography?.uiFont?.fontFamily,
      // ThemeMode is specified in the app context, so it is not set here.
      appBarTheme: AppBarTheme(
        backgroundColor: effectiveColorScheme.surface,
        foregroundColor: effectiveColorScheme.onSurface,
      ),
      cardTheme: CardThemeData(
        color: effectiveColorScheme.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveColorScheme.primary,
          foregroundColor: effectiveColorScheme.onPrimary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: effectiveColorScheme.primary,
          side: BorderSide(color: effectiveColorScheme.outline),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: effectiveColorScheme.primary,
        ),
      ),
      iconTheme: IconThemeData(color: effectiveColorScheme.onSurface),
      dividerTheme: DividerThemeData(
        color: appColorScheme.base.divider,
        thickness: 1,
      ),
    );
  }

  @override
  String toString() {
    return 'FondeThemeData(name: $name, typography: $typography, appColorScheme: $appColorScheme, themeMode: $themeMode)';
  }
}
