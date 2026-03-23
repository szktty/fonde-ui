import 'package:flutter/material.dart';

import 'color_scope.dart';
import 'color_scope_widget.dart';
import 'fonde_theme_scope.dart';
import 'models/fonde_accessibility_config.dart';
import 'models/fonde_color_scheme.dart';
import 'models/fonde_icon_theme.dart';

/// Convenience accessors on [BuildContext] for fonde_ui theme data.
///
/// These replace the old Riverpod `ref.watch(...)` calls used inside
/// ConsumerWidgets. Widgets should call these from their `build` method
/// so that they rebuild whenever the underlying [FondeThemeScope] or
/// [FondeColorScopeWidget] changes.
extension FondeThemeContext on BuildContext {
  /// The fully-resolved color scheme for the current theme + accent color.
  FondeColorScheme get fondeColorScheme => FondeThemeScope.of(this).colorScheme;

  /// Current accessibility settings.
  FondeAccessibilityConfig get fondeAccessibility =>
      FondeThemeScope.of(this).accessibilityConfig;

  /// The active icon theme.
  FondeIconTheme get fondeIconTheme => FondeThemeScope.of(this).iconTheme;

  /// The nearest color scope (launch bar, sidebar, dialog, etc.).
  FondeColorScope get fondeColorScope => FondeColorScopeWidget.of(this);

  // -------------------------------------------------------------------------
  // Scaling helpers (mirror of the old WidgetRef extensions)
  // -------------------------------------------------------------------------

  double get fondeZoomScale => fondeAccessibility.zoomScale;
  double get fondeFontScale => fondeAccessibility.fontScale;
  double get fondeBorderScale => fondeAccessibility.borderScale;

  /// Scales [baseValue] by the current zoom scale.
  double fondeScaleValue(double baseValue) =>
      baseValue * fondeAccessibility.zoomScale;

  /// Scales [baseFontSize] by the current font scale.
  double fondeScaleFontSize(double baseFontSize) =>
      baseFontSize * fondeAccessibility.fontScale;

  /// Scales [baseWidth] by the current border scale.
  double fondeScaleBorderWidth(double baseWidth) =>
      baseWidth * fondeAccessibility.borderScale;

  /// Scales each component of [base] by the current zoom scale.
  EdgeInsets fondeScaleEdgeInsets(EdgeInsets base) {
    final scale = fondeAccessibility.zoomScale;
    return EdgeInsets.only(
      left: base.left * scale,
      top: base.top * scale,
      right: base.right * scale,
      bottom: base.bottom * scale,
    );
  }

  /// Scales each corner of [base] by the current zoom scale.
  BorderRadius fondeScaleBorderRadius(BorderRadius base) {
    final scale = fondeAccessibility.zoomScale;
    return BorderRadius.only(
      topLeft: base.topLeft * scale,
      topRight: base.topRight * scale,
      bottomLeft: base.bottomLeft * scale,
      bottomRight: base.bottomRight * scale,
    );
  }

  /// Scales [base] dimensions by the current zoom scale.
  Size fondeScaleSize(Size base) {
    final scale = fondeAccessibility.zoomScale;
    return Size(base.width * scale, base.height * scale);
  }

  // -------------------------------------------------------------------------
  // Controller accessors
  // -------------------------------------------------------------------------

  /// The active theme controller owned by the nearest [FondeApp].
  FondeThemeController get fondeThemeController =>
      FondeThemeController.of(this);

  /// The accent-color controller owned by the nearest [FondeApp].
  FondeThemeColorController get fondeThemeColorController =>
      FondeThemeColorController.of(this);

  /// The accessibility controller owned by the nearest [FondeApp].
  FondeAccessibilityController get fondeAccessibilityController =>
      FondeAccessibilityController.of(this);

  /// The icon-theme controller owned by the nearest [FondeApp].
  FondeIconThemeController get fondeIconThemeController =>
      FondeIconThemeController.of(this);
}
