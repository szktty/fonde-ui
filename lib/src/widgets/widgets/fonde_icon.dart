import '../../internal.dart';
import 'package:flutter/material.dart';

import '../accessibility/fonde_accessible_widget.dart';
import '../../core/context_extensions.dart';

/// Icon size presets.
enum FondeIconSize {
  small(16.0),
  medium(20.0),
  standard(24.0),
  large(32.0),
  xlarge(48.0);

  final double value;
  const FondeIconSize(this.value);
}

/// Icon widget compliant with App design system.
class FondeIcon extends FondeAccessibleWidget {
  final IconData icon;
  final FondeIconSize size;
  final double? customSize;
  final FondeIconColor? color;
  final Color? customColor;
  final String? semanticLabel;
  final TextDirection? textDirection;
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
  Widget buildAccessibleWidget({required BuildContext context}) {
    final appColorScheme = context.fondeColorScheme;
    final zoomScale = context.fondeZoomScale;

    final baseSize = customSize ?? size.value;
    final scaledSize = getScaledValue(baseSize, zoomScale);

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
    if (disableSemantics || semanticLabel == null) return child;
    return Semantics(label: semanticLabel, image: true, child: child);
  }

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

enum FondeIconColor {
  primary,
  onSurface,
  onSurfaceVariant,
  error,
  warning,
  success,
  info,
  inactive,
  active,
}

extension FondeIconFactories on FondeIcon {
  static FondeIcon small(
    IconData icon, {
    Key? key,
    FondeIconColor? color,
    Color? customColor,
    String? semanticLabel,
    bool disableZoom = false,
  }) => FondeIcon(
    icon,
    key: key,
    size: FondeIconSize.small,
    color: color,
    customColor: customColor,
    semanticLabel: semanticLabel,
    disableZoom: disableZoom,
  );

  static FondeIcon medium(
    IconData icon, {
    Key? key,
    FondeIconColor? color,
    Color? customColor,
    String? semanticLabel,
    bool disableZoom = false,
  }) => FondeIcon(
    icon,
    key: key,
    size: FondeIconSize.medium,
    color: color,
    customColor: customColor,
    semanticLabel: semanticLabel,
    disableZoom: disableZoom,
  );

  static FondeIcon large(
    IconData icon, {
    Key? key,
    FondeIconColor? color,
    Color? customColor,
    String? semanticLabel,
    bool disableZoom = false,
  }) => FondeIcon(
    icon,
    key: key,
    size: FondeIconSize.large,
    color: color,
    customColor: customColor,
    semanticLabel: semanticLabel,
    disableZoom: disableZoom,
  );

  static FondeIcon xlarge(
    IconData icon, {
    Key? key,
    FondeIconColor? color,
    Color? customColor,
    String? semanticLabel,
    bool disableZoom = false,
  }) => FondeIcon(
    icon,
    key: key,
    size: FondeIconSize.xlarge,
    color: color,
    customColor: customColor,
    semanticLabel: semanticLabel,
    disableZoom: disableZoom,
  );

  static FondeIcon error(
    IconData icon, {
    Key? key,
    FondeIconSize size = FondeIconSize.standard,
    String? semanticLabel,
    bool disableZoom = false,
  }) => FondeIcon(
    icon,
    key: key,
    size: size,
    color: FondeIconColor.error,
    semanticLabel: semanticLabel,
    disableZoom: disableZoom,
  );

  static FondeIcon warning(
    IconData icon, {
    Key? key,
    FondeIconSize size = FondeIconSize.standard,
    String? semanticLabel,
    bool disableZoom = false,
  }) => FondeIcon(
    icon,
    key: key,
    size: size,
    color: FondeIconColor.warning,
    semanticLabel: semanticLabel,
    disableZoom: disableZoom,
  );

  static FondeIcon success(
    IconData icon, {
    Key? key,
    FondeIconSize size = FondeIconSize.standard,
    String? semanticLabel,
    bool disableZoom = false,
  }) => FondeIcon(
    icon,
    key: key,
    size: size,
    color: FondeIconColor.success,
    semanticLabel: semanticLabel,
    disableZoom: disableZoom,
  );
}
