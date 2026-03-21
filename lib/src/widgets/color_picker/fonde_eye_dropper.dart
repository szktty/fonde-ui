import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Provides eyedropper (color sampling) functionality within the Flutter
/// window.
///
/// Wrap your app root (or [FondeApp]) with this widget to enable eyedropper
/// support. Colors are sampled from within the Flutter rendering surface only —
/// pixels outside the app window (OS desktop, other apps) are not accessible.
///
/// ```dart
/// FondeApp(
///   enableEyeDropper: true,
///   home: ...,
/// )
/// ```
///
/// To trigger picking, place a [FondeEyeDropperButton] anywhere in the tree.
class FondeEyeDropper extends StatefulWidget {
  const FondeEyeDropper({super.key, required this.child});

  final Widget child;

  /// Returns the nearest [FondeEyeDropperState], or null if not found.
  static FondeEyeDropperState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<FondeEyeDropperState>();
  }

  @override
  State<FondeEyeDropper> createState() => FondeEyeDropperState();
}

class FondeEyeDropperState extends State<FondeEyeDropper> {
  final _repaintKey = GlobalKey();
  final _overlayKey = GlobalKey<OverlayState>();

  bool _active = false;
  ui.Image? _snapshot;
  int _snapshotWidth = 0;
  int _snapshotHeight = 0;
  OverlayEntry? _overlayEntry;
  ValueChanged<Color>? _onColorPicked;
  Offset? _lastKnownPointer;

  /// Start eyedropper mode. [onColorPicked] is called when the user clicks.
  Future<void> startPicking(ValueChanged<Color> onColorPicked) async {
    final renderObject = _repaintKey.currentContext?.findRenderObject();
    if (renderObject is! RenderRepaintBoundary) return;

    // Wait for the current frame to finish painting before capturing.
    // Calling toImage() while debugNeedsPaint is true throws an AssertionError.
    await WidgetsBinding.instance.endOfFrame;

    if (!mounted) return;

    // Capture the current Flutter surface
    final image = await renderObject.toImage(pixelRatio: 1.0);
    final width = image.width;
    final height = image.height;

    setState(() {
      _snapshot = image;
      _snapshotWidth = width;
      _snapshotHeight = height;
      _active = true;
      _onColorPicked = onColorPicked;
    });

    _showOverlay();
  }

  void _showOverlay() {
    final overlay = _overlayKey.currentState;
    if (overlay == null) return;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => _EyeDropperOverlay(
            snapshot: _snapshot!,
            snapshotWidth: _snapshotWidth,
            snapshotHeight: _snapshotHeight,
            initialPosition: _lastKnownPointer,
            onColorPicked: _onPicked,
            onCancel: _cancel,
          ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _onPicked(Color color) {
    _onColorPicked?.call(color);
    _dismiss();
  }

  void _cancel() {
    _dismiss();
  }

  void _dismiss() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _snapshot?.dispose();
    setState(() {
      _active = false;
      _snapshot = null;
      _onColorPicked = null;
    });
  }

  bool get isActive => _active;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _repaintKey,
      child: MouseRegion(
        onHover: (e) => _lastKnownPointer = e.localPosition,
        child: Overlay(
          key: _overlayKey,
          initialEntries: [OverlayEntry(builder: (_) => widget.child)],
        ),
      ),
    );
  }
}

/// The overlay shown during eyedropper picking. Captures pointer movement and
/// draws a zoom loupe.
class _EyeDropperOverlay extends StatefulWidget {
  const _EyeDropperOverlay({
    required this.snapshot,
    required this.snapshotWidth,
    required this.snapshotHeight,
    required this.onColorPicked,
    required this.onCancel,
    this.initialPosition,
  });

  final ui.Image snapshot;
  final int snapshotWidth;
  final int snapshotHeight;
  final ValueChanged<Color> onColorPicked;
  final VoidCallback onCancel;
  final Offset? initialPosition;

  @override
  State<_EyeDropperOverlay> createState() => _EyeDropperOverlayState();
}

class _EyeDropperOverlayState extends State<_EyeDropperOverlay> {
  Offset? _pointer;
  Color _hovered = Colors.transparent;
  ByteData? _bytes;

  @override
  void initState() {
    super.initState();
    _pointer = widget.initialPosition;
    _loadBytes();
  }

  Future<void> _loadBytes() async {
    final data = await widget.snapshot.toByteData(
      format: ui.ImageByteFormat.rawStraightRgba,
    );
    if (mounted) {
      setState(() => _bytes = data);
    }
  }

  Color _colorAt(Offset position) {
    final bytes = _bytes;
    if (bytes == null) return Colors.transparent;
    final x = position.dx.round().clamp(0, widget.snapshotWidth - 1);
    final y = position.dy.round().clamp(0, widget.snapshotHeight - 1);
    final offset = (y * widget.snapshotWidth + x) * 4;
    if (offset + 3 >= bytes.lengthInBytes) return Colors.transparent;
    final r = bytes.getUint8(offset);
    final g = bytes.getUint8(offset + 1);
    final b = bytes.getUint8(offset + 2);
    final a = bytes.getUint8(offset + 3);
    return Color.fromARGB(a, r, g, b);
  }

  void _updatePointer(Offset position) {
    setState(() {
      _pointer = position;
      _hovered = _colorAt(position);
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    final color = _colorAt(event.localPosition);
    widget.onColorPicked(color);
  }

  @override
  Widget build(BuildContext context) {
    final pointer = _pointer;
    return AnnotatedRegion<MouseCursor>(
      value: SystemMouseCursors.none,
      child: Listener(
        onPointerMove: (e) => _updatePointer(e.localPosition),
        onPointerDown: (e) => _updatePointer(e.localPosition),
        onPointerUp: _onPointerUp,
        child: MouseRegion(
          cursor: SystemMouseCursors.none,
          onHover: (e) => _updatePointer(e.localPosition),
          child: Stack(
            children: [
              // 全画面を覆う透明領域（右クリックでキャンセル）
              Positioned.fill(
                child: GestureDetector(
                  onSecondaryTap: widget.onCancel,
                  child: const ColoredBox(color: Colors.transparent),
                ),
              ),
              // ルーペ：カーソル位置が確定してからのみ表示
              if (_bytes != null && pointer != null)
                Positioned(
                  left: pointer.dx - _LoupePainterWidget.loupeSize / 2,
                  top: pointer.dy - _LoupePainterWidget.loupeSize / 2,
                  child: _LoupePainterWidget(
                    snapshot: widget.snapshot,
                    snapshotWidth: widget.snapshotWidth,
                    snapshotHeight: widget.snapshotHeight,
                    center: pointer,
                    hoveredColor: _hovered,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Zoom loupe widget shown near the cursor during eyedropper mode.
class _LoupePainterWidget extends StatelessWidget {
  const _LoupePainterWidget({
    required this.snapshot,
    required this.snapshotWidth,
    required this.snapshotHeight,
    required this.center,
    required this.hoveredColor,
  });

  static const double loupeSize = 120.0;
  static const int gridSize = 9; // 9x9 grid of pixels

  final ui.Image snapshot;
  final int snapshotWidth;
  final int snapshotHeight;
  final Offset center;
  final Color hoveredColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(loupeSize, loupeSize),
      painter: _LoupePainter(
        snapshot: snapshot,
        snapshotWidth: snapshotWidth,
        snapshotHeight: snapshotHeight,
        center: center,
        gridSize: gridSize,
      ),
    );
  }
}

class _LoupePainter extends CustomPainter {
  const _LoupePainter({
    required this.snapshot,
    required this.snapshotWidth,
    required this.snapshotHeight,
    required this.center,
    required this.gridSize,
  });

  final ui.Image snapshot;
  final int snapshotWidth;
  final int snapshotHeight;
  final Offset center;
  final int gridSize;

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / gridSize;
    final half = gridSize ~/ 2;

    final paint = Paint()..isAntiAlias = false;

    // Draw the snapshot zoomed in, cell by cell
    final srcRect = Rect.fromCenter(
      center: center,
      width: gridSize.toDouble(),
      height: gridSize.toDouble(),
    );
    final dstRect = Offset.zero & size;

    // Clip to circle
    final path = Path()..addOval(dstRect);
    canvas.save();
    canvas.clipPath(path);

    canvas.drawImageRect(snapshot, srcRect, dstRect, paint);

    // Grid lines
    final gridPaint =
        Paint()
          ..color = Colors.black.withValues(alpha: 0.2)
          ..strokeWidth = 0.5
          ..style = PaintingStyle.stroke;
    for (var i = 0; i <= gridSize; i++) {
      final x = i * cellSize;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      canvas.drawLine(Offset(0, x), Offset(size.width, x), gridPaint);
    }

    // Center cell highlight
    final centerRect = Rect.fromLTWH(
      half * cellSize,
      half * cellSize,
      cellSize,
      cellSize,
    );
    canvas.drawRect(
      centerRect,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.0)
        ..style = PaintingStyle.fill,
    );
    canvas.drawRect(
      centerRect,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    canvas.restore();

    // Outer circle border
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(_LoupePainter old) =>
      old.center != center || old.snapshot != snapshot;
}

/// A button that activates the eyedropper. Requires [FondeEyeDropper] to be
/// present in the widget tree (e.g. via `FondeApp(enableEyeDropper: true)`).
class FondeEyeDropperButton extends StatelessWidget {
  const FondeEyeDropperButton({
    super.key,
    required this.onColorPicked,
    this.icon = LucideIcons.pipette,
    this.tooltip = 'Pick color from screen',
    this.size = 24.0,
    this.color,
  });

  final ValueChanged<Color> onColorPicked;
  final IconData icon;
  final String tooltip;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final eyeDropper = FondeEyeDropper.maybeOf(context);
    final enabled = eyeDropper != null;

    return Tooltip(
      message: enabled ? tooltip : 'FondeEyeDropper not found in widget tree',
      child: MouseRegion(
        cursor:
            enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
        child: GestureDetector(
          onTap: enabled ? () => eyeDropper.startPicking(onColorPicked) : null,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              icon,
              size: size,
              color:
                  enabled
                      ? (color ?? IconTheme.of(context).color)
                      : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
