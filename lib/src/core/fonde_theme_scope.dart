import 'dart:ui';

import 'package:flutter/material.dart';

import 'models/fonde_accessibility_config.dart';
import 'models/fonde_color_scheme.dart';
import 'models/fonde_icon_theme.dart';
import 'models/fonde_theme_data.dart';
import 'models/theme_color_scheme.dart';

/// Holds the resolved theme state and propagates it down the widget tree.
///
/// Placed by [FondeApp] at the root of the application. Any descendant widget
/// can read the current theme via [FondeThemeScope.of].
class FondeThemeScope extends InheritedWidget {
  const FondeThemeScope({
    super.key,
    required this.colorScheme,
    required this.accessibilityConfig,
    required this.iconTheme,
    required super.child,
  });

  /// The fully-resolved color scheme for the current theme + brightness + accent color.
  final FondeColorScheme colorScheme;

  /// Accessibility settings (zoom, font, border scales; high-contrast mode).
  final FondeAccessibilityConfig accessibilityConfig;

  /// The active icon theme.
  final FondeIconTheme iconTheme;

  /// Returns the nearest [FondeThemeScope] in the widget tree.
  ///
  /// Throws a [FlutterError] when no [FondeThemeScope] is found. This normally
  /// means the widget is not inside a [FondeApp].
  static FondeThemeScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<FondeThemeScope>();
    assert(
      scope != null,
      'No FondeThemeScope found in the widget tree. '
      'Make sure your widget is inside a FondeApp.',
    );
    return scope!;
  }

  /// Returns the nearest [FondeThemeScope], or `null` if none exists.
  static FondeThemeScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FondeThemeScope>();
  }

  @override
  bool updateShouldNotify(FondeThemeScope oldWidget) {
    return colorScheme != oldWidget.colorScheme ||
        accessibilityConfig != oldWidget.accessibilityConfig ||
        iconTheme != oldWidget.iconTheme;
  }
}

// ---------------------------------------------------------------------------
// Controllers
// ---------------------------------------------------------------------------

/// Controls the active [FondeThemeData].
///
/// Obtain the singleton managed by [FondeApp] via
/// [FondeThemeController.of].
class FondeThemeController extends ChangeNotifier {
  FondeThemeController({required FondeThemeData initialTheme})
    : _theme = initialTheme;

  FondeThemeData _theme;

  FondeThemeData get theme => _theme;

  void setTheme(FondeThemeData newTheme) {
    if (_theme == newTheme) return;
    _theme = newTheme;
    notifyListeners();
  }

  static FondeThemeController of(BuildContext context) {
    final scope =
        context
            .dependOnInheritedWidgetOfExactType<_FondeThemeControllerScope>();
    assert(
      scope != null,
      'No FondeThemeController found. Make sure your widget is inside FondeApp.',
    );
    return scope!.controller;
  }
}

/// Controls the active accent color ([FondeThemeColorType]).
class FondeThemeColorController extends ChangeNotifier {
  FondeThemeColorController({
    FondeThemeColorType initialColor = FondeThemeColorType.blue,
  }) : _themeColor = initialColor;

  FondeThemeColorType _themeColor;

  FondeThemeColorType get themeColor => _themeColor;

  void setThemeColor(FondeThemeColorType type) {
    if (_themeColor == type) return;
    _themeColor = type;
    notifyListeners();
  }

  static FondeThemeColorController of(BuildContext context) {
    final scope =
        context
            .dependOnInheritedWidgetOfExactType<_FondeThemeControllerScope>();
    assert(
      scope != null,
      'No FondeThemeColorController found. Make sure your widget is inside FondeApp.',
    );
    return scope!.colorController;
  }
}

/// Controls [FondeAccessibilityConfig].
class FondeAccessibilityController extends ChangeNotifier {
  FondeAccessibilityController({
    FondeAccessibilityConfig initialConfig = const FondeAccessibilityConfig(),
  }) : _config = initialConfig;

  FondeAccessibilityConfig _config;

  FondeAccessibilityConfig get config => _config;

  void updateConfig(FondeAccessibilityConfig newConfig) {
    if (_config == newConfig) return;
    _config = newConfig;
    notifyListeners();
  }

  static FondeAccessibilityController of(BuildContext context) {
    final scope =
        context
            .dependOnInheritedWidgetOfExactType<_FondeThemeControllerScope>();
    assert(
      scope != null,
      'No FondeAccessibilityController found. Make sure your widget is inside FondeApp.',
    );
    return scope!.accessibilityController;
  }
}

/// Controls the active [FondeIconTheme].
class FondeIconThemeController extends ChangeNotifier {
  FondeIconThemeController({FondeIconTheme? initialTheme})
    : _iconTheme = initialTheme;

  FondeIconTheme? _iconTheme;

  FondeIconTheme? get iconTheme => _iconTheme;

  void setIconTheme(FondeIconTheme theme) {
    _iconTheme = theme;
    notifyListeners();
  }

  static FondeIconThemeController of(BuildContext context) {
    final scope =
        context
            .dependOnInheritedWidgetOfExactType<_FondeThemeControllerScope>();
    assert(
      scope != null,
      'No FondeIconThemeController found. Make sure your widget is inside FondeApp.',
    );
    return scope!.iconThemeController;
  }
}

// ---------------------------------------------------------------------------
// Internal InheritedWidget that exposes controllers
// ---------------------------------------------------------------------------

class _FondeThemeControllerScope extends InheritedWidget {
  const _FondeThemeControllerScope({
    required this.controller,
    required this.colorController,
    required this.accessibilityController,
    required this.iconThemeController,
    required super.child,
  });

  final FondeThemeController controller;
  final FondeThemeColorController colorController;
  final FondeAccessibilityController accessibilityController;
  final FondeIconThemeController iconThemeController;

  @override
  bool updateShouldNotify(_FondeThemeControllerScope oldWidget) {
    return controller != oldWidget.controller ||
        colorController != oldWidget.colorController ||
        accessibilityController != oldWidget.accessibilityController ||
        iconThemeController != oldWidget.iconThemeController;
  }
}

// ---------------------------------------------------------------------------
// FondeThemeManager – StatefulWidget that owns controllers and builds the scope
// ---------------------------------------------------------------------------

/// Internal widget used by [FondeApp] to own and rebuild [FondeThemeScope]
/// whenever any controller changes.
class FondeThemeManager extends StatefulWidget {
  const FondeThemeManager({
    super.key,
    required this.themeController,
    required this.colorController,
    required this.accessibilityController,
    required this.iconThemeController,
    required this.defaultIconTheme,
    required this.child,
  });

  final FondeThemeController themeController;
  final FondeThemeColorController colorController;
  final FondeAccessibilityController accessibilityController;
  final FondeIconThemeController iconThemeController;
  final FondeIconTheme defaultIconTheme;
  final Widget child;

  @override
  State<FondeThemeManager> createState() => _FondeThemeManagerState();
}

class _FondeThemeManagerState extends State<FondeThemeManager>
    with WidgetsBindingObserver {
  Brightness _platformBrightness =
      PlatformDispatcher.instance.platformBrightness;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.themeController.addListener(_onThemeChanged);
    widget.colorController.addListener(_onThemeChanged);
    widget.accessibilityController.addListener(_onThemeChanged);
    widget.iconThemeController.addListener(_onThemeChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(FondeThemeManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.themeController != widget.themeController) {
      oldWidget.themeController.removeListener(_onThemeChanged);
      widget.themeController.addListener(_onThemeChanged);
    }
    if (oldWidget.colorController != widget.colorController) {
      oldWidget.colorController.removeListener(_onThemeChanged);
      widget.colorController.addListener(_onThemeChanged);
    }
    if (oldWidget.accessibilityController != widget.accessibilityController) {
      oldWidget.accessibilityController.removeListener(_onThemeChanged);
      widget.accessibilityController.addListener(_onThemeChanged);
    }
    if (oldWidget.iconThemeController != widget.iconThemeController) {
      oldWidget.iconThemeController.removeListener(_onThemeChanged);
      widget.iconThemeController.addListener(_onThemeChanged);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.themeController.removeListener(_onThemeChanged);
    widget.colorController.removeListener(_onThemeChanged);
    widget.accessibilityController.removeListener(_onThemeChanged);
    widget.iconThemeController.removeListener(_onThemeChanged);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {
      _platformBrightness = PlatformDispatcher.instance.platformBrightness;
    });
  }

  void _onThemeChanged() {
    setState(() {});
  }

  FondeColorScheme _resolveColorScheme() {
    final themeData = widget.themeController.theme;
    final themeColorType = widget.colorController.themeColor;
    final baseColorScheme = themeData.getEffectiveAppColorScheme(
      _platformBrightness,
    );
    return FondeColorScheme.fromColorScheme(
      baseColorScheme.toColorScheme(),
      themeType: themeColorType,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = _resolveColorScheme();
    final iconTheme =
        widget.iconThemeController.iconTheme ?? widget.defaultIconTheme;

    return _FondeThemeControllerScope(
      controller: widget.themeController,
      colorController: widget.colorController,
      accessibilityController: widget.accessibilityController,
      iconThemeController: widget.iconThemeController,
      child: FondeThemeScope(
        colorScheme: colorScheme,
        accessibilityConfig: widget.accessibilityController.config,
        iconTheme: iconTheme,
        child: widget.child,
      ),
    );
  }
}
