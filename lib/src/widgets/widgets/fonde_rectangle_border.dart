import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/context_extensions.dart';
import '../../internal.dart';

// ---------------------------------------------------------------------------
// Squircle algorithm
//
// Independent implementation based on the squircle shape described in:
//   "Desperately Seeking Squircles" — Figma Engineering Blog
//   https://www.figma.com/blog/desperately-seeking-squircles/
//
// Each corner is drawn as a single cubic Bézier curve.  The key idea is that
// `cornerSmoothing` extends the tangent points outward along the straight edges
// (beyond where a plain circular arc would start), so the curve blends more
// gradually into the edge.  The Bézier control points then follow the standard
// circular-arc approximation (kappa ≈ 0.5523) scaled to the *extended* radius,
// which keeps G1 continuity at the tangent points.
// ---------------------------------------------------------------------------

// Bézier circular-arc approximation constant (4*(sqrt(2)-1)/3).
const _kappa = 0.5522847498;

/// Builds a squircle [Path] for the given [rect].
///
/// [cornerRadius] — corner radius in logical pixels.
/// [cornerSmoothing] — 0 = plain rounded rect, ~0.6 = Figma default, 1 = full squircle.
///
/// Squircle path builder. Internal use only — not exported from `fonde_ui.dart`.
Path buildSquirclePath(Rect rect, double cornerRadius, double cornerSmoothing) {
  final w = rect.width;
  final h = rect.height;

  // Radius clamped to half the shorter side.
  final maxR = math.min(w, h) / 2;
  final r = cornerRadius.clamp(0.0, maxR);

  // `t` is how far the tangent point extends past the plain arc start.
  // At smoothing=0 it is 0 (plain circle); at smoothing=1 it equals 0.5*r.
  // Factor of 0.5 keeps the smoothing subtle — smoothing=0.6 extends by 0.3r.
  final t = cornerSmoothing * r * 0.15;

  // The tangent point sits at distance (r + t) from the corner apex along each edge.
  final d = r + t;

  // Bézier handle length: kappa * r gives a circular arc for the r-radius part.
  // We also add t to the first handle so the curve leaves the tangent point
  // tangentially and the join with the straight edge is smooth (G1).
  // Clamped to d so the control point never crosses the corner apex.
  final handleOuter = math.min(_kappa * r + t, d);

  final l = rect.left;
  final top = rect.top;
  final ri = rect.right;
  final bo = rect.bottom;

  final path = Path();

  // moveTo: start on the top edge, leaving the top-left corner.
  path.moveTo(l + d, top);

  // ── Top edge ──────────────────────────────────────────────────────────────
  path.lineTo(ri - d, top);

  // ── Top-right corner ──────────────────────────────────────────────────────
  // Incoming tangent point: (ri - d, top)  →  Corner apex: (ri, top)
  // Outgoing tangent point: (ri, top + d)
  path.cubicTo(
    ri - d + handleOuter,
    top, // cp1: push right along top edge
    ri,
    top + d - handleOuter, // cp2: push up along right edge
    ri,
    top + d, // end: outgoing tangent point
  );

  // ── Right edge ────────────────────────────────────────────────────────────
  path.lineTo(ri, bo - d);

  // ── Bottom-right corner ───────────────────────────────────────────────────
  path.cubicTo(ri, bo - d + handleOuter, ri - d + handleOuter, bo, ri - d, bo);

  // ── Bottom edge ───────────────────────────────────────────────────────────
  path.lineTo(l + d, bo);

  // ── Bottom-left corner ────────────────────────────────────────────────────
  path.cubicTo(l + d - handleOuter, bo, l, bo - d + handleOuter, l, bo - d);

  // ── Left edge ─────────────────────────────────────────────────────────────
  path.lineTo(l, top + d);

  // ── Top-left corner ───────────────────────────────────────────────────────
  path.cubicTo(l, top + d - handleOuter, l + d - handleOuter, top, l + d, top);

  path.close();
  return path;
}

// ---------------------------------------------------------------------------
// Public shape classes (drop-in replacements for figma_squircle)
// ---------------------------------------------------------------------------

/// A [BorderRadius]-compatible class that carries squircle parameters.
///
/// Extends [BorderRadius] so it can be passed anywhere [BorderRadius] is
/// expected.  The four [Radius] values are plain circular radii of
/// [cornerRadius]; the squircle rendering is performed by [SquircleBorder].
class SquircleBorderRadius extends BorderRadius {
  SquircleBorderRadius({required this.cornerRadius, this.cornerSmoothing = 0.6})
    : super.all(Radius.circular(cornerRadius));

  final double cornerRadius;
  final double cornerSmoothing;
}

/// A [ShapeBorder] that draws a squircle (smooth rounded rectangle).
///
/// Use [SquircleBorderRadius] for [borderRadius] to control corner smoothing.
/// If a plain [BorderRadius] is provided the shape degrades to a standard
/// rounded rectangle.
class SquircleBorder extends OutlinedBorder {
  const SquircleBorder({
    required this.borderRadius,
    super.side = BorderSide.none,
  });

  final BorderRadiusGeometry borderRadius;

  double get _cornerRadius {
    final br = borderRadius;
    if (br is SquircleBorderRadius) return br.cornerRadius;
    if (br is BorderRadius) return br.topLeft.x;
    return 0;
  }

  double get _cornerSmoothing {
    final br = borderRadius;
    if (br is SquircleBorderRadius) return br.cornerSmoothing;
    return 0;
  }

  @override
  OutlinedBorder copyWith({
    BorderSide? side,
    BorderRadiusGeometry? borderRadius,
  }) {
    return SquircleBorder(
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final inset = side.width;
    return buildSquirclePath(
      rect.deflate(inset),
      (_cornerRadius - inset).clamp(0.0, double.infinity),
      _cornerSmoothing,
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return buildSquirclePath(rect, _cornerRadius, _cornerSmoothing);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side == BorderSide.none) return;
    final paint = side.toPaint();
    final inset = side.width / 2;
    canvas.drawPath(
      buildSquirclePath(
        rect.deflate(inset),
        (_cornerRadius - inset).clamp(0.0, double.infinity),
        _cornerSmoothing,
      ),
      paint,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return SquircleBorder(side: side.scale(t), borderRadius: borderRadius * t);
  }
}

// ---------------------------------------------------------------------------
// App-level wrappers
// ---------------------------------------------------------------------------

/// App common Figma-style squircle border widget.
class FondeRectangleBorder extends StatelessWidget {
  const FondeRectangleBorder({
    super.key,
    this.child,
    this.cornerRadius,
    this.cornerSmoothing,
    this.side,
    this.outerSide,
    this.color,
    this.padding,
    this.width,
    this.height,
    this.alignment = Alignment.center,
  });

  final Widget? child;
  final double? cornerRadius;
  final double? cornerSmoothing;

  /// Inner border drawn inside the widget bounds (default).
  final BorderSide? side;

  /// Outer border drawn outside the widget bounds via Stack overlay.
  /// Use this when the border should not affect the internal layout.
  final BorderSide? outerSide;

  final Color? color;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final appColors = context.fondeColorScheme;

    final effectiveCornerRadius = cornerRadius ?? 8.0;
    final effectiveCornerSmoothing = cornerSmoothing ?? 0.6;
    final effectiveSide =
        side ?? BorderSide(color: appColors.base.border, width: 1.5);

    Widget container = Container(
      width: width,
      height: height,
      alignment: alignment,
      decoration: ShapeDecoration(
        color: color,
        shape: SquircleBorder(
          borderRadius: SquircleBorderRadius(
            cornerRadius: effectiveCornerRadius,
            cornerSmoothing: effectiveCornerSmoothing,
          ),
          side: effectiveSide,
        ),
      ),
      child: padding != null ? Padding(padding: padding!, child: child) : child,
    );

    if (outerSide == null) return container;
    return container;
  }
}

/// App specific BorderRadius using squircle parameters.
class FondeBorderRadius {
  final double cornerRadius;
  final double cornerSmoothing;

  const FondeBorderRadius({double? cornerRadius, double? cornerSmoothing})
    : cornerRadius = cornerRadius ?? 8.0,
      cornerSmoothing = cornerSmoothing ?? 0.6;

  const FondeBorderRadius.radius(double radius)
    : cornerRadius = radius,
      cornerSmoothing = 0.6;

  const FondeBorderRadius.small() : cornerRadius = 8.0, cornerSmoothing = 0.6;
  const FondeBorderRadius.medium() : cornerRadius = 8.0, cornerSmoothing = 0.6;
  const FondeBorderRadius.large() : cornerRadius = 16.0, cornerSmoothing = 0.6;
  const FondeBorderRadius.circular(double radius)
    : cornerRadius = radius,
      cornerSmoothing = 1.0;

  factory FondeBorderRadius.create({
    double? cornerRadius,
    double? cornerSmoothing,
  }) {
    if (cornerRadius == null && cornerSmoothing == null) {
      return const FondeBorderRadius();
    }
    return FondeBorderRadius(
      cornerRadius: cornerRadius,
      cornerSmoothing: cornerSmoothing,
    );
  }

  SquircleBorderRadius toSmoothBorderRadius() => SquircleBorderRadius(
    cornerRadius: cornerRadius,
    cornerSmoothing: cornerSmoothing,
  );

  BorderRadiusGeometry toBorderRadiusGeometry() => toSmoothBorderRadius();
}

/// App specific BorderSide presets.
class FondeBorderSide extends BorderSide {
  const FondeBorderSide({
    super.color,
    super.width = 1.5,
    super.style,
    super.strokeAlign,
  });

  const FondeBorderSide.thin({super.color, super.style, super.strokeAlign})
    : super(width: 1.0);

  const FondeBorderSide.standard({super.color, super.style, super.strokeAlign})
    : super(width: 1.5);

  const FondeBorderSide.thick({super.color, super.style, super.strokeAlign})
    : super(width: 2.0);

  const FondeBorderSide.none() : super(width: 0.0, style: BorderStyle.none);
}
