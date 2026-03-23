import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import '../../core/context_extensions.dart';
import '../../internal.dart';
import '../widgets/fonde_gesture_detector.dart';

/// A component that groups and displays buttons.
///
/// This component logically groups and displays related action buttons.
/// Suitable for use in toolbars, etc.
class FondeButtonGroup extends StatelessWidget {
  /// List of buttons.
  final List<Widget> children;

  /// Space between buttons.
  final double spacing;

  /// Background color of the entire group.
  final Color? backgroundColor;

  /// Padding of the group.
  final EdgeInsets padding;

  /// Display direction of the entire group.
  final Axis direction;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  /// Creates a [FondeButtonGroup].
  ///
  /// [children] - A list of buttons to display in the group.
  /// [spacing] - The space between the buttons.
  /// [backgroundColor] - The background color of the entire group.
  /// [padding] - The padding of the group.
  /// [direction] - The display direction of the buttons (horizontal/vertical).
  const FondeButtonGroup({
    super.key,
    required this.children,
    this.spacing = 4.0,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(2.0),
    this.direction = Axis.horizontal,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final zoomScale = disableZoom ? 1.0 : context.fondeZoomScale;
    final borderScale = disableZoom ? 1.0 : context.fondeBorderScale;

    return Container(
      padding: EdgeInsets.all(padding.top * zoomScale),
      decoration: BoxDecoration(
        color: backgroundColor ?? appColorScheme.base.background,
        borderRadius: BorderRadius.circular(8.0 * zoomScale),
        border: Border.all(
          color: appColorScheme.base.border.withValues(alpha: 0.2),
          width: 1.0 * borderScale,
        ),
      ),
      child:
          direction == Axis.horizontal
              ? Row(
                mainAxisSize: MainAxisSize.min,
                children: _addSpacingBetweenChildren(spacing * zoomScale),
              )
              : Column(
                mainAxisSize: MainAxisSize.min,
                children: _addSpacingBetweenChildren(spacing * zoomScale),
              ),
    );
  }

  /// Add space between child widgets.
  List<Widget> _addSpacingBetweenChildren(double scaledSpacing) {
    if (children.isEmpty) return [];

    final result = <Widget>[];

    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);

      // Add space after all but the last child widget.
      if (i < children.length - 1) {
        if (direction == Axis.horizontal) {
          result.add(SizedBox(width: scaledSpacing));
        } else {
          result.add(SizedBox(height: scaledSpacing));
        }
      }
    }

    return result;
  }
}

/// An item for use within a [FondeButtonGroup].
///
/// Supports icon-only, label-only, or icon+label combinations.
class FondeButtonGroupItem extends StatefulWidget {
  /// The icon to display (optional).
  final IconData? icon;

  /// The label to display (optional).
  final String? label;

  /// Callback for when the button is pressed.
  final VoidCallback? onPressed;

  /// Description of the button (tooltip).
  final String? tooltip;

  /// Whether the button is selected.
  final bool isSelected;

  /// The minimum size of the button (used for icon-only items).
  final double size;

  const FondeButtonGroupItem({
    super.key,
    this.icon,
    this.label,
    this.onPressed,
    this.tooltip,
    this.isSelected = false,
    this.size = 36.0,
  }) : assert(icon != null || label != null, 'icon or label must be provided');

  @override
  State<FondeButtonGroupItem> createState() => _FondeButtonGroupItemState();
}

class _FondeButtonGroupItemState extends State<FondeButtonGroupItem> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final rectangleBorder = SmoothRectangleBorder(
      borderRadius: SmoothBorderRadius(
        cornerRadius: 12.0,
        cornerSmoothing: 0.6,
      ),
      side: BorderSide(color: appColorScheme.base.border, width: 1.5),
    );

    final contentColor =
        widget.isSelected
            ? appColorScheme.theme.primaryColor
            : appColorScheme.uiAreas.sideBar.inactiveItemText;

    Color backgroundColor;
    if (_isPressed) {
      backgroundColor = appColorScheme.theme.primaryColor.withValues(
        alpha: 0.3,
      );
    } else if (widget.isSelected) {
      backgroundColor = appColorScheme.theme.primaryColor.withValues(
        alpha: 0.2,
      );
    } else if (_isHovered) {
      backgroundColor = appColorScheme.interactive.list.itemBackground.hover;
    } else {
      backgroundColor = Colors.transparent;
    }

    final hasLabel = widget.label != null;
    final hasIcon = widget.icon != null;

    Widget content;
    if (hasLabel) {
      content = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasIcon) ...[
              Icon(widget.icon, size: 16.0, color: contentColor),
              const SizedBox(width: 4.0),
            ],
            Text(widget.label!, style: TextStyle(color: contentColor)),
          ],
        ),
      );
    } else {
      content = SizedBox(
        width: widget.size,
        height: widget.size,
        child: Align(child: Icon(widget.icon, size: 20.0, color: contentColor)),
      );
    }

    Widget button = FondeGestureDetector(
      behavior: HitTestBehavior.opaque,
      cursor: SystemMouseCursors.click,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onHover: (hovered) => setState(() => _isHovered = hovered),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: rectangleBorder,
        ),
        child: content,
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: button);
    }

    return button;
  }
}
