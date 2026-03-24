import 'package:flutter/material.dart';
import '../../internal.dart';
import '../../core/context_extensions.dart';
import '../styling/fonde_border_radius.dart';
import '../typography/fonde_text.dart';

/// A rich-content tooltip that supports keybinding display, multi-line content,
/// and structured title + body layout.
///
/// Replaces plain-string tooltip usage in button widgets.
///
/// Example:
/// ```dart
/// FondeTooltip(
///   title: 'Save',
///   shortcut: '⌘S',
///   child: myButton,
/// )
///
/// FondeTooltip(
///   title: 'Format Selection',
///   description: 'Applies automatic code formatting to the selected region.',
///   shortcut: '⌘⇧F',
///   child: myButton,
/// )
/// ```
class FondeTooltip extends StatelessWidget {
  const FondeTooltip({
    super.key,
    required this.child,
    required this.title,
    this.description,
    this.shortcut,
    this.waitDuration = const Duration(milliseconds: 600),
    this.preferBelow = true,
    this.disableZoom = false,
  });

  /// The widget that triggers the tooltip on hover.
  final Widget child;

  /// Primary label shown in the tooltip.
  final String title;

  /// Optional additional description below the title.
  final String? description;

  /// Optional keyboard shortcut displayed on the right side (e.g. '⌘S', 'Ctrl+N').
  final String? shortcut;

  /// How long the pointer must hover before the tooltip appears.
  final Duration waitDuration;

  /// Whether the tooltip should prefer to appear below the target.
  final bool preferBelow;

  /// Whether to disable zoom scaling.
  final bool disableZoom;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.fondeColorScheme;
    final zoomScale = disableZoom ? 1.0 : context.fondeZoomScale;
    return Tooltip(
      waitDuration: waitDuration,
      preferBelow: preferBelow,
      richMessage: WidgetSpan(
        child: _FondeTooltipContent(
          title: title,
          description: description,
          shortcut: shortcut,
          disableZoom: disableZoom,
        ),
      ),
      decoration: _FondeTooltipDecoration(
        background: colorScheme.uiAreas.dialog.background,
        border: colorScheme.base.border,
        radius: FondeBorderRadiusValues.small * zoomScale,
      ),
      child: child,
    );
  }
}

/// Internal tooltip content widget.
class _FondeTooltipContent extends StatelessWidget {
  const _FondeTooltipContent({
    required this.title,
    this.description,
    this.shortcut,
    required this.disableZoom,
  });

  final String title;
  final String? description;
  final String? shortcut;
  final bool disableZoom;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.fondeColorScheme;
    final zoomScale = disableZoom ? 1.0 : context.fondeZoomScale;

    final foreground = colorScheme.base.foreground;
    final mutedForeground = foreground.withValues(alpha: 0.65);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 240.0 * zoomScale),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: FondeText(
                  title,
                  variant: FondeTextVariant.captionText,
                  color: foreground,
                  disableZoom: disableZoom,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (shortcut != null) ...[
                SizedBox(width: 8.0 * zoomScale),
                _ShortcutBadge(
                  shortcut: shortcut!,
                  zoomScale: zoomScale,
                  foreground: mutedForeground,
                ),
              ],
            ],
          ),
          if (description != null) ...[
            SizedBox(height: 4.0 * zoomScale),
            FondeText(
              description!,
              variant: FondeTextVariant.smallText,
              color: mutedForeground,
              disableZoom: disableZoom,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

/// Badge that displays a keyboard shortcut string.
class _ShortcutBadge extends StatelessWidget {
  const _ShortcutBadge({
    required this.shortcut,
    required this.zoomScale,
    required this.foreground,
  });

  final String shortcut;
  final double zoomScale;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4.0 * zoomScale,
        vertical: 1.0 * zoomScale,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0 * zoomScale),
        border: Border.all(color: foreground.withValues(alpha: 0.4)),
      ),
      child: Text(
        shortcut,
        style: TextStyle(
          fontSize: 10.0 * zoomScale,
          color: foreground,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

/// Custom tooltip decoration using fonde theme colors.
class _FondeTooltipDecoration extends Decoration {
  const _FondeTooltipDecoration({
    required this.background,
    required this.border,
    required this.radius,
  });

  final Color background;
  final Color border;
  final double radius;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _FondeTooltipPainter(
      background: background,
      border: border,
      radius: radius,
    );
  }
}

class _FondeTooltipPainter extends BoxPainter {
  _FondeTooltipPainter({
    required this.background,
    required this.border,
    required this.radius,
  });

  final Color background;
  final Color border;
  final double radius;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final rect = offset & (configuration.size ?? Size.zero);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    canvas.drawRRect(rRect, Paint()..color = background);
    canvas.drawRRect(
      rRect,
      Paint()
        ..color = border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }
}
