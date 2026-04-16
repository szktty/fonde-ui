import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../internal.dart';

// ---------------------------------------------------------------------------
// Direction
// ---------------------------------------------------------------------------

/// Display direction for [FondePopover].
enum FondePopoverDirection { top, bottom, left, right }

// ---------------------------------------------------------------------------
// Animation
// ---------------------------------------------------------------------------

/// Animation type for [FondePopover].
enum FondePopoverAnimation {
  scaleAndFade,
  slideAndFade,
  elastic,
  fade,
  none,
}

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
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
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
          position: Tween<Offset>(
            begin: slideOffset,
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
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
          scale: Tween<double>(
            begin: 0.7,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.elasticOut)),
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
          transitionBuilder: (anim, child) =>
              _buildTransition(anim, child, animation, direction),
          onPop: () {
            state.markAsClosed();
            onPop?.call();
          },
        ),
      );

      if (duration != null) {
        state.setAutoCloseTimer(Timer(duration, () {
          if (context.mounted && state.isShowing) {
            try {
              Navigator.of(context, rootNavigator: false).pop();
              state.markAsClosed();
            } catch (_) {
              state.markAsClosed();
            }
          }
        }));
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

typedef _TransitionBuilder = Widget Function(
  Animation<double> animation,
  Widget child,
);

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
    final renderBox =
        widget.attachContext.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) return;
    final offset = renderBox.localToGlobal(Offset.zero);
    _attachRect = offset & renderBox.size;
  }

  FondePopoverDirection _resolveDirection(Size popoverSize) {
    final screen = ui.PlatformDispatcher.instance.views.first.physicalSize /
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
      dy = resolved == FondePopoverDirection.bottom
          ? _attachRect.bottom
          : _attachRect.top - popoverSize.height;
    } else {
      // Vertical centering, clamped to screen
      dy = _attachRect.top + _attachRect.height / 2 - popoverSize.height / 2;
      dy = dy.clamp(arrow, screenSize.height - popoverSize.height - arrow);
      dx = resolved == FondePopoverDirection.right
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
    final arrowCenter = resolved == FondePopoverDirection.top ||
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
        return Padding(padding: EdgeInsets.only(top: arrowHeight), child: child);
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

  Path _buildPath(Size size) {
    final r = radius;
    final ah = arrowHeight;
    final aw = arrowWidth;
    // Arrow tip center clamped so the arrow stays within the body
    final ac = arrowCenter.clamp(r + aw / 2, (
      direction == FondePopoverDirection.top ||
              direction == FondePopoverDirection.bottom
          ? size.width
          : size.height) -
        r -
        aw / 2);

    final path = Path();

    switch (direction) {
      case FondePopoverDirection.bottom:
        // Body rect: top=ah, left=0, right=size.width, bottom=size.height
        final bL = 0.0, bT = ah, bR = size.width, bB = size.height;
        path.moveTo(ac - aw / 2, bT); // arrow left base
        path.lineTo(ac, 0); // arrow tip
        path.lineTo(ac + aw / 2, bT); // arrow right base
        path.lineTo(bR - r, bT);
        path.conicTo(bR, bT, bR, bT + r, 1);
        path.lineTo(bR, bB - r);
        path.conicTo(bR, bB, bR - r, bB, 1);
        path.lineTo(bL + r, bB);
        path.conicTo(bL, bB, bL, bB - r, 1);
        path.lineTo(bL, bT + r);
        path.conicTo(bL, bT, bL + r, bT, 1);
        path.close();

      case FondePopoverDirection.top:
        final bL = 0.0, bT = 0.0, bR = size.width, bB = size.height - ah;
        path.moveTo(ac - aw / 2, bB); // arrow left base
        path.lineTo(ac, size.height); // arrow tip
        path.lineTo(ac + aw / 2, bB); // arrow right base
        path.lineTo(bR - r, bB);
        path.conicTo(bR, bB, bR, bB - r, 1);
        path.lineTo(bR, bT + r);
        path.conicTo(bR, bT, bR - r, bT, 1);
        path.lineTo(bL + r, bT);
        path.conicTo(bL, bT, bL, bT + r, 1);
        path.lineTo(bL, bB - r);
        path.conicTo(bL, bB, bL + r, bB, 1);
        path.close();

      case FondePopoverDirection.right:
        final bL = ah, bT = 0.0, bR = size.width, bB = size.height;
        path.moveTo(bL, ac - aw / 2);
        path.lineTo(0, ac); // arrow tip
        path.lineTo(bL, ac + aw / 2);
        path.lineTo(bL, bB - r);
        path.conicTo(bL, bB, bL + r, bB, 1);
        path.lineTo(bR - r, bB);
        path.conicTo(bR, bB, bR, bB - r, 1);
        path.lineTo(bR, bT + r);
        path.conicTo(bR, bT, bR - r, bT, 1);
        path.lineTo(bL + r, bT);
        path.conicTo(bL, bT, bL, bT + r, 1);
        path.close();

      case FondePopoverDirection.left:
        final bL = 0.0, bT = 0.0, bR = size.width - ah, bB = size.height;
        path.moveTo(bR, ac - aw / 2);
        path.lineTo(size.width, ac); // arrow tip
        path.lineTo(bR, ac + aw / 2);
        path.lineTo(bR, bB - r);
        path.conicTo(bR, bB, bR - r, bB, 1);
        path.lineTo(bL + r, bB);
        path.conicTo(bL, bB, bL, bB - r, 1);
        path.lineTo(bL, bT + r);
        path.conicTo(bL, bT, bL + r, bT, 1);
        path.lineTo(bR - r, bT);
        path.conicTo(bR, bT, bR, bT + r, 1);
        path.close();
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildPath(size);

    // Shadows
    for (final s in shadow) {
      final paint = s.toPaint();
      canvas.drawPath(path.shift(s.offset), paint);
    }

    // Background fill
    canvas.drawPath(path, Paint()..color = backgroundColor);
  }

  @override
  bool shouldRepaint(_BalloonPainter old) =>
      old.direction != direction ||
      old.arrowCenter != arrowCenter ||
      old.backgroundColor != backgroundColor;
}
