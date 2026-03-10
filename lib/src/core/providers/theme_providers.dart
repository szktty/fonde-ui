import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model.dart';
import '../models/fonde_icon_theme.dart';
import '../presets.dart';
import 'theme_color_providers.dart';

part 'theme_providers.g.dart';

/// Provider that monitors platform brightness settings.
@riverpod
class FondePlatformBrightness extends _$FondePlatformBrightness {
  @override
  Brightness build() {
    final platformDispatcher = PlatformDispatcher.instance;
    final initialBrightness = platformDispatcher.platformBrightness;

    void updateBrightness() {
      state = platformDispatcher.platformBrightness;
    }

    platformDispatcher.onPlatformBrightnessChanged = updateBrightness;
    ref.onDispose(() {
      platformDispatcher.onPlatformBrightnessChanged = null;
    });

    return initialBrightness;
  }
}

/// Active theme management Provider.
///
/// Theme persistence is left to the application. To restore a saved theme,
/// call [setTheme] after reading from your preferred storage.
@riverpod
class FondeActiveTheme extends _$FondeActiveTheme {
  @override
  FondeThemeData build() => FondeThemePresets.system;

  void setTheme(FondeThemeData newTheme) {
    state = newTheme;
  }
}

/// Provider that obtains the FondeColorScheme to be actually applied,
/// based on the current theme, system brightness settings, and theme color.
@riverpod
FondeColorScheme fondeEffectiveColorScheme(Ref ref) {
  final themeData = ref.watch(fondeActiveThemeProvider);
  final platformBrightness = ref.watch(fondePlatformBrightnessProvider);
  final themeColorType = ref.watch(fondeThemeColorProvider);

  final baseColorScheme = themeData.getEffectiveAppColorScheme(
    platformBrightness,
  );

  return FondeColorScheme.fromColorScheme(
    baseColorScheme.toColorScheme(),
    themeType: themeColorType,
  );
}

/// Provider that obtains the Flutter ColorScheme to be actually applied.
@riverpod
ColorScheme fondeEffectiveFlutterColorScheme(Ref ref) {
  final appColorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
  return appColorScheme.toColorScheme();
}

/// Provider that obtains the ThemeData to be actually applied.
@riverpod
ThemeData fondeEffectiveThemeData(Ref ref) {
  final themeData = ref.watch(fondeActiveThemeProvider);
  final effectiveColorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
  return themeData.copyWith(appColorScheme: effectiveColorScheme).toThemeData();
}

/// Active icon theme management Provider.
///
/// The initial value is null. Set a [FondeIconTheme] via [setIconTheme] to
/// activate a custom icon set. Components fall back to [lucideIconTheme] when null.
@riverpod
class FondeActiveIconTheme extends _$FondeActiveIconTheme {
  @override
  FondeIconTheme? build() => null;

  void setIconTheme(FondeIconTheme theme) {
    state = theme;
  }
}

/// Provider that manages accessibility settings.
///
/// Persistence is left to the application. Call [updateConfig] with a loaded
/// [FondeAccessibilityConfig] to restore saved settings.
@riverpod
class FondeAccessibilityConfigNotifier
    extends _$FondeAccessibilityConfigNotifier {
  @override
  FondeAccessibilityConfig build() => const FondeAccessibilityConfig();

  void updateConfig(FondeAccessibilityConfig newConfig) {
    state = newConfig;
  }
}
