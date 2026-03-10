import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/theme_color_scheme.dart' as models;
import '../models/fonde_color_scheme.dart';
import 'theme_providers.dart';

part 'theme_color_providers.g.dart';

/// Currently selected theme color type.
@riverpod
class FondeThemeColorNotifier extends _$FondeThemeColorNotifier {
  @override
  models.FondeThemeColorType build() {
    return models.FondeThemeColorType.blue;
  }

  void setThemeColor(models.FondeThemeColorType type) {
    state = type;
  }
}

/// Theme color scheme.
@riverpod
models.FondeThemeColorScheme fondeThemeColorScheme(Ref ref) {
  final themeType = ref.watch(fondeThemeColorProvider);
  final brightness = ref.watch(fondePlatformBrightnessProvider);

  return models.FondeThemeColorScheme.create(themeType, brightness);
}

/// Based on the current theme, system brightness settings, and theme color,
/// a Provider that obtains the FondeColorScheme to be actually applied.
@riverpod
FondeColorScheme effectiveColorSchemeWithTheme(Ref ref) {
  final themeData = ref.watch(fondeActiveThemeProvider);
  final platformBrightness = ref.watch(fondePlatformBrightnessProvider);
  final themeColorType = ref.watch(fondeThemeColorProvider);

  // Get base ColorScheme
  final effectiveColorScheme = themeData.getEffectiveAppColorScheme(
    platformBrightness,
  );

  // Create a new ColorScheme with theme colors integrated
  return FondeColorScheme.fromColorScheme(
    effectiveColorScheme.toColorScheme(),
    themeType: themeColorType,
  );
}
