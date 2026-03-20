import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal.dart';
import 'package:figma_squircle/figma_squircle.dart';
import '../icons/icon_theme_providers.dart';
import 'fonde_rectangle_border.dart';

/// Shape of [FondeCheckbox].
enum FondeCheckboxShape {
  /// Rounded rectangle (squircle).
  rectangle,

  /// Circle.
  circle,
}

/// Fill style of [FondeCheckbox].
enum FondeCheckboxFillStyle {
  /// Background is filled with the primary color when checked (default, macOS style).
  /// Most accessible: state is conveyed by surface area, not stroke alone.
  filled,

  /// No background fill; border changes to primary color and check icon is shown
  /// in primary color (Figma style).
  outline,

  /// No background fill, no border color change; only the check icon is colored
  /// with the primary color. Lightest visual weight.
  iconOnly,
}

/// Common Checkbox for Fonde UI.
///
/// Provides a unified Checkbox style across the app.
/// Features smooth corners (rectangle) or circle shape,
/// and uses [FondeIconTheme.check] / [FondeIconTheme.checkIndeterminate]
/// for the check icons.
class FondeCheckbox extends ConsumerWidget {
  /// Value of the checkbox.
  final bool? value;

  /// Callback when the value changes.
  final ValueChanged<bool?>? onChanged;

  /// Whether the checkbox has three states.
  final bool tristate;

  /// Size of the checkbox.
  final double? size;

  /// Shape of the checkbox.
  final FondeCheckboxShape shape;

  /// Fill style of the checkbox.
  final FondeCheckboxFillStyle fillStyle;

  /// Focus node of the checkbox.
  final FocusNode? focusNode;

  /// Whether the checkbox autofocuses.
  final bool autofocus;

  /// Semantic label.
  final String? semanticLabel;

  /// Whether to disable zoom functionality.
  final bool disableZoom;

  const FondeCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.tristate = false,
    this.size,
    this.shape = FondeCheckboxShape.rectangle,
    this.fillStyle = FondeCheckboxFillStyle.filled,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeWithThemeProvider);
    final accessibilityConfig = ref.watch(fondeAccessibilityConfigProvider);
    final iconTheme = ref.watch(fondeDefaultIconThemeProvider);

    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = disableZoom ? 1.0 : accessibilityConfig.borderScale;
    final effectiveSize = (size ?? 20.0) * zoomScale;

    final isChecked = value == true;
    final isIndeterminate = value == null && tristate;
    final isActive = isChecked || isIndeterminate;

    final Color backgroundColor;
    final Color borderColor;
    final Color iconColor;

    switch (fillStyle) {
      case FondeCheckboxFillStyle.filled:
        backgroundColor =
            isActive
                ? appColorScheme.theme.primaryColor
                : const Color(0x00000000);
        borderColor =
            isActive
                ? appColorScheme.theme.primaryColor
                : appColorScheme.base.border;
        iconColor = appColorScheme.interactive.button.primaryText;
      case FondeCheckboxFillStyle.outline:
        // No fill; border and icon use primary color when active.
        backgroundColor = const Color(0x00000000);
        borderColor =
            isActive
                ? appColorScheme.theme.primaryColor
                : appColorScheme.base.border;
        iconColor = appColorScheme.theme.primaryColor;
      case FondeCheckboxFillStyle.iconOnly:
        // No fill, no border color change; only the icon is colored.
        backgroundColor = const Color(0x00000000);
        borderColor = appColorScheme.base.border;
        iconColor = appColorScheme.theme.primaryColor;
    }

    final ShapeBorder shapeBorder;
    if (shape == FondeCheckboxShape.circle) {
      shapeBorder = CircleBorder(
        side: BorderSide(color: borderColor, width: 1.5 * borderScale),
      );
    } else {
      final borderRadius = FondeBorderRadius.create(
        cornerRadius: 4.0 * zoomScale,
        cornerSmoothing: 0.6,
      );
      shapeBorder = SmoothRectangleBorder(
        borderRadius: borderRadius.toSmoothBorderRadius(),
        side: BorderSide(color: borderColor, width: 1.5 * borderScale),
      );
    }

    Widget? innerIcon;
    if (isChecked) {
      innerIcon = Icon(
        iconTheme.check,
        size: effectiveSize * iconTheme.checkboxIconSizeRatio,
        color: iconColor,
      );
    } else if (isIndeterminate) {
      innerIcon = Icon(
        iconTheme.checkIndeterminate,
        size: effectiveSize * iconTheme.checkboxIconSizeRatio,
        color: iconColor,
      );
    }

    return GestureDetector(
      onTap:
          onChanged != null
              ? () {
                if (tristate) {
                  // false -> true -> null -> false
                  if (value == false) {
                    onChanged!(true);
                  } else if (value == true) {
                    onChanged!(null);
                  } else {
                    onChanged!(false);
                  }
                } else {
                  // false -> true -> false
                  onChanged!(!(value ?? false));
                }
              }
              : null,
      child: Focus(
        focusNode: focusNode,
        autofocus: autofocus,
        child: Semantics(
          label: semanticLabel,
          checked: value,
          child: Container(
            width: effectiveSize,
            height: effectiveSize,
            decoration: ShapeDecoration(
              color: backgroundColor,
              shape: shapeBorder,
            ),
            child: innerIcon,
          ),
        ),
      ),
    );
  }
}
