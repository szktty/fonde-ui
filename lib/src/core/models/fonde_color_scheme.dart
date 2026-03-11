import 'package:flutter/material.dart';
import '../color_extensions.dart';
import 'color_structure.dart';
import 'theme_color_scheme.dart';

/// Color constants class
/// Centralized management of hardcoded color values
/// Guideline: Complies with docs/design/guidelines/12-theme-color.md
class _AppColorConstants {
  // Guideline-compliant base colors
  // Light mode: background #F8F9FA, text #212529
  // Dark mode: background #212529, text #F8F9FA
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightForeground = Color(0xFF212529);
  static const Color darkBackground = Color(0xFF212529);
  static const Color darkForeground = Color(0xFFF8F9FA);

  // Dark mode background colors (for existing UI elements)
  static const Color darkNavigationBackground = Color(0xFF2C2C2E);
  static const Color darkSystemBackground = Color(0xFF2D2D30);
  static const Color darkLaunchBarActiveBackground = Color(0xFF3C3C3E);
  static const Color darkSidebarHoverBackground = Color(0xFF3A3A3C);
  static const Color darkButtonHoverBackground = Color(0xFF3A3A3C);
  static const Color darkButtonActiveBackground = Color(0xFF48484A);
  static const Color darkInputBackground = Color(0xFF2A2A2A);
  static const Color darkDropdownBackground = Color(0xFF2A2A2A);
  static const Color darkDropdownItemHoverBackground = Color(0xFF3A3A3A);

  // Light mode background colors (for existing UI elements)
  static const Color lightNavigationBackground = Color(0xFFF2F2F7);
  static const Color lightSystemBackground = Color(0xFFF3F3F3);
  static const Color lightLaunchBarActiveBackground = Color(0xFFE8E8ED);
  static const Color lightSidebarHoverBackground = Color(0xFFE5E5EA);
  static const Color lightButtonHoverBackground = Color(0xFFE5E5EA);
  static const Color lightButtonActiveBackground = Color(0xFFD1D1D6);
  static const Color lightInputBackground = Color(0xFFF5F5F7);
  static const Color lightDropdownBackground = Color(0xFFF5F5F7);
  static const Color lightDropdownItemHoverBackground = Color(0xFFE5E5EA);

  // Common colors
  static const Color darkBorder = Color(0xFF38383A);
  static const Color lightBorder = Color(0xFFD1D1D6);
  static const Color darkInputBorder = Color(0xFF4A4A4A);
  static const Color lightInputBorder = Color(0xFFD1D1D6);
  static const Color darkButtonBorder = Color(0xFF48484A);
  static const Color lightButtonBorder = Color(0xFFD1D1D6);

  // Destructive action colors
  static const Color darkDestructiveBackground = Color(0xFFFF453A);
  static const Color lightDestructiveBackground = Color(0xFFFF3B30);
  static const Color destructivePressedBackground = Color(0xFFD70015);

  // Opacity constants
  static const int alpha128 = 128; // 50%
  static const int alpha204 = 204; // 80%
  static const int alpha179 = 179; // 70%
  static const int alpha153 = 153; // 60%
  static const int alpha77 = 77; // 30%
  static const int alpha51 = 51; // 20%
  static const int alpha26 = 26; // 10%
  static const int alpha13 = 13; // 5%
}

/// Class representing app-specific color configuration
///
/// Systematic color management system based on VSCode color theme structure
///
/// ## 3-Level Background Color System
/// Prioritizing accessibility and consistency with macOS standard apps, background colors are limited to 3 types:
/// - **Level 1: Main background** - Base, panel, dialog, graph view
/// - **Level 2: Navigation background** - Primary sidebar, secondary sidebar, activity bar
/// - **Level 3: System background** - Title bar, status bar
class FondeColorScheme {
  /// Whether this color configuration is for dark mode
  final Brightness brightness;

  /// Base colors (foreground/background, etc.)
  final FondeBaseColors base;

  /// UI area colors (activity bar, sidebar, etc.)
  final FondeUiAreaColors uiAreas;

  /// Interactive element colors (button, input, etc.)
  final FondeInteractiveColors interactive;

  /// Status display colors (info, warning, error, etc.)
  final FondeStatusColors status;

  /// Theme color configuration
  final FondeThemeColorScheme theme;

  const FondeColorScheme({
    required this.brightness,
    required this.base,
    required this.uiAreas,
    required this.interactive,
    required this.status,
    required this.theme,
  });

  /// Determine whether this color configuration is for dark mode
  bool get isDarkMode => brightness == Brightness.dark;

  /// Generate app-specific color configuration from standard ColorScheme
  factory FondeColorScheme.fromColorScheme(
    ColorScheme colorScheme, {
    FondeThemeColorType themeType = FondeThemeColorType.blue,
  }) {
    final isDark = colorScheme.brightness == Brightness.dark;

    // Create theme color
    final themeColorScheme = FondeThemeColorScheme.create(
      themeType,
      colorScheme.brightness,
    );

    // Define 3-level background color system
    // Level 1: Main background (most frequently used)
    // Guideline compliant: Light #F8F9FA, Dark #212529
    final mainBackground =
        isDark
            ? _AppColorConstants.darkBackground
            : _AppColorConstants.lightBackground;

    // Level 2: Navigation background (primary sidebar, secondary sidebar, activity bar)
    final navigationBackground =
        isDark
            ? _AppColorConstants.darkNavigationBackground
            : _AppColorConstants.lightNavigationBackground;

    // Level 3: System background (title bar, status bar)
    final systemBackground =
        isDark
            ? _AppColorConstants.darkSystemBackground
            : _AppColorConstants.lightSystemBackground;

    // Define base colors
    final baseColors = FondeBaseColors(
      foreground:
          isDark
              ? _AppColorConstants.darkForeground
              : _AppColorConstants.lightForeground,
      background: mainBackground, // Use Level 1
      selection: themeColorScheme.primaryColor,
      border:
          isDark
              ? _AppColorConstants.darkBorder
              : _AppColorConstants.lightBorder,
      divider:
          isDark
              ? _AppColorConstants.darkBorder
              : _AppColorConstants.lightBorder,
      shadow:
          isDark
              ? Colors.black.withAlpha(_AppColorConstants.alpha128)
              : Colors.black.withAlpha(_AppColorConstants.alpha77),
    );

    // Define activity bar colors (Level 2: Navigation background)
    // When selected, background is slightly brighter, icon is theme color (moderate emphasis)
    final launchBarActiveBackground =
        isDark
            ? _AppColorConstants.darkLaunchBarActiveBackground
            : _AppColorConstants.lightLaunchBarActiveBackground;

    final launchBarColors = FondeLaunchBarColors(
      background: navigationBackground, // Use Level 2
      activeItemBackground: launchBarActiveBackground,
      activeItem: themeColorScheme.primaryColor, // Selected icon: theme color
      inactiveItem: baseColors.foreground, // Unselected: base text color
      hoverItem: themeColorScheme.primaryColor,
      badgeBackground: colorScheme.secondary,
    );

    // Define sidebar colors (Level 2: Navigation background)
    final sideBarColors = FondeSideBarColors(
      background: navigationBackground, // Use Level 2
      divider: baseColors.divider,
      groupHeader: themeColorScheme.primaryColor,
      activeItemBackground: themeColorScheme.primaryColor.withAlpha(
        _AppColorConstants.alpha204,
      ),
      activeItemText: Colors.white,
      inactiveItemText: baseColors.foreground,
      hoverBackground:
          isDark
              ? _AppColorConstants.darkSidebarHoverBackground
              : _AppColorConstants.lightSidebarHoverBackground,
    );

    // Define status bar colors (Level 3: System background)
    final statusBarColors = FondeStatusBarColors(
      background: systemBackground, // Use Level 3
      foreground: baseColors.foreground,
      itemHoverBackground:
          isDark
              ? colorScheme.onSurface.withAlpha(_AppColorConstants.alpha26)
              : themeColorScheme.primaryColor.withAlpha(
                _AppColorConstants.alpha13,
              ),
      prominentBackground: colorScheme.error,
      prominentForeground: colorScheme.onError,
    );

    // Define panel colors (Level 1: Main background)
    final panelColors = FondePanelColors(
      background: mainBackground, // Use Level 1
      border: baseColors.border,
      foreground: baseColors.foreground,
    );

    // Define dialog colors (Level 1: Main background)
    final dialogColors = FondeDialogColors(
      background: mainBackground, // Use Level 1
      border: baseColors.foreground,
      foreground: baseColors.foreground,
      shadow: baseColors.shadow,
      barrier: Colors.black.withAlpha(_AppColorConstants.alpha77),
    );

    // Define title bar colors (Level 3: System background)
    final titleBarColors = FondeToolbarColors(
      background: systemBackground, // Use Level 3
      border: baseColors.divider,
      foreground: baseColors.foreground,
      iconColor: baseColors.foreground,
      buttonHoverBackground:
          isDark
              ? baseColors.foreground.withAlpha(_AppColorConstants.alpha26)
              : baseColors.foreground.withAlpha(_AppColorConstants.alpha13),
      buttonActiveBackground:
          isDark
              ? baseColors.foreground.withAlpha(_AppColorConstants.alpha51)
              : baseColors.foreground.withAlpha(_AppColorConstants.alpha26),
    );

    // Consolidate UI area colors
    final uiAreaColors = FondeUiAreaColors(
      launchBar: launchBarColors,
      sideBar: sideBarColors,
      statusBar: statusBarColors,
      toolbar: titleBarColors,
      panel: panelColors,
      dialog: dialogColors,
    );

    // Define base state-based colors
    FondeStatefulColors createStatefulColors(
      Color normal, {
      Color? hover,
      Color? active,
    }) {
      return FondeStatefulColors(
        normal: normal,
        hover: hover ?? (isDark ? normal.lighten(0.1) : normal.darken(0.1)),
        active: active ?? (isDark ? normal.lighten(0.2) : normal.darken(0.2)),
        disabled: normal.withAlpha(_AppColorConstants.alpha128),
        focus: themeColorScheme.primaryColor,
      );
    }

    // Define button colors
    final buttonColors = FondeButtonColors(
      background: createStatefulColors(
        Colors.transparent,
        hover:
            isDark
                ? _AppColorConstants.darkButtonHoverBackground
                : _AppColorConstants.lightButtonHoverBackground,
        active:
            isDark
                ? _AppColorConstants.darkButtonActiveBackground
                : _AppColorConstants.lightButtonActiveBackground,
      ),
      text: createStatefulColors(baseColors.foreground),
      border: createStatefulColors(
        isDark
            ? _AppColorConstants.darkButtonBorder
            : _AppColorConstants.lightButtonBorder,
      ),
      primaryBackground: themeColorScheme.primaryColor,
      primaryText: colorScheme.onPrimary,
      primaryPressedBackground:
          isDark
              ? themeColorScheme.primaryColor.darken(0.15)
              : themeColorScheme.primaryColor.darken(0.1),
      // Destructive action button specific colors
      destructiveBackground:
          isDark
              ? _AppColorConstants.darkDestructiveBackground
              : _AppColorConstants.lightDestructiveBackground,
      destructiveText: Colors.white,
      destructivePressedBackground:
          _AppColorConstants.destructivePressedBackground,
    );

    // Define input colors
    final inputColors = FondeInputColors(
      background:
          isDark
              ? _AppColorConstants.darkInputBackground
              : _AppColorConstants.lightInputBackground,
      border:
          isDark
              ? _AppColorConstants.darkInputBorder
              : _AppColorConstants.lightInputBorder,
      focusBorder: themeColorScheme.primaryColor,
      placeholder: baseColors.foreground.withAlpha(_AppColorConstants.alpha128),
      text: baseColors.foreground,
    );

    // Define list colors
    final listColors = FondeListColors(
      itemBackground: createStatefulColors(
        Colors.transparent,
        hover:
            isDark
                ? colorScheme.onSurface.withAlpha(_AppColorConstants.alpha51)
                : themeColorScheme.primaryColor.withAlpha(
                  _AppColorConstants.alpha26,
                ),
      ),
      itemText: createStatefulColors(baseColors.foreground),
      selectedBackground: sideBarColors.activeItemBackground,
      selectedText: sideBarColors.activeItemText,
    );

    // Define dropdown colors
    final dropdownColors = FondeDropdownColors(
      background:
          isDark
              ? _AppColorConstants.darkDropdownBackground
              : _AppColorConstants.lightDropdownBackground,
      border:
          isDark
              ? _AppColorConstants.darkInputBorder
              : _AppColorConstants.lightInputBorder,
      itemBackground: createStatefulColors(
        Colors.transparent,
        hover:
            isDark
                ? _AppColorConstants.darkDropdownItemHoverBackground
                : _AppColorConstants.lightDropdownItemHoverBackground,
      ),
      itemText: baseColors.foreground,
    );

    // Define popover colors
    final popoverColors = FondePopoverColors(
      background: colorScheme.surface,
      text: baseColors.foreground,
      border: baseColors.border,
      shadow: baseColors.shadow,
      barrier: Colors.black.withAlpha(_AppColorConstants.alpha77),
    );

    // Define quick input colors
    final quickInputColors = FondeQuickInputColors(
      fieldBackground: colorScheme.surfaceContainerHighest.withAlpha(
        _AppColorConstants.alpha128,
      ),
      fieldBorder: baseColors.border,
      fieldActiveBorder: themeColorScheme.primaryColor,
      placeholderText: baseColors.foreground.withAlpha(
        _AppColorConstants.alpha179,
      ),
      inputText: baseColors.foreground,
      iconColor: baseColors.foreground.withAlpha(_AppColorConstants.alpha179),
      dropdownBackground: colorScheme.surfaceContainer,
      dropdownBorder: baseColors.border,
      selectedItemBackground: colorScheme.primaryContainer,
      selectedItemText: colorScheme.onPrimaryContainer,
      hoverBackground:
          isDark
              ? baseColors.foreground.withAlpha(_AppColorConstants.alpha26)
              : baseColors.foreground.withAlpha(_AppColorConstants.alpha13),
      itemText: baseColors.foreground,
      itemDescriptionText: baseColors.foreground.withAlpha(
        _AppColorConstants.alpha153,
      ),
    );

    // Define action button colors
    final actionButtonColors = FondeActionButtonColors(
      background:
          isDark
              ? baseColors.foreground.withAlpha(_AppColorConstants.alpha51)
              : baseColors.foreground.withAlpha(_AppColorConstants.alpha26),
      iconColor: baseColors.foreground,
    );

    // Consolidate interactive colors
    final interactiveColors = FondeInteractiveColors(
      button: buttonColors,
      input: inputColors,
      list: listColors,
      dropdown: dropdownColors,
      popover: popoverColors,
      quickInput: quickInputColors,
      actionButton: actionButtonColors,
    );

    // Define status display colors
    final statusColors = FondeStatusColors(
      info: themeColorScheme.primaryColor,
      warning: isDark ? Colors.amber : Colors.orange,
      error: colorScheme.error,
      success: isDark ? Colors.green.shade400 : Colors.green.shade600,
      loading: themeColorScheme.primaryColor,
      loadingBackground: colorScheme.surface,
    );

    return FondeColorScheme(
      brightness: colorScheme.brightness,
      base: baseColors,
      uiAreas: uiAreaColors,
      interactive: interactiveColors,
      status: statusColors,
      theme: themeColorScheme,
    );
  }

  /// Create a copy and modify specified properties
  FondeColorScheme copyWith({
    Brightness? brightness,
    FondeBaseColors? base,
    FondeUiAreaColors? uiAreas,
    FondeInteractiveColors? interactive,
    FondeStatusColors? status,
    FondeThemeColorScheme? theme,
  }) {
    return FondeColorScheme(
      brightness: brightness ?? this.brightness,
      base: base ?? this.base,
      uiAreas: uiAreas ?? this.uiAreas,
      interactive: interactive ?? this.interactive,
      status: status ?? this.status,
      theme: theme ?? this.theme,
    );
  }

  /// Convert to Flutter's ColorScheme
  ColorScheme toColorScheme() {
    final isDark = brightness == Brightness.dark;

    return ColorScheme(
      brightness: brightness,

      // Primary color
      primary: theme.primaryColor,
      onPrimary: isDark ? Colors.white : Colors.black,
      primaryContainer: uiAreas.sideBar.activeItemBackground,
      onPrimaryContainer: uiAreas.sideBar.activeItemText,

      // Secondary color
      secondary: interactive.list.selectedBackground,
      onSecondary: isDark ? Colors.black : Colors.white,
      secondaryContainer: interactive.input.background,
      onSecondaryContainer: base.foreground,

      // Tertiary color
      tertiary: theme.primaryColor,
      onTertiary: isDark ? Colors.black : Colors.white,
      tertiaryContainer: isDark ? Colors.teal.shade700 : Colors.teal.shade100,
      onTertiaryContainer: isDark ? Colors.white : Colors.black,

      // Error color
      error: status.error,
      onError: isDark ? Colors.black : Colors.white,
      errorContainer: isDark ? Colors.red.shade900 : Colors.red.shade100,
      onErrorContainer: isDark ? Colors.white : Colors.red.shade900,

      // Surface
      surface: base.background,
      onSurface: base.foreground,
      surfaceContainer: uiAreas.sideBar.background,
      surfaceContainerHighest: base.background,
      onSurfaceVariant: isDark ? Colors.white70 : Colors.black87,

      // Others
      outline: base.border,
      outlineVariant: interactive.input.border,
      shadow: base.shadow,
      scrim: Colors.black54,
      inverseSurface: isDark ? Colors.white : Colors.black,
      onInverseSurface: isDark ? Colors.black : Colors.white,
      inversePrimary: isDark ? Colors.indigo.shade300 : Colors.indigo.shade700,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeColorScheme &&
        other.brightness == brightness &&
        other.base == base &&
        other.uiAreas == uiAreas &&
        other.interactive == interactive &&
        other.status == status &&
        other.theme == theme;
  }

  @override
  int get hashCode {
    return Object.hash(brightness, base, uiAreas, interactive, status, theme);
  }

  @override
  String toString() {
    return 'FondeColorScheme('
        'brightness: $brightness, '
        'base: $base, '
        'uiAreas: $uiAreas, '
        'interactive: $interactive, '
        'status: $status, '
        'theme: $theme'
        ')';
  }
}
