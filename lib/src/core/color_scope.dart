import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'models/fonde_color_scheme.dart';
import 'providers/theme_providers.dart';

/// Standard color definitions provided by the color scope.
///
/// To improve component reusability and maintainability,
/// provides color abstraction based on context.
class FondeColorScope {
  /// Text color within the scope.
  final Color text;

  /// Background color within the scope.
  final Color background;

  /// Border color within the scope.
  final Color border;

  /// Selection color within the scope.
  final Color selection;

  /// Subtle selection background color (light grey, used with accent-colored text).
  final Color subtleSelection;

  /// Hover color within the scope.
  final Color hover;

  /// Accent color within the scope.
  final Color accent;

  /// Disabled state color within the scope.
  final Color disabled;

  const FondeColorScope({
    required this.text,
    required this.background,
    required this.border,
    required this.selection,
    required this.subtleSelection,
    required this.hover,
    required this.accent,
    required this.disabled,
  });

  /// Creates a copy of the ColorScope.
  FondeColorScope copyWith({
    Color? text,
    Color? background,
    Color? border,
    Color? selection,
    Color? subtleSelection,
    Color? hover,
    Color? accent,
    Color? disabled,
  }) {
    return FondeColorScope(
      text: text ?? this.text,
      background: background ?? this.background,
      border: border ?? this.border,
      selection: selection ?? this.selection,
      subtleSelection: subtleSelection ?? this.subtleSelection,
      hover: hover ?? this.hover,
      accent: accent ?? this.accent,
      disabled: disabled ?? this.disabled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeColorScope &&
        other.text == text &&
        other.background == background &&
        other.border == border &&
        other.selection == selection &&
        other.subtleSelection == subtleSelection &&
        other.hover == hover &&
        other.accent == accent &&
        other.disabled == disabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      text,
      background,
      border,
      selection,
      subtleSelection,
      hover,
      accent,
      disabled,
    );
  }

  @override
  String toString() {
    return 'ColorScope('
        'text: $text, '
        'background: $background, '
        'border: $border, '
        'selection: $selection, '
        'subtleSelection: $subtleSelection, '
        'hover: $hover, '
        'accent: $accent, '
        'disabled: $disabled'
        ')';
  }
}

/// Provider that manages the system's theme mode.
/// Kept for backwards compatibility; prefer [fondeActiveThemeProvider] for theme switching.
final fondeThemeModeProvider = StateProvider<ThemeMode>((ref) {
  return ref.watch(fondeActiveThemeProvider).themeMode;
});

/// Provider that determines the current light/dark mode.
final fondeIsDarkModeProvider = Provider<bool>((ref) {
  final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
  return colorScheme.isDarkMode;
});

/// Provider that manages the entire color scheme.
/// Delegates to [fondeEffectiveColorSchemeProvider] so that theme switches
/// via [fondeActiveThemeProvider] are reflected immediately.
final fondeColorSchemeProvider = Provider<FondeColorScheme>((ref) {
  return ref.watch(fondeEffectiveColorSchemeProvider);
});

/// Default ColorScope Provider.
/// Provides the basic color scope for the entire application.
final fondeDefaultColorScopeProvider = Provider<FondeColorScope>((ref) {
  final colors = ref.watch(fondeColorSchemeProvider);

  return FondeColorScope(
    text: colors.base.foreground,
    background: colors.base.background,
    border: colors.base.border,
    selection: colors.base.selection,
    subtleSelection: colors.interactive.list.itemBackground.hover,
    hover: colors.interactive.list.itemBackground.hover,
    accent: colors.theme.primaryColor,
    disabled: colors.base.foreground.withAlpha(128),
  );
});

/// ColorScope Provider specifically for the activity bar.
final fondeLaunchBarColorScopeProvider = Provider<FondeColorScope>((ref) {
  final colors = ref.watch(fondeColorSchemeProvider);
  final launchBar = colors.uiAreas.launchBar;

  return FondeColorScope(
    text: launchBar.activeItem,
    background: launchBar.background,
    border: colors.base.border,
    selection: launchBar.activeItem,
    subtleSelection: colors.interactive.list.itemBackground.hover,
    hover: launchBar.hoverItem,
    accent: launchBar.activeItem,
    disabled: launchBar.inactiveItem,
  );
});

/// ColorScope Provider specifically for the sidebar.
final fondeSideBarColorScopeProvider = Provider<FondeColorScope>((ref) {
  final colors = ref.watch(fondeColorSchemeProvider);
  final sideBar = colors.uiAreas.sideBar;

  return FondeColorScope(
    text: sideBar.inactiveItemText,
    background: sideBar.background,
    border: sideBar.divider,
    selection: sideBar.activeItemBackground,
    subtleSelection: sideBar.hoverBackground,
    hover: sideBar.hoverBackground,
    accent: sideBar.activeItemText,
    disabled: sideBar.inactiveItemText.withAlpha(128),
  );
});

/// ColorScope Provider specifically for the main content area.
final fondeMainContentColorScopeProvider = Provider<FondeColorScope>((ref) {
  final colors = ref.watch(fondeColorSchemeProvider);

  return FondeColorScope(
    text: colors.base.foreground,
    background: colors.base.background,
    border: colors.base.border,
    selection: colors.interactive.list.selectedBackground,
    subtleSelection: colors.interactive.list.itemBackground.hover,
    hover: colors.interactive.list.selectedBackground.withAlpha(128),
    accent: colors.theme.primaryColor,
    disabled: colors.base.foreground.withAlpha(128),
  );
});

/// ColorScope Provider specifically for dialogs.
final fondeDialogColorScopeProvider = Provider<FondeColorScope>((ref) {
  final colors = ref.watch(fondeColorSchemeProvider);
  final dialog = colors.uiAreas.dialog;

  return FondeColorScope(
    text: dialog.foreground,
    background: dialog.background,
    border: dialog.border,
    selection: colors.base.selection,
    subtleSelection: colors.interactive.list.itemBackground.hover,
    hover: colors.interactive.list.itemBackground.hover,
    accent: colors.theme.primaryColor,
    disabled: dialog.foreground.withAlpha(128),
  );
});

/// Provider that gets the current ColorScope.
/// If overridden by ProviderScope, use that value.
final fondeColorScopeProvider = Provider<FondeColorScope>((ref) {
  // Returns the default color scope.
  // Overridden by ProviderScope during actual use.
  return ref.watch(fondeDefaultColorScopeProvider);
});

/// Helper functions for managing ColorScope hierarchy.
class FondeColorScopeHelper {
  /// Wraps a widget with the activity bar's ColorScope.
  static Widget withLaunchBarScope({required Widget child}) {
    return Consumer(
      builder: (context, ref, _) {
        final scope = ref.watch(fondeLaunchBarColorScopeProvider);
        return ProviderScope(
          overrides: [fondeColorScopeProvider.overrideWithValue(scope)],
          child: child,
        );
      },
    );
  }

  /// Wraps a widget with the sidebar's ColorScope.
  static Widget withSideBarScope({
    required Widget child,
    bool isActive = false,
  }) {
    return Consumer(
      builder: (context, ref, _) {
        final baseScope = ref.watch(fondeSideBarColorScopeProvider);
        final colors = ref.watch(fondeColorSchemeProvider);

        final scope = isActive
            ? baseScope.copyWith(
                text: colors.uiAreas.sideBar.activeItemText,
                background: colors.uiAreas.sideBar.activeItemBackground,
                subtleSelection: baseScope.subtleSelection,
              )
            : baseScope;

        return ProviderScope(
          overrides: [fondeColorScopeProvider.overrideWithValue(scope)],
          child: child,
        );
      },
    );
  }

  /// Wraps a widget with the main content's ColorScope.
  static Widget withMainContentScope({required Widget child}) {
    return Consumer(
      builder: (context, ref, _) {
        final scope = ref.watch(fondeMainContentColorScopeProvider);
        return ProviderScope(
          overrides: [fondeColorScopeProvider.overrideWithValue(scope)],
          child: child,
        );
      },
    );
  }

  /// Wraps a widget with the dialog's ColorScope.
  static Widget withDialogScope({required Widget child}) {
    return Consumer(
      builder: (context, ref, _) {
        final scope = ref.watch(fondeDialogColorScopeProvider);
        return ProviderScope(
          overrides: [fondeColorScopeProvider.overrideWithValue(scope)],
          child: child,
        );
      },
    );
  }

  /// Wraps a widget with a custom ColorScope.
  static Widget withCustomScope({
    required Widget child,
    required FondeColorScope scope,
  }) {
    return ProviderScope(
      overrides: [fondeColorScopeProvider.overrideWithValue(scope)],
      child: child,
    );
  }
}
