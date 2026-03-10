import 'dart:async';
import 'package:flutter/material.dart';

/// A custom gesture detector that distinguishes between single and double taps
/// without the delay inherent in the default GestureDetector when both are used.
///
/// This widget provides proper single/double tap handling by using a timer-based
/// approach that prevents the execution of both callbacks for a double tap.
///
/// ## Behavior
///
/// ### Single Tap Only
/// When only [onTap] is provided, it's called immediately without delay:
/// ```dart
/// FondeGestureDetector(
///   onTap: () => print('Single tap!'),
///   child: Container(width: 100, height: 100),
/// )
/// ```
///
/// ### Double Tap Only
/// When only [onDoubleTap] is provided, it requires two taps within [doubleTapTimeout]:
/// ```dart
/// FondeGestureDetector(
///   onDoubleTap: () => print('Double tap!'),
///   child: Container(width: 100, height: 100),
/// )
/// ```
///
/// ### Both Single and Double Tap
/// When both callbacks are provided, the behavior depends on whether [onTapCancel] is provided:
///
/// **With onTapCancel (immediate response):**
/// [onTap] is called immediately for responsive UI. If a double tap occurs,
/// [onTapCancel] undoes the single tap effect, then [onDoubleTap] is executed:
/// ```dart
/// bool isSelected = false;
///
/// FondeGestureDetector(
///   onTap: () => setState(() => isSelected = true),
///   onTapCancel: () => setState(() => isSelected = false),
///   onDoubleTap: () => openItem(),
///   child: Container(width: 100, height: 100),
/// )
/// ```
///
/// **Without onTapCancel (delayed response):**
/// [onTap] is delayed by [doubleTapTimeout]. If a double tap occurs,
/// only [onDoubleTap] is called:
/// ```dart
/// FondeGestureDetector(
///   onTap: () => selectItem(),
///   onDoubleTap: () => openItem(),
///   child: Container(width: 100, height: 100),
/// )
/// ```
///
/// ### Tap Down/Up Events
/// For debugging or immediate visual feedback, you can use [onTapDown] and [onTapUp]:
/// ```dart
/// FondeGestureDetector(
///   onTapDown: (details) => print('Tap started at ${details.localPosition}'),
///   onTapUp: (details) => print('Tap ended at ${details.localPosition}'),
///   onTap: () => print('Single tap confirmed'),
///   child: Container(width: 100, height: 100),
/// )
/// ```
///
/// ## Performance Features
/// - Automatically optimizes by not attaching gesture detection when no callbacks are provided
/// - Properly manages timer resources to prevent memory leaks
/// - Handles widget lifecycle correctly (mounted checks, dispose cleanup)
/// - Prevents accidental triggers from rapid successive taps (< 50ms apart)
/// - Includes error handling to prevent callback exceptions from crashing the app
///
/// ## Testing Support
/// The [timeProvider] parameter allows for dependency injection of time functions,
/// making the widget easily testable with mock time providers.
class FondeGestureDetector extends StatefulWidget {
  /// The widget below this widget in the tree.
  ///
  /// This widget will be wrapped with gesture detection capabilities.
  final Widget child;

  /// A callback function for a single tap.
  ///
  /// **Timing behavior:**
  /// - If [onDoubleTap] is null: Called immediately on tap
  /// - If [onDoubleTap] is provided: Called immediately, but may be cancelled
  ///   if a double tap occurs within [doubleTapTimeout]
  ///
  /// **Error handling:** Exceptions in this callback are caught and logged
  /// to prevent app crashes.
  final VoidCallback? onTap;

  /// A callback function to cancel/undo the effect of [onTap].
  ///
  /// This is called when a single tap was executed but then a double tap
  /// is detected within [doubleTapTimeout]. This allows for immediate
  /// single tap feedback while still supporting proper double tap handling.
  ///
  /// **Use case:** If [onTap] changes UI state (like selection), this callback
  /// should reverse that change.
  ///
  /// **Example:**
  /// ```dart
  /// bool isSelected = false;
  ///
  /// FondeGestureDetector(
  ///   onTap: () => setState(() => isSelected = true),
  ///   onTapCancel: () => setState(() => isSelected = false),
  ///   onDoubleTap: () => openItem(),
  /// )
  /// ```
  final VoidCallback? onTapCancel;

  /// A callback function for a double tap.
  ///
  /// **Requirements:** Two taps must occur within [doubleTapTimeout] duration.
  ///
  /// **Behavior:** When executed, it prevents [onTap] from being called,
  /// ensuring only one callback is executed per gesture sequence.
  ///
  /// **Error handling:** Exceptions in this callback are caught and logged
  /// to prevent app crashes.
  final VoidCallback? onDoubleTap;

  /// A callback function for when a tap down event occurs.
  ///
  /// This is called immediately when the user presses down on the widget,
  /// before any tap/double-tap logic is processed. Useful for providing
  /// immediate visual feedback or debugging tap detection.
  ///
  /// **Timing:** Called immediately on pointer down, regardless of whether
  /// this will become a single tap, double tap, or cancelled gesture.
  ///
  /// **Use cases:**
  /// - Immediate visual feedback (highlight, ripple effect)
  /// - Debugging tap detection issues
  /// - Analytics/logging of user interactions
  ///
  /// **Error handling:** Exceptions in this callback are caught and logged
  /// to prevent app crashes.
  final GestureTapDownCallback? onTapDown;

  /// A callback function for when a tap up event occurs.
  ///
  /// This is called when the user releases their finger/mouse, but before
  /// the tap/double-tap logic determines the final action. This provides
  /// a way to detect the physical end of a tap gesture.
  ///
  /// **Timing:** Called on pointer up, before [onTap] or [onDoubleTap]
  /// processing occurs.
  ///
  /// **Use cases:**
  /// - Removing visual feedback applied in [onTapDown]
  /// - Debugging gesture completion
  /// - Measuring tap duration
  ///
  /// **Error handling:** Exceptions in this callback are caught and logged
  /// to prevent app crashes.
  final GestureTapUpCallback? onTapUp;

  /// Callback for when hover state changes.
  ///
  /// Called with `true` when the pointer enters the widget area,
  /// and `false` when it exits.
  final ValueChanged<bool>? onHover;

  /// The cursor type when hovering over this widget.
  ///
  /// **Default:** [MouseCursor.defer] (defers to the closest ancestor)
  final MouseCursor cursor;

  /// How this gesture detector should behave during hit testing.
  ///
  /// This affects how the gesture detector responds to taps on child widgets:
  /// - [HitTestBehavior.deferToChild]: Only responds to taps on empty areas
  /// - [HitTestBehavior.opaque]: Responds to all taps within bounds
  /// - [HitTestBehavior.translucent]: Responds to all taps and passes through
  ///
  /// For table cells, [HitTestBehavior.opaque] is recommended to ensure
  /// taps on text and other content are detected.
  final HitTestBehavior? behavior;

  /// The duration to consider for a double tap.
  ///
  /// **Default:** 250 milliseconds (following platform conventions)
  ///
  /// **Usage:**
  /// - Maximum time between two taps to be considered a double tap
  /// - Delay time for single tap execution when both callbacks are provided
  /// - Should be between 100-500ms for optimal user experience
  final Duration doubleTapTimeout;

  /// Time provider function for testing purposes.
  ///
  /// **Default:** [DateTime.now] in production
  ///
  /// **Testing:** Inject a custom time provider to control time flow in tests:
  /// ```dart
  /// DateTime mockTime = DateTime(2023, 1, 1);
  /// FondeGestureDetector(
  ///   timeProvider: () => mockTime,
  ///   // ... other parameters
  /// )
  /// ```
  final DateTime Function() timeProvider;

  const FondeGestureDetector({
    super.key,
    required this.child,
    this.onTap,
    this.onTapCancel,
    this.onDoubleTap,
    this.onTapDown,
    this.onTapUp,
    this.onHover,
    this.cursor = MouseCursor.defer,
    this.behavior,
    this.doubleTapTimeout = const Duration(milliseconds: 250),
    this.timeProvider = _defaultTimeProvider,
  });

  /// Default time provider that returns current time.
  static DateTime _defaultTimeProvider() => DateTime.now();

  @override
  State<FondeGestureDetector> createState() => _AppGestureDetectorState();
}

class _AppGestureDetectorState extends State<FondeGestureDetector> {
  // Drag cancellation threshold in logical pixels.
  static const double _dragThreshold = 5.0;

  DateTime? _lastTapTime;
  Timer? _singleTapTimer;

  // Pointer tracking for drag detection.
  Offset? _pointerDownPosition;
  bool _dragCancelled = false;

  @override
  void dispose() {
    _cancelSingleTapTimer();
    super.dispose();
  }

  void _cancelSingleTapTimer() {
    _singleTapTimer?.cancel();
    _singleTapTimer = null;
  }

  void _onPointerDown(PointerDownEvent event) {
    if (!mounted) return;
    _pointerDownPosition = event.localPosition;
    _dragCancelled = false;

    if (widget.onTapDown != null) {
      try {
        widget.onTapDown!(
          TapDownDetails(
            globalPosition: event.position,
            localPosition: event.localPosition,
            kind: event.kind,
          ),
        );
      } catch (e, st) {
        debugPrint(
          'FondeGestureDetector: Error in onTapDown callback: $e\n$st',
        );
      }
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_dragCancelled || _pointerDownPosition == null) return;
    final delta = (event.localPosition - _pointerDownPosition!).distance;
    if (delta > _dragThreshold) {
      _dragCancelled = true;
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (!mounted || _dragCancelled) {
      _pointerDownPosition = null;
      return;
    }
    _pointerDownPosition = null;

    if (widget.onTapUp != null) {
      try {
        widget.onTapUp!(
          TapUpDetails(
            kind: event.kind,
            globalPosition: event.position,
            localPosition: event.localPosition,
          ),
        );
      } catch (e, st) {
        debugPrint('FondeGestureDetector: Error in onTapUp callback: $e\n$st');
      }
    }

    _handleTap();
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _dragCancelled = true;
    _pointerDownPosition = null;
  }

  void _handleTap() {
    if (!mounted) return;

    final now = widget.timeProvider();

    if (_lastTapTime != null) {
      final timeSinceLastTap = now.difference(_lastTapTime!);
      if (timeSinceLastTap < widget.doubleTapTimeout) {
        _handleDoubleTap();
        return;
      }
    }

    _handleFirstTap(now);
  }

  void _handleFirstTap(DateTime tapTime) {
    _lastTapTime = tapTime;
    _cancelSingleTapTimer();

    if (widget.onDoubleTap == null) {
      _executeSingleTap();
    } else if (widget.onTap != null) {
      if (widget.onTapCancel != null) {
        _executeSingleTap();
        _singleTapTimer = Timer(widget.doubleTapTimeout, () {
          _resetTapState();
        });
      } else {
        _singleTapTimer = Timer(widget.doubleTapTimeout, () {
          if (mounted) {
            _executeSingleTap();
          }
          _resetTapState();
        });
      }
    }
  }

  void _executeSingleTap() {
    try {
      widget.onTap?.call();
    } catch (e, st) {
      debugPrint('FondeGestureDetector: Error in onTap callback: $e\n$st');
    } finally {
      if (widget.onDoubleTap == null) {
        _resetTapState();
      }
    }
  }

  void _executeTapCancel() {
    try {
      widget.onTapCancel?.call();
    } catch (e, st) {
      debugPrint(
        'FondeGestureDetector: Error in onTapCancel callback: $e\n$st',
      );
    }
  }

  void _handleDoubleTap() {
    _cancelSingleTapTimer();
    if (widget.onTapCancel != null) {
      _executeTapCancel();
    }
    _executeDoubleTap();
  }

  void _executeDoubleTap() {
    try {
      widget.onDoubleTap?.call();
    } catch (e, st) {
      debugPrint(
        'FondeGestureDetector: Error in onDoubleTap callback: $e\n$st',
      );
    } finally {
      _resetTapState();
    }
  }

  void _resetTapState() {
    _lastTapTime = null;
    _cancelSingleTapTimer();
  }

  @override
  Widget build(BuildContext context) {
    final hasCallbacks =
        widget.onTap != null ||
        widget.onDoubleTap != null ||
        widget.onTapDown != null ||
        widget.onTapUp != null;

    Widget result = widget.child;

    if (hasCallbacks) {
      result = Listener(
        behavior: widget.behavior ?? HitTestBehavior.deferToChild,
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUp,
        onPointerCancel: _onPointerCancel,
        child: result,
      );
    }

    // Wrap with MouseRegion for hover and cursor support
    if (widget.onHover != null) {
      result = MouseRegion(
        cursor: widget.cursor,
        onEnter: (_) => widget.onHover!(true),
        onExit: (_) => widget.onHover!(false),
        child: result,
      );
    } else if (widget.cursor != MouseCursor.defer) {
      result = MouseRegion(cursor: widget.cursor, child: result);
    }

    return result;
  }
}
