import 'package:flutter/material.dart';
import 'package:figma_squircle/figma_squircle.dart';

/// Paints an outer focus ring just outside the widget bounds using a
/// Figma-style squircle shape.
///
/// Used by [FondeTextField] and [FondeSearchField] to draw a consistent
/// keyboard-focus indicator.
class FondeFocusRingPainter extends CustomPainter {
  const FondeFocusRingPainter({
    required this.color,
    required this.borderWidth,
    required this.cornerRadius,
  });

  final Color color;
  final double borderWidth;
  final double cornerRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth;

    final expand = borderWidth / 2;
    final rect = Rect.fromLTWH(
      -expand,
      -expand,
      size.width + borderWidth,
      size.height + borderWidth,
    );

    final path = SmoothRectangleBorder(
      borderRadius: SmoothBorderRadius(
        cornerRadius: cornerRadius + expand,
        cornerSmoothing: 0.6,
      ),
    ).getOuterPath(rect);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(FondeFocusRingPainter oldDelegate) =>
      color != oldDelegate.color ||
      borderWidth != oldDelegate.borderWidth ||
      cornerRadius != oldDelegate.cornerRadius;
}
