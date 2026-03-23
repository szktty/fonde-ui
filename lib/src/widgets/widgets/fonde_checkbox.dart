import 'package:flutter/material.dart';
import '../../core/context_extensions.dart';
import '../../internal.dart';
import 'package:figma_squircle/figma_squircle.dart';
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
class FondeCheckbox extends StatefulWidget {
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
  State<FondeCheckbox> createState() => _FondeCheckboxState();
}

class _FondeCheckboxState extends State<FondeCheckbox> {
  bool _isPressed = false;

  void _handleTap() {
    if (widget.onChanged == null) return;
    if (widget.tristate) {
      if (widget.value == false) {
        widget.onChanged!(true);
      } else if (widget.value == true) {
        widget.onChanged!(null);
      } else {
        widget.onChanged!(false);
      }
    } else {
      widget.onChanged!(!(widget.value ?? false));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final accessibilityConfig = context.fondeAccessibility;
    final iconTheme = context.fondeIconTheme;

    final zoomScale = widget.disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale =
        widget.disableZoom ? 1.0 : accessibilityConfig.borderScale;
    final effectiveSize = (widget.size ?? 20.0) * zoomScale;

    final isChecked = widget.value == true;
    final isIndeterminate = widget.value == null && widget.tristate;
    final isActive = isChecked || isIndeterminate;
    final isEnabled = widget.onChanged != null;

    // Press highlight applies only when unchecked/indeterminate is not active.
    final pressColor = appColorScheme.interactive.button.background.active;

    final Color backgroundColor;
    final Color borderColor;
    final Color iconColor;

    switch (widget.fillStyle) {
      case FondeCheckboxFillStyle.filled:
        backgroundColor =
            isActive
                ? appColorScheme.theme.primaryColor
                : _isPressed
                ? pressColor
                : const Color(0x00000000);
        borderColor =
            isActive
                ? appColorScheme.theme.primaryColor
                : appColorScheme.base.border;
        iconColor = appColorScheme.interactive.button.primaryText;
      case FondeCheckboxFillStyle.outline:
        backgroundColor =
            _isPressed && !isActive ? pressColor : const Color(0x00000000);
        borderColor =
            isActive
                ? appColorScheme.theme.primaryColor
                : appColorScheme.base.border;
        iconColor = appColorScheme.theme.primaryColor;
      case FondeCheckboxFillStyle.iconOnly:
        backgroundColor =
            _isPressed && !isActive ? pressColor : const Color(0x00000000);
        borderColor = appColorScheme.base.border;
        iconColor = appColorScheme.theme.primaryColor;
    }

    final ShapeBorder shapeBorder;
    if (widget.shape == FondeCheckboxShape.circle) {
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
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: isEnabled ? _handleTap : null,
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        child: Semantics(
          label: widget.semanticLabel,
          checked: widget.value,
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
