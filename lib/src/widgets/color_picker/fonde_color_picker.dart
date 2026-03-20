import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal.dart';
import '../styling/fonde_border_radius.dart';
import '../typography/fonde_text.dart';
import '../widgets/fonde_button.dart';

/// A desktop-style color picker widget.
///
/// Supports hue/saturation/value selection via interactive canvases,
/// plus hex input. No external dependencies.
///
/// Example:
/// ```dart
/// FondeColorPicker(
///   initialColor: Colors.blue,
///   onColorChanged: (color) => setState(() => _selectedColor = color),
/// )
/// ```
class FondeColorPicker extends ConsumerStatefulWidget {
  const FondeColorPicker({
    super.key,
    this.initialColor = Colors.blue,
    required this.onColorChanged,
    this.showAlpha = false,
    this.width = 240.0,
    this.disableZoom = false,
  });

  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  /// Whether to show the alpha channel slider.
  final bool showAlpha;

  final double width;
  final bool disableZoom;

  @override
  ConsumerState<FondeColorPicker> createState() => _FondeColorPickerState();
}

class _FondeColorPickerState extends ConsumerState<FondeColorPicker> {
  late HSVColor _hsv;
  late TextEditingController _hexController;
  bool _hexFocused = false;

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(widget.initialColor);
    _hexController = TextEditingController(text: _colorToHex(_hsv.toColor()));
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  String _colorToHex(Color c) {
    return '#${c.red.toRadixString(16).padLeft(2, '0')}${c.green.toRadixString(16).padLeft(2, '0')}${c.blue.toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  void _updateHsv(HSVColor hsv) {
    setState(() {
      _hsv = hsv;
      if (!_hexFocused) {
        _hexController.text = _colorToHex(hsv.toColor());
      }
    });
    widget.onColorChanged(hsv.toColor());
  }

  void _onHexSubmitted(String value) {
    final cleaned = value.replaceAll('#', '');
    if (cleaned.length == 6) {
      final r = int.tryParse(cleaned.substring(0, 2), radix: 16);
      final g = int.tryParse(cleaned.substring(2, 4), radix: 16);
      final b = int.tryParse(cleaned.substring(4, 6), radix: 16);
      if (r != null && g != null && b != null) {
        final color = Color.fromARGB(
          (widget.showAlpha ? (_hsv.alpha * 255).round() : 255),
          r,
          g,
          b,
        );
        _updateHsv(HSVColor.fromColor(color));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(fondeAccessibilityConfigProvider);
    final zoomScale = widget.disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    final w = widget.width * zoomScale;
    final svSize = w;

    return SizedBox(
      width: w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Saturation/Value canvas
          _SaturationValuePicker(
            hsv: _hsv,
            size: svSize,
            onChanged:
                (s, v) => _updateHsv(_hsv.withSaturation(s).withValue(v)),
          ),
          SizedBox(height: 12.0 * zoomScale),

          // Hue slider
          _HueSlider(
            hue: _hsv.hue,
            width: w,
            onChanged: (h) => _updateHsv(_hsv.withHue(h)),
          ),

          // Alpha slider
          if (widget.showAlpha) ...[
            SizedBox(height: 8.0 * zoomScale),
            _AlphaSlider(
              alpha: _hsv.alpha,
              color: _hsv.toColor(),
              width: w,
              onChanged: (a) => _updateHsv(_hsv.withAlpha(a)),
            ),
          ],

          SizedBox(height: 12.0 * zoomScale),

          // Preview + hex input
          Row(
            children: [
              // Color preview swatch
              Container(
                width: 32.0 * zoomScale,
                height: 32.0 * zoomScale,
                decoration: BoxDecoration(
                  color: _hsv.toColor(),
                  borderRadius: BorderRadius.circular(
                    FondeBorderRadiusValues.small * zoomScale,
                  ),
                  border: Border.all(color: colorScheme.base.border),
                ),
              ),
              SizedBox(width: 8.0 * zoomScale),
              // Hex input
              Expanded(
                child: Focus(
                  onFocusChange: (focused) {
                    setState(() => _hexFocused = focused);
                    if (!focused) {
                      _onHexSubmitted(_hexController.text);
                    }
                  },
                  child: TextField(
                    controller: _hexController,
                    style: TextStyle(
                      fontSize: 12.0 * zoomScale,
                      color: colorScheme.base.foreground,
                      fontFamily: 'monospace',
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8.0 * zoomScale,
                        vertical: 6.0 * zoomScale,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          FondeBorderRadiusValues.small * zoomScale,
                        ),
                        borderSide: BorderSide(color: colorScheme.base.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          FondeBorderRadiusValues.small * zoomScale,
                        ),
                        borderSide: BorderSide(color: colorScheme.base.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          FondeBorderRadiusValues.small * zoomScale,
                        ),
                        borderSide: BorderSide(
                          color: colorScheme.theme.primaryColor,
                        ),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[#0-9a-fA-F]'),
                      ),
                      LengthLimitingTextInputFormatter(7),
                    ],
                    onSubmitted: _onHexSubmitted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Saturation-Value picker canvas (the main colored square).
class _SaturationValuePicker extends StatelessWidget {
  const _SaturationValuePicker({
    required this.hsv,
    required this.size,
    required this.onChanged,
  });

  final HSVColor hsv;
  final double size;
  final void Function(double saturation, double value) onChanged;

  void _handleDrag(Offset localPosition) {
    final s = (localPosition.dx / size).clamp(0.0, 1.0);
    final v = (1.0 - localPosition.dy / size).clamp(0.0, 1.0);
    onChanged(s, v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (d) => _handleDrag(d.localPosition),
      onPanUpdate: (d) => _handleDrag(d.localPosition),
      onTapDown: (d) => _handleDrag(d.localPosition),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(FondeBorderRadiusValues.small),
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: _SaturationValuePainter(hsv: hsv)),
        ),
      ),
    );
  }
}

class _SaturationValuePainter extends CustomPainter {
  _SaturationValuePainter({required this.hsv});
  final HSVColor hsv;

  @override
  void paint(Canvas canvas, Size size) {
    // Base hue fill
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = HSVColor.fromAHSV(1.0, hsv.hue, 1.0, 1.0).toColor(),
    );

    // Saturation gradient (left = white, right = hue)
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
          colors: [Colors.white, Colors.transparent],
        ).createShader(Offset.zero & size),
    );

    // Value gradient (top = transparent, bottom = black)
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black],
        ).createShader(Offset.zero & size),
    );

    // Thumb circle
    final thumbX = hsv.saturation * size.width;
    final thumbY = (1.0 - hsv.value) * size.height;
    canvas.drawCircle(
      Offset(thumbX, thumbY),
      8.0,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
    canvas.drawCircle(
      Offset(thumbX, thumbY),
      6.0,
      Paint()..color = hsv.toColor(),
    );
  }

  @override
  bool shouldRepaint(_SaturationValuePainter old) => old.hsv != hsv;
}

/// Horizontal hue gradient slider.
class _HueSlider extends StatelessWidget {
  const _HueSlider({
    required this.hue,
    required this.width,
    required this.onChanged,
  });

  final double hue;
  final double width;
  final ValueChanged<double> onChanged;

  void _handleDrag(Offset localPosition) {
    final h = (localPosition.dx / width * 360.0).clamp(0.0, 360.0);
    onChanged(h);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (d) => _handleDrag(d.localPosition),
      onPanUpdate: (d) => _handleDrag(d.localPosition),
      onTapDown: (d) => _handleDrag(d.localPosition),
      child: SizedBox(
        width: width,
        height: 16.0,
        child: CustomPaint(painter: _HuePainter(hue: hue)),
      ),
    );
  }
}

class _HuePainter extends CustomPainter {
  const _HuePainter({required this.hue});
  final double hue;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final radius = Radius.circular(size.height / 2);
    final rRect = RRect.fromRectAndRadius(rect, radius);

    // Hue gradient
    final colors = List.generate(
      7,
      (i) => HSVColor.fromAHSV(1.0, i * 60.0, 1.0, 1.0).toColor(),
    );
    canvas.drawRRect(
      rRect,
      Paint()..shader = LinearGradient(colors: colors).createShader(rect),
    );

    // Thumb
    final thumbX = (hue / 360.0) * size.width;
    canvas.drawCircle(
      Offset(thumbX, size.height / 2),
      size.height / 2,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  @override
  bool shouldRepaint(_HuePainter old) => old.hue != hue;
}

/// Horizontal alpha slider.
class _AlphaSlider extends StatelessWidget {
  const _AlphaSlider({
    required this.alpha,
    required this.color,
    required this.width,
    required this.onChanged,
  });

  final double alpha;
  final Color color;
  final double width;
  final ValueChanged<double> onChanged;

  void _handleDrag(Offset localPosition) {
    final a = (localPosition.dx / width).clamp(0.0, 1.0);
    onChanged(a);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (d) => _handleDrag(d.localPosition),
      onPanUpdate: (d) => _handleDrag(d.localPosition),
      onTapDown: (d) => _handleDrag(d.localPosition),
      child: SizedBox(
        width: width,
        height: 16.0,
        child: CustomPaint(painter: _AlphaPainter(alpha: alpha, color: color)),
      ),
    );
  }
}

class _AlphaPainter extends CustomPainter {
  const _AlphaPainter({required this.alpha, required this.color});
  final double alpha;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final radius = Radius.circular(size.height / 2);
    final rRect = RRect.fromRectAndRadius(rect, radius);

    // Checkerboard background
    const cellSize = 4.0;
    final cols = (size.width / cellSize).ceil();
    final rows = (size.height / cellSize).ceil();
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        canvas.drawRect(
          Rect.fromLTWH(c * cellSize, r * cellSize, cellSize, cellSize),
          Paint()
            ..color = (r + c).isEven ? Colors.white : const Color(0xFFCCCCCC),
        );
      }
    }

    // Alpha gradient
    canvas.save();
    canvas.clipRRect(rRect);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          colors: [Colors.transparent, color.withValues(alpha: 1.0)],
        ).createShader(rect),
    );
    canvas.restore();

    // Thumb
    final thumbX = alpha * size.width;
    canvas.drawCircle(
      Offset(thumbX, size.height / 2),
      size.height / 2,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  @override
  bool shouldRepaint(_AlphaPainter old) =>
      old.alpha != alpha || old.color != old.color;
}

/// Shows a [FondeColorPicker] in a popup dialog.
Future<Color?> showFondeColorPickerDialog({
  required BuildContext context,
  Color initialColor = Colors.blue,
  bool showAlpha = false,
}) async {
  Color? result;

  await showDialog<void>(
    context: context,
    barrierColor: Colors.black26,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: _ColorPickerDialog(
          initialColor: initialColor,
          showAlpha: showAlpha,
          onConfirm: (c) {
            result = c;
            Navigator.of(ctx).pop();
          },
          onCancel: () => Navigator.of(ctx).pop(),
        ),
      );
    },
  );

  return result;
}

class _ColorPickerDialog extends ConsumerStatefulWidget {
  const _ColorPickerDialog({
    required this.initialColor,
    required this.showAlpha,
    required this.onConfirm,
    required this.onCancel,
  });

  final Color initialColor;
  final bool showAlpha;
  final ValueChanged<Color> onConfirm;
  final VoidCallback onCancel;

  @override
  ConsumerState<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends ConsumerState<_ColorPickerDialog> {
  late Color _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);

    return Container(
      width: 280.0,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.uiAreas.dialog.background,
        borderRadius: BorderRadius.circular(FondeBorderRadiusValues.medium),
        border: Border.all(color: colorScheme.base.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FondeText(
            'Color Picker',
            variant: FondeTextVariant.captionText,
            color: colorScheme.uiAreas.dialog.foreground,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 12.0),
          FondeColorPicker(
            initialColor: widget.initialColor,
            showAlpha: widget.showAlpha,
            width: 248.0,
            onColorChanged: (c) => setState(() => _current = c),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FondeButton.cancel(label: 'Cancel', onPressed: widget.onCancel),
              const SizedBox(width: 8.0),
              FondeButton.primary(
                label: 'OK',
                onPressed: () => widget.onConfirm(_current),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
