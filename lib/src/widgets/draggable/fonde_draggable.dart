import 'package:flutter/material.dart';
import '../../internal.dart';

/// Desktop-appropriate drag feedback style.
enum FondeDragFeedbackStyle {
  /// Semi-transparent clone of the child widget.
  ghost,

  /// Compact badge showing an icon and optional count.
  badge,

  /// Use a custom feedback widget supplied by [FondeDraggable.feedbackBuilder].
  custom,
}

/// A desktop-first draggable widget.
///
/// Wraps Flutter's [Draggable] with desktop-appropriate defaults:
/// - Left mouse button drag (no long-press requirement).
/// - Ghost feedback (semi-transparent clone) by default.
/// - No haptic feedback.
/// - Cursor changes to [SystemMouseCursors.grab] / [SystemMouseCursors.grabbing].
///
/// Type parameter [T] is the data type carried by the drag.
///
/// Example:
/// ```dart
/// FondeDraggable<String>(
///   data: 'item-id',
///   child: MyListItem(),
/// )
/// ```
class FondeDraggable<T extends Object> extends StatefulWidget {
  const FondeDraggable({
    super.key,
    required this.data,
    required this.child,
    this.feedbackStyle = FondeDragFeedbackStyle.ghost,
    this.feedbackBuilder,
    this.feedbackOffset = Offset.zero,
    this.dragAnchorStrategy = childDragAnchorStrategy,
    this.axis,
    this.childWhenDragging,
    this.onDragStarted,
    this.onDragEnd,
    this.onDraggableCanceled,
    this.onDragCompleted,
    this.maxSimultaneousDrags = 1,
    this.disableZoom = false,
  });

  /// The data carried by this draggable.
  final T data;

  /// The widget shown in its normal (non-dragging) state.
  final Widget child;

  /// How the drag feedback should look.
  final FondeDragFeedbackStyle feedbackStyle;

  /// Used when [feedbackStyle] is [FondeDragFeedbackStyle.custom].
  final WidgetBuilder? feedbackBuilder;

  /// Offset of the feedback widget relative to the pointer.
  final Offset feedbackOffset;

  /// Anchor strategy for the feedback widget.
  final DragAnchorStrategy dragAnchorStrategy;

  /// Restricts dragging to a single axis.
  final Axis? axis;

  /// Replacement for [child] while dragging. Defaults to a transparent placeholder.
  final Widget? childWhenDragging;

  final VoidCallback? onDragStarted;
  final DragEndDetails Function(DraggableDetails)? onDragEnd;
  final void Function(Velocity, Offset)? onDraggableCanceled;
  final VoidCallback? onDragCompleted;

  /// Maximum simultaneous drags. Defaults to 1.
  final int maxSimultaneousDrags;

  /// Whether to disable zoom scaling on the feedback.
  final bool disableZoom;

  @override
  State<FondeDraggable<T>> createState() => _FondeDraggableState<T>();
}

class _FondeDraggableState<T extends Object> extends State<FondeDraggable<T>> {
  bool _isDragging = false;

  Widget _buildFeedback(BuildContext context) {
    switch (widget.feedbackStyle) {
      case FondeDragFeedbackStyle.ghost:
        return Opacity(opacity: 0.7, child: widget.child);
      case FondeDragFeedbackStyle.badge:
        return _DragBadge(disableZoom: widget.disableZoom);
      case FondeDragFeedbackStyle.custom:
        assert(
          widget.feedbackBuilder != null,
          'feedbackBuilder must be provided when feedbackStyle is custom',
        );
        return widget.feedbackBuilder!(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final childWhenDragging =
        widget.childWhenDragging ?? Opacity(opacity: 0.3, child: widget.child);

    return MouseRegion(
      cursor:
          _isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
      child: Draggable<T>(
        data: widget.data,
        feedback: Material(
          color: Colors.transparent,
          child: _buildFeedback(context),
        ),
        feedbackOffset: widget.feedbackOffset,
        dragAnchorStrategy: widget.dragAnchorStrategy,
        axis: widget.axis,
        childWhenDragging: childWhenDragging,
        maxSimultaneousDrags: widget.maxSimultaneousDrags,
        onDragStarted: () {
          setState(() => _isDragging = true);
          widget.onDragStarted?.call();
        },
        onDragEnd: (details) {
          setState(() => _isDragging = false);
          widget.onDragEnd?.call(details);
        },
        onDraggableCanceled: (velocity, offset) {
          setState(() => _isDragging = false);
          widget.onDraggableCanceled?.call(velocity, offset);
        },
        onDragCompleted: () {
          setState(() => _isDragging = false);
          widget.onDragCompleted?.call();
        },
        child: widget.child,
      ),
    );
  }
}

/// Small drag badge shown during badge-style feedback.
class _DragBadge extends StatelessWidget {
  const _DragBadge({required this.disableZoom});

  final bool disableZoom;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.fondeColorScheme;
    final accessibilityConfig = context.fondeAccessibility;
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    return Container(
      width: 32.0 * zoomScale,
      height: 32.0 * zoomScale,
      decoration: BoxDecoration(
        color: colorScheme.theme.primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.drag_indicator,
        color: Colors.white,
        size: 16.0 * zoomScale,
      ),
    );
  }
}

/// A desktop-first drag target.
///
/// Wraps Flutter's [DragTarget] with visual drop-zone highlighting.
///
/// Type parameter [T] is the data type accepted by this target.
class FondeDragTarget<T extends Object> extends StatefulWidget {
  const FondeDragTarget({
    super.key,
    required this.builder,
    this.onWillAcceptWithDetails,
    this.onAcceptWithDetails,
    this.onLeave,
    this.onMove,
    this.hitTestBehavior = HitTestBehavior.translucent,
  });

  /// Builds the widget. [isOver] is true when a compatible drag is hovering.
  final Widget Function(
    BuildContext context,
    List<T?> candidateData,
    List<dynamic> rejectedData,
    bool isOver,
  )
  builder;

  final bool Function(DragTargetDetails<T>)? onWillAcceptWithDetails;
  final void Function(DragTargetDetails<T>)? onAcceptWithDetails;
  final void Function(T?)? onLeave;
  final void Function(DragTargetDetails<T>)? onMove;
  final HitTestBehavior hitTestBehavior;

  @override
  State<FondeDragTarget<T>> createState() => _FondeDragTargetState<T>();
}

class _FondeDragTargetState<T extends Object>
    extends State<FondeDragTarget<T>> {
  bool _isOver = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<T>(
      hitTestBehavior: widget.hitTestBehavior,
      builder: (context, candidateData, rejectedData) {
        return widget.builder(context, candidateData, rejectedData, _isOver);
      },
      onWillAcceptWithDetails: (details) {
        setState(() => _isOver = true);
        return widget.onWillAcceptWithDetails?.call(details) ?? true;
      },
      onAcceptWithDetails: (details) {
        setState(() => _isOver = false);
        widget.onAcceptWithDetails?.call(details);
      },
      onLeave: (data) {
        setState(() => _isOver = false);
        widget.onLeave?.call(data);
      },
      onMove: widget.onMove,
    );
  }
}
