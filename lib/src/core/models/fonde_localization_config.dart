/// Global localization configuration for fonde_ui.
///
/// By default, fonde_ui suppresses automatic localization so that applications
/// without a full localization setup are not unexpectedly presented with
/// non-English text.
///
/// ## Enabling localization
///
/// Set [enableLocalization] to `true` before calling [runApp], or pass
/// `enableLocalization: true` to [FondeApp]:
///
/// ```dart
/// void main() {
///   FondeLocalizationConfig.enableLocalization = true;
///   runApp(FondeApp(...));
/// }
/// ```
///
/// When enabling, also add fonde_ui's delegate to your [MaterialApp]:
///
/// ```dart
/// MaterialApp(
///   localizationsDelegates: [
///     ...FondeUILocalizations.localizationsDelegates,
///   ],
///   supportedLocales: [
///     const Locale('en'),
///     const Locale('ja'),
///   ],
///   home: myShell,
/// );
/// ```
///
/// ## Current scope
///
/// Localization currently applies to the following built-in labels:
///
/// - **[FondePlatformMenus]** — all platform menu bar item labels
///   (App, Edit, File, View, Window menus)
///
/// > **Note:** In a future release, select UI components (e.g. dialogs,
/// > tooltips) will also respect this flag. The flag is intentionally global
/// > so that apps can control all built-in localization from one place.
///
/// ## Per-instance override
///
/// Individual components that support localization also accept an
/// `enableLocalization` parameter that overrides this global setting for
/// that instance only.
class FondeLocalizationConfig {
  FondeLocalizationConfig._();

  /// Whether fonde_ui components automatically adapt their built-in text
  /// labels to the device locale.
  ///
  /// Defaults to `false`. Set to `true` to opt in to localization globally.
  static bool enableLocalization = false;
}
