import '../../internal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../accessibility/fonde_accessible_widget.dart';

/// Icon size presets.
enum FondeIconSize {
  /// 16px - Inline icons, small buttons.
  small(16.0),

  /// 20px - Form fields, list items.
  medium(20.0),

  /// 24px - Standard buttons, navigation (default).
  standard(24.0),

  /// 32px - Large buttons, header icons.
  large(32.0),

  /// 48px - Main actions, landing elements.
  xlarge(48.0);

  final double value;
  const FondeIconSize(this.value);
}

/// Icon widget compliant with App design system.
///
/// Automatically applies zoom support and theme colors.
///
/// ```dart
/// // Basic usage
/// FondeIcon(FondeIcons.search)
///
/// // Specify size and color
/// FondeIcon(
///   FondeIcons.settings,
///   size: FondeIconSize.large,
///   color: FondeIconColor.primary,
/// )
///
/// // Custom size and color
/// FondeIcon(
///   FondeIcons.check,
///   customSize: 28.0,
///   customColor: Colors.green,
/// )
/// ```
class FondeIcon extends FondeAccessibleWidget {
  /// Icon data (selected from FondeIcons).
  final IconData icon;

  /// Preset size.
  final FondeIconSize size;

  /// Custom size (takes precedence over preset).
  final double? customSize;

  /// Semantic color (automatically obtained from theme).
  final FondeIconColor? color;

  /// Custom color (takes precedence over semantic color).
  final Color? customColor;

  /// Semantic label (for accessibility).
  final String? semanticLabel;

  /// Text direction.
  final TextDirection? textDirection;

  /// List of shadows.
  final List<Shadow>? shadows;

  const FondeIcon(
    this.icon, {
    super.key,
    this.size = FondeIconSize.standard,
    this.customSize,
    this.color,
    this.customColor,
    this.semanticLabel,
    this.textDirection,
    this.shadows,
    super.disableZoom,
    super.disableSemantics,
  });

  @override
  Widget buildAccessibleWidget({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final appColorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(fondeAccessibilityConfigProvider);

    // Determine size (custom > preset)
    final baseSize = customSize ?? size.value;
    final scaledSize = getScaledValue(baseSize, accessibilityConfig.zoomScale);

    // Determine color (custom > semantic > default)
    final iconColor =
        customColor ??
        (color != null ? _getSemanticColor(color!, appColorScheme) : null) ??
        appColorScheme.base.foreground;

    return Icon(
      icon,
      size: scaledSize,
      color: iconColor,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
      shadows: shadows,
    );
  }

  @override
  Widget buildSemantics(BuildContext context, Widget child) {
    if (disableSemantics || semanticLabel == null) {
      return child;
    }

    return Semantics(label: semanticLabel, image: true, child: child);
  }

  /// Get FondeColorScheme color from semantic color
  Color _getSemanticColor(FondeIconColor color, FondeColorScheme colorScheme) {
    switch (color) {
      case FondeIconColor.primary:
        return colorScheme.theme.primaryColor;
      case FondeIconColor.onSurface:
        return colorScheme.base.foreground;
      case FondeIconColor.onSurfaceVariant:
        return colorScheme.base.foreground;
      case FondeIconColor.error:
        return colorScheme.status.error;
      case FondeIconColor.warning:
        return colorScheme.status.warning;
      case FondeIconColor.success:
        return colorScheme.status.success;
      case FondeIconColor.info:
        return colorScheme.status.info;
      case FondeIconColor.inactive:
        return colorScheme.uiAreas.sideBar.inactiveItemText;
      case FondeIconColor.active:
        return colorScheme.uiAreas.sideBar.activeItemText;
    }
  }
}

/// Semantic color for icons.
enum FondeIconColor {
  /// Primary color (accent, important actions).
  primary,

  /// Standard content color.
  onSurface,

  /// Auxiliary content color.
  onSurfaceVariant,

  /// Error state.
  error,

  /// Warning state.
  warning,

  /// Success state.
  success,

  /// Information display.
  info,

  /// Inactive state (e.g., sidebar).
  inactive,

  /// Active state (e.g., sidebar).
  active,
}

/// Shortcut factory methods.
extension FondeIconFactories on FondeIcon {
  /// Small icon (16px).
  static FondeIcon small(
    IconData icon, {
    Key? key,
    FondeIconColor? color,
    Color? customColor,
    String? semanticLabel,
    bool disableZoom = false,
  }) {
    return FondeIcon(
      icon,
      key: key,
      size: FondeIconSize.small,
      color: color,
      customColor: customColor,
      semanticLabel: semanticLabel,
      disableZoom: disableZoom,
    );
  }

  /// Medium icon (20px).
  static FondeIcon medium(
    IconData icon, {
    Key? key,
    FondeIconColor? color,
    Color? customColor,
    String? semanticLabel,
    bool disableZoom = false,
  }) {
    return FondeIcon(
      icon,
      key: key,
      size: FondeIconSize.medium,
      color: color,
      customColor: customColor,
      semanticLabel: semanticLabel,
      disableZoom: disableZoom,
    );
  }

  /// Large icon (32px).
  static FondeIcon large(
    IconData icon, {
    Key? key,
    FondeIconColor? color,
    Color? customColor,
    String? semanticLabel,
    bool disableZoom = false,
  }) {
    return FondeIcon(
      icon,
      key: key,
      size: FondeIconSize.large,
      color: color,
      customColor: customColor,
      semanticLabel: semanticLabel,
      disableZoom: disableZoom,
    );
  }

  /// Extra large icon (48px).
  static FondeIcon xlarge(
    IconData icon, {
    Key? key,
    FondeIconColor? color,
    Color? customColor,
    String? semanticLabel,
    bool disableZoom = false,
  }) {
    return FondeIcon(
      icon,
      key: key,
      size: FondeIconSize.xlarge,
      color: color,
      customColor: customColor,
      semanticLabel: semanticLabel,
      disableZoom: disableZoom,
    );
  }

  /// Error icon.
  static FondeIcon error(
    IconData icon, {
    Key? key,
    FondeIconSize size = FondeIconSize.standard,
    String? semanticLabel,
    bool disableZoom = false,
  }) {
    return FondeIcon(
      icon,
      key: key,
      size: size,
      color: FondeIconColor.error,
      semanticLabel: semanticLabel,
      disableZoom: disableZoom,
    );
  }

  /// Warning icon.
  static FondeIcon warning(
    IconData icon, {
    Key? key,
    FondeIconSize size = FondeIconSize.standard,
    String? semanticLabel,
    bool disableZoom = false,
  }) {
    return FondeIcon(
      icon,
      key: key,
      size: size,
      color: FondeIconColor.warning,
      semanticLabel: semanticLabel,
      disableZoom: disableZoom,
    );
  }

  /// Success icon.
  static FondeIcon success(
    IconData icon, {
    Key? key,
    FondeIconSize size = FondeIconSize.standard,
    String? semanticLabel,
    bool disableZoom = false,
  }) {
    return FondeIcon(
      icon,
      key: key,
      size: size,
      color: FondeIconColor.success,
      semanticLabel: semanticLabel,
      disableZoom: disableZoom,
    );
  }
}
