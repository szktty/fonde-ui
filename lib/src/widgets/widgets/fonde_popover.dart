import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'fonde_rectangle_border.dart';

// ---------------------------------------------------------------------------
// Direction
// ---------------------------------------------------------------------------

/// Display direction for [FondePopover].
enum FondePopoverDirection { top, bottom, left, right }

// ---------------------------------------------------------------------------
// Animation
// ---------------------------------------------------------------------------

/// Animation type for [FondePopover].
enum FondePopoverAnimation { scaleAndFade, slideAndFade, elastic, fade, none }

// ---------------------------------------------------------------------------
// State tracker
// ---------------------------------------------------------------------------

class _PopoverState {
  bool _isShowing = false;
  Timer? _autoCloseTimer;

  bool get isShowing => _isShowing;

  void markAsShowing() => _isShowing = true;

  void markAsClosed() {
    _isShowing = false;
    _autoCloseTimer?.cancel();
    _autoCloseTimer = null;
  }

  void setAutoCloseTimer(Timer timer) {
    _autoCloseTimer?.cancel();
    _autoCloseTimer = timer;
  }

  void dispose() {
    _autoCloseTimer?.cancel();
    _autoCloseTimer = null;
    _isShowing = false;
  }
}

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

class FondePopover {
  const FondePopover._();

  static Duration _animationDuration(FondePopoverAnimation a) {
    switch (a) {
      case FondePopoverAnimation.scaleAndFade:
        return const Duration(milliseconds: 250);
      case FondePopoverAnimation.slideAndFade:
        return const Duration(milliseconds: 300);
      case FondePopoverAnimation.elastic:
        return const Duration(milliseconds: 400);
      case FondePopoverAnimation.fade:
        return const Duration(milliseconds: 200);
      case FondePopoverAnimation.none:
        return Duration.zero;
    }
  }

  static Widget _buildTransition(
    Animation<double> animation,
    Widget child,
    FondePopoverAnimation type,
    FondePopoverDirection direction,
  ) {
    switch (type) {
      case FondePopoverAnimation.scaleAndFade:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
              ),
            ),
            child: child,
          ),
        );
      case FondePopoverAnimation.slideAndFade:
        Offset slideOffset;
        switch (direction) {
          case FondePopoverDirection.top:
            slideOffset = const Offset(0.0, 0.3);
          case FondePopoverDirection.bottom:
            slideOffset = const Offset(0.0, -0.3);
          case FondePopoverDirection.left:
            slideOffset = const Offset(0.3, 0.0);
          case FondePopoverDirection.right:
            slideOffset = const Offset(-0.3, 0.0);
        }
        return SlideTransition(
          position: Tween<Offset>(begin: slideOffset, end: Offset.zero).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
              ),
            ),
            child: child,
          ),
        );
      case FondePopoverAnimation.elastic:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.7, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
              ),
            ),
            child: child,
          ),
        );
      case FondePopoverAnimation.fade:
        return FadeTransition(
          opacity: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      case FondePopoverAnimation.none:
        return child;
    }
  }

  /// Show a popover anchored to [context]'s widget.
  ///
  /// [direction] is the preferred direction; it may be flipped if there is
  /// insufficient space on that side.
  static void show({
    required BuildContext context,
    required WidgetBuilder bodyBuilder,
    FondePopoverDirection direction = FondePopoverDirection.bottom,
    double width = 200,
    double height = 400,
    double arrowHeight = 12,
    double arrowWidth = 20,
    double? radius,
    Color? backgroundColor,
    Color? shadowColor,
    double elevation = 8,
    VoidCallback? onPop,
    Color? barrierColor,
    bool barrierDismissible = true,
    FondePopoverAnimation animation = FondePopoverAnimation.fade,
    Duration? duration,
    Duration? delay,
  }) {
    final state = _PopoverState();

    void showInternal() {
      final effectiveRadius = radius ?? 12.0;
      final effectiveBackground = backgroundColor ?? Colors.white;
      final effectiveShadow = shadowColor ?? Colors.black.withAlpha(77);
      final effectiveBarrier = barrierColor ?? Colors.black.withAlpha(77);
      final animDuration = _animationDuration(animation);

      state.markAsShowing();

      Navigator.of(context, rootNavigator: true).push(
        _PopoverRoute(
          context: context,
          bodyBuilder: bodyBuilder,
          direction: direction,
          width: width,
          height: height,
          arrowHeight: arrowHeight,
          arrowWidth: arrowWidth,
          radius: effectiveRadius,
          backgroundColor: effectiveBackground,
          shadow: [
            BoxShadow(
              color: effectiveShadow,
              blurRadius: elevation,
              offset: const Offset(0, 2),
            ),
          ],
          barrierColor: effectiveBarrier,
          barrierDismissible: barrierDismissible,
          transitionDuration: animDuration,
          transitionBuilder:
              (anim, child) =>
                  _buildTransition(anim, child, animation, direction),
          onPop: () {
            state.markAsClosed();
            onPop?.call();
          },
        ),
      );

      if (duration != null) {
        state.setAutoCloseTimer(
          Timer(duration, () {
            if (context.mounted && state.isShowing) {
              try {
                Navigator.of(context, rootNavigator: false).pop();
                state.markAsClosed();
              } catch (_) {
                state.markAsClosed();
              }
            }
          }),
        );
      }
    }

    if (delay != null) {
      Timer(delay, () {
        if (context.mounted) showInternal();
      });
    } else {
      showInternal();
    }
  }
}

// ---------------------------------------------------------------------------
// Route
// ---------------------------------------------------------------------------

typedef _TransitionBuilder =
    Widget Function(Animation<double> animation, Widget child);

class _PopoverRoute extends PopupRoute<void> {
  _PopoverRoute({
    required this.context,
    required this.bodyBuilder,
    required this.direction,
    required this.width,
    required this.height,
    required this.arrowHeight,
    required this.arrowWidth,
    required this.radius,
    required this.backgroundColor,
    required this.shadow,
    required this.barrierDismissible,
    required this.transitionDuration,
    required this.transitionBuilder,
    required Color barrierColor,
    this.onPop,
  }) : _barrierColor = barrierColor;

  final BuildContext context;
  final WidgetBuilder bodyBuilder;
  final FondePopoverDirection direction;
  final double width;
  final double height;
  final double arrowHeight;
  final double arrowWidth;
  final double radius;
  final Color backgroundColor;
  final List<BoxShadow> shadow;
  final VoidCallback? onPop;
  final _TransitionBuilder transitionBuilder;
  final Color _barrierColor;

  @override
  final bool barrierDismissible;

  @override
  final Duration transitionDuration;

  @override
  Color get barrierColor => _barrierColor;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext ctx,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) => onPop?.call(),
      child: _PopoverLayout(
        attachContext: context,
        direction: direction,
        width: width,
        height: height,
        arrowHeight: arrowHeight,
        arrowWidth: arrowWidth,
        radius: radius,
        backgroundColor: backgroundColor,
        shadow: shadow,
        animation: animation,
        transitionBuilder: transitionBuilder,
        child: Builder(builder: bodyBuilder),
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => child;
}

// ---------------------------------------------------------------------------
// Layout
// ---------------------------------------------------------------------------

class _PopoverLayout extends StatefulWidget {
  const _PopoverLayout({
    required this.attachContext,
    required this.direction,
    required this.width,
    required this.height,
    required this.arrowHeight,
    required this.arrowWidth,
    required this.radius,
    required this.backgroundColor,
    required this.shadow,
    required this.animation,
    required this.transitionBuilder,
    required this.child,
  });

  final BuildContext attachContext;
  final FondePopoverDirection direction;
  final double width;
  final double height;
  final double arrowHeight;
  final double arrowWidth;
  final double radius;
  final Color backgroundColor;
  final List<BoxShadow> shadow;
  final Animation<double> animation;
  final _TransitionBuilder transitionBuilder;
  final Widget child;

  @override
  State<_PopoverLayout> createState() => _PopoverLayoutState();
}

class _PopoverLayoutState extends State<_PopoverLayout> {
  Rect _attachRect = Rect.zero;

  @override
  void initState() {
    super.initState();
    _updateAttachRect();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(_updateAttachRect);
    });
  }

  void _updateAttachRect() {
    final renderBox = widget.attachContext.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) return;
    final offset = renderBox.localToGlobal(Offset.zero);
    _attachRect = offset & renderBox.size;
  }

  FondePopoverDirection _resolveDirection(Size popoverSize) {
    final screen =
        ui.PlatformDispatcher.instance.views.first.physicalSize /
        ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
    switch (widget.direction) {
      case FondePopoverDirection.top:
        return _attachRect.top >= popoverSize.height + widget.arrowHeight
            ? FondePopoverDirection.top
            : FondePopoverDirection.bottom;
      case FondePopoverDirection.bottom:
        return screen.height >=
                _attachRect.bottom + popoverSize.height + widget.arrowHeight
            ? FondePopoverDirection.bottom
            : FondePopoverDirection.top;
      case FondePopoverDirection.left:
        return _attachRect.left >= popoverSize.width + widget.arrowHeight
            ? FondePopoverDirection.left
            : FondePopoverDirection.right;
      case FondePopoverDirection.right:
        return screen.width >=
                _attachRect.right + popoverSize.width + widget.arrowHeight
            ? FondePopoverDirection.right
            : FondePopoverDirection.left;
    }
  }

  Offset _popoverOffset(
    FondePopoverDirection resolved,
    Size popoverSize,
    Size screenSize,
  ) {
    final arrow = widget.arrowHeight;
    double dx, dy;

    if (resolved == FondePopoverDirection.top ||
        resolved == FondePopoverDirection.bottom) {
      // Horizontal centering, clamped to screen
      dx = _attachRect.left + _attachRect.width / 2 - popoverSize.width / 2;
      dx = dx.clamp(arrow, screenSize.width - popoverSize.width - arrow);
      dy =
          resolved == FondePopoverDirection.bottom
              ? _attachRect.bottom
              : _attachRect.top - popoverSize.height;
    } else {
      // Vertical centering, clamped to screen
      dy = _attachRect.top + _attachRect.height / 2 - popoverSize.height / 2;
      dy = dy.clamp(arrow, screenSize.height - popoverSize.height - arrow);
      dx =
          resolved == FondePopoverDirection.right
              ? _attachRect.right
              : _attachRect.left - popoverSize.width;
    }
    return Offset(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final bodySize = Size(widget.width, widget.height);
    final popoverSize = Size(
      widget.direction == FondePopoverDirection.left ||
              widget.direction == FondePopoverDirection.right
          ? bodySize.width + widget.arrowHeight
          : bodySize.width,
      widget.direction == FondePopoverDirection.top ||
              widget.direction == FondePopoverDirection.bottom
          ? bodySize.height + widget.arrowHeight
          : bodySize.height,
    );

    final resolved = _resolveDirection(popoverSize);
    final offset = _popoverOffset(resolved, popoverSize, screenSize);

    // Arrow center position relative to popover top-left
    final arrowCenter =
        resolved == FondePopoverDirection.top ||
                resolved == FondePopoverDirection.bottom
            ? _attachRect.left + _attachRect.width / 2 - offset.dx
            : _attachRect.top + _attachRect.height / 2 - offset.dy;

    final popover = _PopoverBalloon(
      direction: resolved,
      arrowHeight: widget.arrowHeight,
      arrowWidth: widget.arrowWidth,
      arrowCenter: arrowCenter,
      radius: widget.radius,
      backgroundColor: widget.backgroundColor,
      shadow: widget.shadow,
      size: popoverSize,
      child: SizedBox(
        width: bodySize.width,
        height: bodySize.height,
        child: widget.child,
      ),
    );

    return Stack(
      children: [
        Positioned(
          left: offset.dx,
          top: offset.dy,
          child: widget.transitionBuilder(widget.animation, popover),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Balloon (arrow + rounded rect)
// ---------------------------------------------------------------------------

class _PopoverBalloon extends StatelessWidget {
  const _PopoverBalloon({
    required this.direction,
    required this.arrowHeight,
    required this.arrowWidth,
    required this.arrowCenter,
    required this.radius,
    required this.backgroundColor,
    required this.shadow,
    required this.size,
    required this.child,
  });

  final FondePopoverDirection direction;
  final double arrowHeight;
  final double arrowWidth;
  final double arrowCenter;
  final double radius;
  final Color backgroundColor;
  final List<BoxShadow> shadow;
  final Size size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: CustomPaint(
        painter: _BalloonPainter(
          direction: direction,
          arrowHeight: arrowHeight,
          arrowWidth: arrowWidth,
          arrowCenter: arrowCenter,
          radius: radius,
          backgroundColor: backgroundColor,
          shadow: shadow,
        ),
        child: _childWithPadding(),
      ),
    );
  }

  Widget _childWithPadding() {
    switch (direction) {
      case FondePopoverDirection.bottom:
        return Padding(
          padding: EdgeInsets.only(top: arrowHeight),
          child: child,
        );
      case FondePopoverDirection.top:
        return Padding(
          padding: EdgeInsets.only(bottom: arrowHeight),
          child: child,
        );
      case FondePopoverDirection.right:
        return Padding(
          padding: EdgeInsets.only(left: arrowHeight),
          child: child,
        );
      case FondePopoverDirection.left:
        return Padding(
          padding: EdgeInsets.only(right: arrowHeight),
          child: child,
        );
    }
  }
}

class _BalloonPainter extends CustomPainter {
  _BalloonPainter({
    required this.direction,
    required this.arrowHeight,
    required this.arrowWidth,
    required this.arrowCenter,
    required this.radius,
    required this.backgroundColor,
    required this.shadow,
  });

  final FondePopoverDirection direction;
  final double arrowHeight;
  final double arrowWidth;
  final double arrowCenter;
  final double radius;
  final Color backgroundColor;
  final List<BoxShadow> shadow;

  Rect _bodyRect(Size size) {
    final ah = arrowHeight;
    switch (direction) {
      case FondePopoverDirection.bottom:
        return Rect.fromLTWH(0, ah, size.width, size.height - ah);
      case FondePopoverDirection.top:
        return Rect.fromLTWH(0, 0, size.width, size.height - ah);
      case FondePopoverDirection.right:
        return Rect.fromLTWH(ah, 0, size.width - ah, size.height);
      case FondePopoverDirection.left:
        return Rect.fromLTWH(0, 0, size.width - ah, size.height);
    }
  }

  // Builds the full balloon path: squircle body + rounded arrow in one path.
  //
  // Strategy:
  //   1. Build the squircle body path via buildSquirclePath.
  //   2. Identify the two base points on the body edge where the arrow meets it.
  //   3. Cut the body path at those points and insert the arrow sub-path:
  //        base-left  →  cubicTo (tangent)  →  tip arc  →  cubicTo (tangent)  →  base-right
  //
  // For simplicity the body squircle path is unioned with the arrow path drawn
  // with rounded corners via Path operations.  The arrow itself is built as:
  //   - Two straight sides with a short cubic easing into the body edge (root rounding)
  //   - A small arc at the tip
  Path _buildPath(Size size) {
    final ah = arrowHeight;
    final aw = arrowWidth;
    final isHorizontal =
        direction == FondePopoverDirection.top ||
        direction == FondePopoverDirection.bottom;
    final extent = isHorizontal ? size.width : size.height;
    final ac = arrowCenter.clamp(radius + aw / 2, extent - radius - aw / 2);

    // Tip rounding radius — small enough not to alter the silhouette noticeably.
    final tipR = (arrowHeight * 0.18).clamp(1.5, 4.0);
    // Root rounding: how far from the base point the cubic easing starts.
    final rootEase = (aw * 0.18).clamp(2.0, 6.0);

    // Build the arrow as a standalone filled path, then union with the body.
    final arrowPath = Path();

    switch (direction) {
      case FondePopoverDirection.bottom:
        // Base is at y=ah; tip points upward to y=0.
        final baseY = ah;
        final lx = ac - aw / 2; // left base x
        final rx = ac + aw / 2; // right base x

        // Start at left base, ease upward with cubic, draw tip arc, ease back down.
        arrowPath.moveTo(lx, baseY);
        // Left side: cubic easing from base → near tip
        arrowPath.cubicTo(
          lx,
          baseY - rootEase,
          ac - tipR,
          tipR,
          ac - tipR,
          tipR,
        );
        // Tip arc (concave upward, so sweep clockwise)
        arrowPath.arcToPoint(
          Offset(ac + tipR, tipR),
          radius: Radius.circular(tipR),
          clockwise: true,
        );
        // Right side: cubic easing from near tip → base
        arrowPath.cubicTo(ac + tipR, tipR, rx, baseY - rootEase, rx, baseY);
        arrowPath.close();

      case FondePopoverDirection.top:
        // Base is at y=(size.height - ah); tip points downward to y=size.height.
        final baseY = size.height - ah;
        final tipY = size.height;
        final lx = ac - aw / 2;
        final rx = ac + aw / 2;

        arrowPath.moveTo(lx, baseY);
        arrowPath.cubicTo(
          lx,
          baseY + rootEase,
          ac - tipR,
          tipY - tipR,
          ac - tipR,
          tipY - tipR,
        );
        arrowPath.arcToPoint(
          Offset(ac + tipR, tipY - tipR),
          radius: Radius.circular(tipR),
          clockwise: false,
        );
        arrowPath.cubicTo(
          ac + tipR,
          tipY - tipR,
          rx,
          baseY + rootEase,
          rx,
          baseY,
        );
        arrowPath.close();

      case FondePopoverDirection.right:
        // Base is at x=ah; tip points leftward to x=0.
        final baseX = ah;
        final ty = ac - aw / 2;
        final by = ac + aw / 2;

        arrowPath.moveTo(baseX, ty);
        arrowPath.cubicTo(
          baseX - rootEase,
          ty,
          tipR,
          ac - tipR,
          tipR,
          ac - tipR,
        );
        arrowPath.arcToPoint(
          Offset(tipR, ac + tipR),
          radius: Radius.circular(tipR),
          clockwise: false,
        );
        arrowPath.cubicTo(tipR, ac + tipR, baseX - rootEase, by, baseX, by);
        arrowPath.close();

      case FondePopoverDirection.left:
        // Base is at x=(size.width - ah); tip points rightward to x=size.width.
        final baseX = size.width - ah;
        final tipX = size.width;
        final ty = ac - aw / 2;
        final by = ac + aw / 2;

        arrowPath.moveTo(baseX, ty);
        arrowPath.cubicTo(
          baseX + rootEase,
          ty,
          tipX - tipR,
          ac - tipR,
          tipX - tipR,
          ac - tipR,
        );
        arrowPath.arcToPoint(
          Offset(tipX - tipR, ac + tipR),
          radius: Radius.circular(tipR),
          clockwise: true,
        );
        arrowPath.cubicTo(
          tipX - tipR,
          ac + tipR,
          baseX + rootEase,
          by,
          baseX,
          by,
        );
        arrowPath.close();
    }

    final bodyPath = buildSquirclePath(_bodyRect(size), radius, 0.6);
    return Path.combine(PathOperation.union, bodyPath, arrowPath);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildPath(size);

    for (final s in shadow) {
      canvas.drawPath(path.shift(s.offset), s.toPaint());
    }

    canvas.drawPath(path, Paint()..color = backgroundColor);
  }

  @override
  bool shouldRepaint(_BalloonPainter old) =>
      old.direction != direction ||
      old.arrowCenter != arrowCenter ||
      old.radius != radius ||
      old.backgroundColor != backgroundColor;
}
