import 'package:flutter/material.dart';

/// Defines the types of theme colors.
enum FondeThemeColorType {
  red,
  orange,
  yellow,
  green,
  blue,
  indigo,
  violet,
  pink,
  graphite,
}

/// Definition of theme colors.
class FondeThemeColorDefinition {
  final FondeThemeColorType type;
  final Color lightColor;
  final Color darkColor;
  final String displayName;

  const FondeThemeColorDefinition({
    required this.type,
    required this.lightColor,
    required this.darkColor,
    required this.displayName,
  });
}

/// Theme color scheme.
class FondeThemeColorScheme {
  final FondeThemeColorType currentType;
  final Map<FondeThemeColorType, FondeThemeColorDefinition> colors;
  final Brightness brightness;

  const FondeThemeColorScheme({
    required this.currentType,
    required this.colors,
    required this.brightness,
  });

  /// Current theme color definition.
  FondeThemeColorDefinition get current => colors[currentType]!;

  /// Current theme color (common to light and dark modes).
  ///
  /// Uses a shared color for both light and dark modes.
  /// Sufficient contrast ratio (3:1 or higher) ensured in both modes.
  Color get primaryColor => current.lightColor;

  /// Creates default theme color definitions.
  ///
  /// Uses optimal color codes for light and dark modes with sufficient contrast ratios.
  static Map<FondeThemeColorType, FondeThemeColorDefinition>
  get defaultColors => {
    FondeThemeColorType.red: const FondeThemeColorDefinition(
      type: FondeThemeColorType.red,
      lightColor: Color(0xFFE55353), // vs Light: 3.50:1
      darkColor: Color(0xFFFF6B6B), // vs Dark: 5.56:1
      displayName: 'Red',
    ),
    FondeThemeColorType.orange: const FondeThemeColorDefinition(
      type: FondeThemeColorType.orange,
      lightColor: Color(0xFFD97422), // vs Light: 3.01:1
      darkColor: Color(0xFFFFA96B), // vs Dark: 8.18:1
      displayName: 'Orange',
    ),
    FondeThemeColorType.yellow: const FondeThemeColorDefinition(
      type: FondeThemeColorType.yellow,
      lightColor: Color(0xFFB58D09), // vs Light: 3.01:1
      darkColor: Color(0xFFFFD46B), // vs Dark: 10.93:1
      displayName: 'Yellow',
    ),
    FondeThemeColorType.green: const FondeThemeColorDefinition(
      type: FondeThemeColorType.green,
      lightColor: Color(0xFF36A369), // vs Light: 3.02:1
      darkColor: Color(0xFF53D18B), // vs Dark: 7.98:1
      displayName: 'Green',
    ),
    FondeThemeColorType.blue: const FondeThemeColorDefinition(
      type: FondeThemeColorType.blue,
      lightColor: Color(0xFF3B8AD1), // vs Light: 3.47:1
      darkColor: Color(0xFF5CA5E6), // vs Dark: 5.86:1
      displayName: 'Blue',
    ),
    FondeThemeColorType.indigo: const FondeThemeColorDefinition(
      type: FondeThemeColorType.indigo,
      lightColor: Color(0xFF6360CF), // vs Light: 4.85:1
      darkColor: Color(0xFF8B88FF), // vs Dark: 5.19:1
      displayName: 'Indigo',
    ),
    FondeThemeColorType.violet: const FondeThemeColorDefinition(
      type: FondeThemeColorType.violet,
      lightColor: Color(0xFF9655AB), // vs Light: 4.76:1
      darkColor: Color(0xFFC079D9), // vs Dark: 5.13:1
      displayName: 'Violet',
    ),
    FondeThemeColorType.pink: const FondeThemeColorDefinition(
      type: FondeThemeColorType.pink,
      lightColor: Color(0xFFE553A0), // vs Light: 3.28:1
      darkColor: Color(0xFFFF6BAA), // vs Dark: 5.83:1
      displayName: 'Pink',
    ),
    FondeThemeColorType.graphite: const FondeThemeColorDefinition(
      type: FondeThemeColorType.graphite,
      lightColor: Color(0xFF868E96), // vs Light: 3.15:1
      darkColor: Color(0xFFBCC2C8), // vs Dark: 8.59:1
      displayName: 'Graphite',
    ),
  };

  /// Factory method.
  factory FondeThemeColorScheme.create(
    FondeThemeColorType type,
    Brightness brightness,
  ) {
    return FondeThemeColorScheme(
      currentType: type,
      colors: defaultColors,
      brightness: brightness,
    );
  }

  /// Copy method.
  FondeThemeColorScheme copyWith({
    FondeThemeColorType? currentType,
    Map<FondeThemeColorType, FondeThemeColorDefinition>? colors,
    Brightness? brightness,
  }) {
    return FondeThemeColorScheme(
      currentType: currentType ?? this.currentType,
      colors: colors ?? this.colors,
      brightness: brightness ?? this.brightness,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeThemeColorScheme &&
        other.currentType == currentType &&
        other.colors == colors &&
        other.brightness == brightness;
  }

  @override
  int get hashCode {
    return Object.hash(currentType, colors, brightness);
  }
}
