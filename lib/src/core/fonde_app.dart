import 'package:flutter/material.dart';

import '../widgets/color_picker/fonde_eye_dropper.dart';
import '../widgets/icons/lucide_icon_theme.dart';
import 'color_scope_widget.dart';
import 'context_extensions.dart';
import 'fonde_theme_scope.dart';
import 'models/fonde_localization_config.dart';
import 'models/fonde_theme_data.dart';
import 'presets.dart';

/// The root widget for a fonde_ui application.
///
/// [FondeApp] wraps [MaterialApp] and provides the minimum boilerplate
/// required to use fonde_ui. Place it at the top of your widget tree
/// instead of calling [MaterialApp] directly.
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
/// ## Controllers
///
/// The active theme, accent color, accessibility settings and icon theme are
/// managed by controllers that [FondeApp] creates internally. You can supply
/// your own controller instances via the constructor parameters if you need to
/// drive them from outside the widget tree (e.g. for persistence or testing).
///
/// ```dart
/// final themeController = FondeThemeController(
///   initialTheme: FondeThemePresets.dark,
/// );
///
/// FondeApp(
///   themeController: themeController,
///   home: MyShell(),
/// )
/// ```
///
/// Read controllers from any descendant widget via the [BuildContext]
/// extensions:
///
/// ```dart
/// context.fondeThemeController.setTheme(FondeThemePresets.light);
/// context.fondeThemeColorController.setThemeColor(FondeThemeColorType.indigo);
/// context.fondeAccessibilityController.updateConfig(...);
/// ```
///
/// ## Navigation
///
/// fonde_ui targets desktop applications where view switching is handled by
/// [FondeScaffold] (sidebar selection, tab views, etc.) rather than Flutter's
/// [Navigator]. Accordingly, navigation-related [MaterialApp] parameters such
/// as `routes`, `navigatorKey`, and `onGenerateRoute` are intentionally not
/// exposed. If you need deep Navigator integration, compose [MaterialApp]
/// yourself and use [FondeScaffold] as its `home`.
class FondeApp extends StatefulWidget {
  const FondeApp({
    super.key,
    this.title = '',
    this.initialTheme,
    this.themeController,
    this.themeColorController,
    this.accessibilityController,
    this.iconThemeController,
    this.enableLocalization,
    this.enableEyeDropper = false,
    required this.home,
  });

  /// The title of the application (passed to [MaterialApp]).
  final String title;

  /// The initial theme. Defaults to [FondeThemePresets.system].
  ///
  /// Ignored when [themeController] is supplied.
  final FondeThemeData? initialTheme;

  /// Optional external theme controller.
  ///
  /// When `null`, [FondeApp] creates and owns an internal controller seeded
  /// with [initialTheme].
  final FondeThemeController? themeController;

  /// Optional external accent-color controller.
  final FondeThemeColorController? themeColorController;

  /// Optional external accessibility controller.
  final FondeAccessibilityController? accessibilityController;

  /// Optional external icon-theme controller.
  final FondeIconThemeController? iconThemeController;

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

  /// Whether to enable the eyedropper tool globally.
  ///
  /// When `true`, wraps the application in a [FondeEyeDropper], which allows
  /// [FondeEyeDropperButton] and [FondeColorPicker] (with `showEyeDropper:
  /// true`) to sample colors from within the Flutter window.
  ///
  /// Defaults to `false`.
  final bool enableEyeDropper;

  /// The widget to show as the application's primary view.
  ///
  /// Typically a [FondeScaffold] or a widget that contains one.
  final Widget home;

  @override
  State<FondeApp> createState() => _FondeAppState();
}

class _FondeAppState extends State<FondeApp> {
  late FondeThemeController _themeController;
  late FondeThemeColorController _colorController;
  late FondeAccessibilityController _accessibilityController;
  late FondeIconThemeController _iconThemeController;

  bool _ownsThemeController = false;
  bool _ownsColorController = false;
  bool _ownsAccessibilityController = false;
  bool _ownsIconThemeController = false;

  @override
  void initState() {
    super.initState();

    if (widget.enableLocalization != null) {
      FondeLocalizationConfig.enableLocalization = widget.enableLocalization!;
    }

    if (widget.themeController != null) {
      _themeController = widget.themeController!;
    } else {
      _themeController = FondeThemeController(
        initialTheme: widget.initialTheme ?? FondeThemePresets.system,
      );
      _ownsThemeController = true;
    }

    if (widget.themeColorController != null) {
      _colorController = widget.themeColorController!;
    } else {
      _colorController = FondeThemeColorController();
      _ownsColorController = true;
    }

    if (widget.accessibilityController != null) {
      _accessibilityController = widget.accessibilityController!;
    } else {
      _accessibilityController = FondeAccessibilityController();
      _ownsAccessibilityController = true;
    }

    if (widget.iconThemeController != null) {
      _iconThemeController = widget.iconThemeController!;
    } else {
      _iconThemeController = FondeIconThemeController();
      _ownsIconThemeController = true;
    }
  }

  @override
  void didUpdateWidget(FondeApp oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.themeController != oldWidget.themeController) {
      if (_ownsThemeController) _themeController.dispose();
      if (widget.themeController != null) {
        _themeController = widget.themeController!;
        _ownsThemeController = false;
      } else {
        _themeController = FondeThemeController(
          initialTheme: widget.initialTheme ?? FondeThemePresets.system,
        );
        _ownsThemeController = true;
      }
    }

    if (widget.themeColorController != oldWidget.themeColorController) {
      if (_ownsColorController) _colorController.dispose();
      if (widget.themeColorController != null) {
        _colorController = widget.themeColorController!;
        _ownsColorController = false;
      } else {
        _colorController = FondeThemeColorController();
        _ownsColorController = true;
      }
    }

    if (widget.accessibilityController != oldWidget.accessibilityController) {
      if (_ownsAccessibilityController) _accessibilityController.dispose();
      if (widget.accessibilityController != null) {
        _accessibilityController = widget.accessibilityController!;
        _ownsAccessibilityController = false;
      } else {
        _accessibilityController = FondeAccessibilityController();
        _ownsAccessibilityController = true;
      }
    }

    if (widget.iconThemeController != oldWidget.iconThemeController) {
      if (_ownsIconThemeController) _iconThemeController.dispose();
      if (widget.iconThemeController != null) {
        _iconThemeController = widget.iconThemeController!;
        _ownsIconThemeController = false;
      } else {
        _iconThemeController = FondeIconThemeController();
        _ownsIconThemeController = true;
      }
    }
  }

  @override
  void dispose() {
    if (_ownsThemeController) _themeController.dispose();
    if (_ownsColorController) _colorController.dispose();
    if (_ownsAccessibilityController) _accessibilityController.dispose();
    if (_ownsIconThemeController) _iconThemeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FondeThemeManager(
      themeController: _themeController,
      colorController: _colorController,
      accessibilityController: _accessibilityController,
      iconThemeController: _iconThemeController,
      defaultIconTheme: fondeDefaultIconTheme,
      child: _FondeAppBody(
        title: widget.title,
        home: widget.home,
        enableEyeDropper: widget.enableEyeDropper,
        themeController: _themeController,
      ),
    );
  }
}

class _FondeAppBody extends StatelessWidget {
  const _FondeAppBody({
    required this.title,
    required this.home,
    required this.enableEyeDropper,
    required this.themeController,
  });

  final String title;
  final Widget home;
  final bool enableEyeDropper;
  final FondeThemeController themeController;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.fondeColorScheme;

    Widget content = FondeColorScopeWidget(
      scope: FondeColorScopeBuilder.defaultScope(colorScheme),
      child: home,
    );

    if (enableEyeDropper) {
      content = FondeEyeDropper(child: content);
    }

    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        final themeData = themeController.theme;
        return MaterialApp(
          title: title,
          theme: themeData.toThemeData(),
          debugShowCheckedModeBanner: false,
          home: content,
        );
      },
    );
  }
}
