import 'package:flutter/material.dart';

import 'color_scope.dart';
import 'fonde_theme_scope.dart';
import 'models/fonde_color_scheme.dart';

/// Propagates a [FondeColorScope] down the widget tree.
///
/// Use [FondeColorScopeWidget.of] (or [BuildContext.fondeColorScope]) to read
/// the nearest scope. [FondeColorScopeHelper] provides convenience wrappers
/// that install the standard scopes used by fonde_ui components.
class FondeColorScopeWidget extends InheritedWidget {
  const FondeColorScopeWidget({
    super.key,
    required this.scope,
    required super.child,
  });

  final FondeColorScope scope;

  /// Returns the nearest [FondeColorScope] in the widget tree.
  ///
  /// Falls back to the default scope derived from [FondeThemeScope] when no
  /// explicit [FondeColorScopeWidget] is present.
  static FondeColorScope of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<FondeColorScopeWidget>();
    if (widget != null) return widget.scope;

    // Fall back to default scope from theme.
    final themeScope = FondeThemeScope.maybeOf(context);
    if (themeScope != null) {
      return _defaultScope(themeScope.colorScheme);
    }

    // Should not happen in a properly configured app.
    assert(
      false,
      'No FondeColorScopeWidget or FondeThemeScope found. '
      'Make sure your widget is inside a FondeApp.',
    );
    return _fallbackScope();
  }

  @override
  bool updateShouldNotify(FondeColorScopeWidget oldWidget) {
    return scope != oldWidget.scope;
  }
}

FondeColorScope _defaultScope(FondeColorScheme colors) {
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
}

FondeColorScope _fallbackScope() {
  return const FondeColorScope(
    text: Color(0xFF000000),
    background: Color(0xFFFFFFFF),
    border: Color(0xFFCCCCCC),
    selection: Color(0xFF0078D7),
    subtleSelection: Color(0xFFE5F1FB),
    hover: Color(0xFFE5F1FB),
    accent: Color(0xFF0078D7),
    disabled: Color(0xFF888888),
  );
}

/// Builds the standard [FondeColorScope] values from a [FondeColorScheme].
///
/// This is the non-Riverpod equivalent of the old `fondeXxxColorScopeProvider`
/// family.
class FondeColorScopeBuilder {
  static FondeColorScope defaultScope(FondeColorScheme colors) =>
      _defaultScope(colors);

  static FondeColorScope launchBarScope(FondeColorScheme colors) {
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
  }

  static FondeColorScope sideBarScope(
    FondeColorScheme colors, {
    bool isActive = false,
  }) {
    final sideBar = colors.uiAreas.sideBar;
    final base = FondeColorScope(
      text: sideBar.inactiveItemText,
      background: sideBar.background,
      border: sideBar.divider,
      selection: sideBar.activeItemBackground,
      subtleSelection: sideBar.hoverBackground,
      hover: sideBar.hoverBackground,
      accent: sideBar.activeItemText,
      disabled: sideBar.inactiveItemText.withAlpha(128),
    );
    if (!isActive) return base;
    return base.copyWith(
      text: sideBar.activeItemText,
      background: sideBar.activeItemBackground,
    );
  }

  static FondeColorScope mainContentScope(FondeColorScheme colors) {
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
  }

  static FondeColorScope dialogScope(FondeColorScheme colors) {
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
  }
}

/// Convenience wrappers that wrap a subtree with a specific [FondeColorScope].
///
/// Drop-in replacement for the old Riverpod-based [FondeColorScopeHelper].
class FondeColorScopeHelper {
  static Widget withLaunchBarScope({required Widget child}) {
    return Builder(
      builder: (context) {
        final colors = FondeThemeScope.of(context).colorScheme;
        return FondeColorScopeWidget(
          scope: FondeColorScopeBuilder.launchBarScope(colors),
          child: child,
        );
      },
    );
  }

  static Widget withSideBarScope({
    required Widget child,
    bool isActive = false,
  }) {
    return Builder(
      builder: (context) {
        final colors = FondeThemeScope.of(context).colorScheme;
        return FondeColorScopeWidget(
          scope: FondeColorScopeBuilder.sideBarScope(
            colors,
            isActive: isActive,
          ),
          child: child,
        );
      },
    );
  }

  static Widget withMainContentScope({required Widget child}) {
    return Builder(
      builder: (context) {
        final colors = FondeThemeScope.of(context).colorScheme;
        return FondeColorScopeWidget(
          scope: FondeColorScopeBuilder.mainContentScope(colors),
          child: child,
        );
      },
    );
  }

  static Widget withDialogScope({required Widget child}) {
    return Builder(
      builder: (context) {
        final colors = FondeThemeScope.of(context).colorScheme;
        return FondeColorScopeWidget(
          scope: FondeColorScopeBuilder.dialogScope(colors),
          child: child,
        );
      },
    );
  }

  static Widget withCustomScope({
    required Widget child,
    required FondeColorScope scope,
  }) {
    return FondeColorScopeWidget(scope: scope, child: child);
  }
}
