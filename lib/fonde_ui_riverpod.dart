/// Riverpod integration for fonde_ui — DEPRECATED.
///
/// This library is no longer maintained. Riverpod has been removed from fonde_ui.
/// All state management is now available directly via BuildContext extensions
/// and controller objects exported from [fonde_ui.dart].
///
/// Migration guide:
/// - Replace `ref.watch(fondeEffectiveColorSchemeProvider)` with `context.fondeColorScheme`
/// - Replace `ref.watch(fondeAccessibilityConfigProvider)` with `context.fondeAccessibility`
/// - Replace `ref.read(fondeActiveThemeProvider.notifier).setTheme(x)` with
///   `context.fondeThemeController?.setTheme(x)`
/// - Replace `ref.read(fondeAccessibilityConfigProvider.notifier).updateConfig(x)` with
///   `context.fondeAccessibilityController?.updateConfig(x)`
/// - Replace sidebar providers with [FondeSidebarControllerScope]
/// - Replace navigation providers with [FondeNavigationControllerScope]
/// - Replace toolbar providers with [FondeToolbarControllerScope]
/// - Replace search providers with [FondeSearchControllerScope]
library;
