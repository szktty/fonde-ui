import 'package:flutter/material.dart';
import '../../internal.dart';
import '../styling/fonde_border_radius.dart';
import 'fonde_gesture_detector.dart';

/// Shape of the icon button
enum FondeIconButtonShape {
  /// Rectangle (rounded corners)
  rectangle,

  /// Circular
  circle,
}

/// App common IconButton
///
/// A custom icon button that uses FondeGestureDetector for immediate press
/// feedback without ripple effects, consistent with FondeButton behavior.
class FondeIconButton extends StatefulWidget {
  /// Icon
  final IconData icon;

  /// Callback when the button is pressed
  final VoidCallback? onPressed;

  /// Icon size
  final double? iconSize;

  /// Icon color (uses theme color if not specified)
  final Color? iconColor;

  /// Background color of the button (transparent if not specified)
  final Color? backgroundColor;

  /// Background color on hover
  final Color? hoverColor;

  /// Background color on press
  final Color? pressedColor;

  /// Color when disabled
  final Color? disabledColor;

  /// Tooltip
  final String? tooltip;

  /// Enabled/disabled state
  final bool enabled;

  /// Padding
  final EdgeInsetsGeometry? padding;

  /// Alignment
  final AlignmentGeometry alignment;

  /// Focus node
  final FocusNode? focusNode;

  /// Corner radius (uses FondeBorderRadiusValues.medium if not specified)
  final double? cornerRadius;

  /// Border settings
  final BorderSide? border;

  /// Button size constraints
  final BoxConstraints? constraints;

  /// Button shape (rectangle or circle)
  final FondeIconButtonShape shape;

  /// Constructor
  const FondeIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconSize,
    this.iconColor,
    this.backgroundColor,
    this.hoverColor,
    this.pressedColor,
    this.disabledColor,
    this.tooltip,
    this.enabled = true,
    this.padding,
    this.alignment = Alignment.center,
    this.focusNode,
    this.cornerRadius,
    this.border,
    this.constraints,
    this.shape = FondeIconButtonShape.rectangle,
  });

  /// Compact icon button (minimum padding)
  const FondeIconButton.compact({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconSize,
    this.iconColor,
    this.backgroundColor,
    this.hoverColor,
    this.pressedColor,
    this.disabledColor,
    this.tooltip,
    this.enabled = true,
    this.padding,
    this.alignment = Alignment.center,
    this.focusNode,
    this.cornerRadius,
    this.border,
    this.shape = FondeIconButtonShape.rectangle,
  }) : constraints = const BoxConstraints(minWidth: 24, minHeight: 24);

  /// Minimal icon button (no padding)
  const FondeIconButton.minimal({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconSize,
    this.iconColor,
    this.backgroundColor,
    this.hoverColor,
    this.pressedColor,
    this.disabledColor,
    this.tooltip,
    this.enabled = true,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.center,
    this.focusNode,
    this.cornerRadius,
    this.border,
    this.shape = FondeIconButtonShape.rectangle,
  }) : constraints = const BoxConstraints();

  /// Circular icon button
  const FondeIconButton.circle({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconSize,
    this.iconColor,
    this.backgroundColor,
    this.hoverColor,
    this.pressedColor,
    this.disabledColor,
    this.tooltip,
    this.enabled = true,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.center,
    this.focusNode,
    this.cornerRadius,
    this.border,
    this.constraints,
  }) : shape = FondeIconButtonShape.circle;

  @override
  State<FondeIconButton> createState() => _FondeIconButtonState();
}

class _FondeIconButtonState extends State<FondeIconButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final zoomScale = context.fondeZoomScale;

    final effectiveIconSize =
        widget.iconSize != null ? widget.iconSize! * zoomScale : null;
    final effectiveCornerRadius =
        widget.cornerRadius ?? FondeBorderRadiusValues.medium;

    final effectiveIconColor =
        widget.enabled
            ? (widget.iconColor ?? appColorScheme.base.foreground)
            : (widget.disabledColor ??
                appColorScheme.interactive.button.border.disabled);

    Color effectiveBackgroundColor;
    if (!widget.enabled) {
      effectiveBackgroundColor = Colors.transparent;
    } else if (_isPressed) {
      effectiveBackgroundColor =
          widget.pressedColor ??
          appColorScheme.interactive.button.background.active;
    } else if (_isHovered) {
      effectiveBackgroundColor =
          widget.hoverColor ??
          appColorScheme.interactive.list.itemBackground.hover;
    } else {
      effectiveBackgroundColor = widget.backgroundColor ?? Colors.transparent;
    }

    final borderSide =
        widget.border ?? const BorderSide(style: BorderStyle.none);
    final ShapeBorder buttonShape = switch (widget.shape) {
      FondeIconButtonShape.circle => CircleBorder(side: borderSide),
      FondeIconButtonShape.rectangle => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(effectiveCornerRadius),
        side: borderSide,
      ),
    };

    Widget content = Container(
      constraints: widget.constraints,
      padding: widget.padding ?? EdgeInsets.all(8 * zoomScale),
      alignment: widget.alignment,
      decoration: ShapeDecoration(
        color: effectiveBackgroundColor,
        shape: buttonShape,
      ),
      child: Icon(
        widget.icon,
        size: effectiveIconSize,
        color: effectiveIconColor,
      ),
    );

    if (widget.tooltip != null) {
      content = Tooltip(message: widget.tooltip!, child: content);
    }

    return FondeGestureDetector(
      behavior: HitTestBehavior.opaque,
      cursor: widget.enabled ? SystemMouseCursors.click : MouseCursor.defer,
      onTapDown:
          widget.enabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp:
          widget.enabled
              ? (_) {
                setState(() => _isPressed = false);
                widget.onPressed?.call();
              }
              : null,
      onTap: null,
      onHover:
          widget.enabled
              ? (hovered) => setState(() => _isHovered = hovered)
              : null,
      child: content,
    );
  }
}
