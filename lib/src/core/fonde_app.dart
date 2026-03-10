import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

import 'models/fonde_localization_config.dart';
import 'models/fonde_theme_data.dart';
import 'presets.dart';
import 'providers/theme_providers.dart';

/// The root widget for a fonde_ui application.
///
/// [FondeApp] wraps [ProviderScope] and [MaterialApp] to provide the minimum
/// boilerplate required to use fonde_ui. Place it at the top of your widget
/// tree instead of calling [MaterialApp] directly.
///
/// ```dart
/// void main() {
///   runApp(
///     FondeApp(
///       title: 'My App',
///       initialTheme: FondeThemePresets.dark,
///       home: MyShell(),
///     ),
///   );
/// }
/// ```
///
/// ## Provider overrides
///
/// Use [overrides] to inject custom Riverpod providers (e.g. for dependency
/// injection or testing). This list is forwarded directly to the internal
/// [ProviderScope].
///
/// > **Warning:** Do not override fonde_ui's internal providers (those not
/// > exported as part of the public API). Doing so may cause undefined
/// > behaviour.
///
/// ```dart
/// FondeApp(
///   overrides: [
///     mySettingsProvider.overrideWith(() => MySettingsNotifier()),
///   ],
///   home: MyShell(),
/// )
/// ```
///
/// ## Theme
///
/// Set [initialTheme] to control the starting theme. The theme can be changed
/// at runtime via `FondeActiveThemeNotifier` (Riverpod) or through
/// [FondeApp.setTheme].
///
/// ## Navigation
///
/// fonde_ui targets desktop applications where view switching is handled by
/// [FondeScaffold] (sidebar selection, tab views, etc.) rather than Flutter's
/// [Navigator]. Accordingly, navigation-related [MaterialApp] parameters such
/// as `routes`, `navigatorKey`, and `onGenerateRoute` are intentionally not
/// exposed. If you need deep Navigator integration, compose [MaterialApp]
/// yourself and use [FondeScaffold] as its `home`.
class FondeApp extends StatelessWidget {
  const FondeApp({
    super.key,
    this.title = '',
    this.initialTheme,
    this.overrides = const [],
    this.enableLocalization,
    required this.home,
  });

  /// The title of the application (passed to [MaterialApp]).
  final String title;

  /// The initial theme. Defaults to [FondeThemePresets.system].
  final FondeThemeData? initialTheme;

  /// Riverpod provider overrides forwarded to the internal [ProviderScope].
  ///
  /// Use this for dependency injection or testing. Do **not** override
  /// fonde_ui's internal providers.
  final List<Override> overrides;

  /// Whether fonde_ui components automatically adapt their built-in text
  /// labels to the device locale.
  ///
  /// When set, this value is written to [FondeLocalizationConfig.enableLocalization]
  /// during [build], overriding any value set before [runApp].
  /// When `null` (the default), [FondeLocalizationConfig.enableLocalization]
  /// is left unchanged.
  ///
  /// See [FondeLocalizationConfig] for the full list of affected components.
  final bool? enableLocalization;

  /// The widget to show as the application's primary view.
  ///
  /// Typically a [FondeScaffold] or a widget that contains one.
  final Widget home;

  @override
  Widget build(BuildContext context) {
    if (enableLocalization != null) {
      FondeLocalizationConfig.enableLocalization = enableLocalization!;
    }
    final effectiveInitialTheme = initialTheme ?? FondeThemePresets.system;

    return ProviderScope(
      overrides: [
        // Seed the active theme with the caller-supplied initial value.
        fondeActiveThemeProvider.overrideWith(
          () => _InitialThemeNotifier(effectiveInitialTheme),
        ),
        ...overrides,
      ],
      child: _FondeAppBody(title: title, home: home),
    );
  }
}

/// [FondeActiveTheme] subclass that uses a caller-supplied initial theme.
class _InitialThemeNotifier extends FondeActiveTheme {
  _InitialThemeNotifier(this._initialTheme);

  final FondeThemeData _initialTheme;

  @override
  FondeThemeData build() => _initialTheme;
}

class _FondeAppBody extends ConsumerWidget {
  const _FondeAppBody({required this.title, required this.home});

  final String title;
  final Widget home;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = ref.watch(fondeEffectiveThemeDataProvider);

    return MaterialApp(
      title: title,
      theme: themeData,
      debugShowCheckedModeBanner: false,
      home: home,
    );
  }
}
