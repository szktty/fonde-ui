import 'package:flutter/material.dart';
import '../../core/context_extensions.dart';
import '../../internal.dart';
import '../typography/fonde_text.dart';

/// A badge element to be displayed on a navigation item.
class FondeNavigationBadge extends StatelessWidget {
  /// The text to display on the badge.
  final String? text;

  /// The background color of the badge.
  final Color? backgroundColor;

  /// The text color of the badge.
  final Color? textColor;

  /// The size of the badge.
  final double size;

  /// Whether to display "99+" when the text overflows.
  final bool isOverflowing;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  /// Creates a new [FondeNavigationBadge].
  ///
  /// [text] - The text to display on the badge (if null, only a dot is displayed).
  /// [backgroundColor] - The background color of the badge.
  /// [textColor] - The text color of the badge.
  /// [size] - The size of the badge.
  /// [isOverflowing] - A flag for handling text overflow.
  const FondeNavigationBadge({
    super.key,
    this.text,
    this.backgroundColor,
    this.textColor,
    this.size = 18,
    this.isOverflowing = false,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context) {
    final zoomScale = disableZoom ? 1.0 : context.fondeZoomScale;

    final theme = Theme.of(context);
    final effectiveBackgroundColor =
        backgroundColor ?? theme.colorScheme.primary;
    final effectiveTextColor = textColor ?? theme.colorScheme.onPrimary;

    if (text == null || text!.isEmpty) {
      // Display only a dot
      return Container(
        width: (size / 2) * zoomScale,
        height: (size / 2) * zoomScale,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: effectiveBackgroundColor,
        ),
      );
    }

    final effectiveText = isOverflowing && text!.length > 2 ? "99+" : text;

    return Container(
      constraints: BoxConstraints(
        minWidth: size * zoomScale,
        minHeight: size * zoomScale,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 6.0 * zoomScale,
        vertical: 2.0 * zoomScale,
      ),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular((size / 2) * zoomScale),
      ),
      child: Center(
        child: FondeText(
          effectiveText!,
          variant: FondeTextVariant.smallText,
          color: effectiveTextColor,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
