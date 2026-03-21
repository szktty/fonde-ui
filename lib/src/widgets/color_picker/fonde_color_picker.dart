import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal.dart';
import '../styling/fonde_border_radius.dart';
import '../widgets/fonde_button.dart';
import '../widgets/fonde_dialog.dart';
import 'fonde_eye_dropper.dart';

/// A desktop-style color picker widget.
///
/// Supports hue/saturation/value selection via interactive canvases,
/// optional color palette swatches, optional eyedropper (requires
/// [FondeEyeDropper] in the tree), plus hex input.
///
/// No external dependencies.
///
/// Example:
/// ```dart
/// FondeColorPicker(
///   initialColor: Colors.blue,
///   onColorChanged: (color) => setState(() => _selectedColor = color),
///   palette: [Colors.red, Colors.green, Colors.blue],
/// )
/// ```
class FondeColorPicker extends ConsumerStatefulWidget {
  const FondeColorPicker({
    super.key,
    this.initialColor = Colors.blue,
    required this.onColorChanged,
    this.showAlpha = true,
    this.palette,
    this.showEyeDropper = false,
    this.width = 240.0,
    this.disableZoom = false,
  });

  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  /// Whether to show the alpha channel slider.
  final bool showAlpha;

  /// Optional list of preset colors shown as swatches below the sliders.
  /// Pass an empty list or null to hide the palette.
  final List<Color>? palette;

  /// Whether to show the eyedropper button.
  /// Requires [FondeEyeDropper] to be present in the widget tree
  /// (e.g. via `FondeApp(enableEyeDropper: true)`).
  final bool showEyeDropper;

  final double width;
  final bool disableZoom;

  @override
  ConsumerState<FondeColorPicker> createState() => _FondeColorPickerState();
}

class _FondeColorPickerState extends ConsumerState<FondeColorPicker> {
  late HSVColor _hsv;
  late TextEditingController _hexController;
  late TextEditingController _opacityController;
  bool _hexFocused = false;
  bool _opacityFocused = false;

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(widget.initialColor);
    _hexController = TextEditingController(text: _colorToHex(_hsv.toColor()));
    _opacityController = TextEditingController(
      text: _alphaToPercent(_hsv.alpha),
    );
  }

  @override
  void dispose() {
    _hexController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  String _alphaToPercent(double alpha) => '${(alpha * 100).round()}';

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
      if (!_opacityFocused) {
        _opacityController.text = _alphaToPercent(hsv.alpha);
      }
    });
    widget.onColorChanged(hsv.toColor());
  }

  void _onOpacitySubmitted(String value) {
    final parsed = int.tryParse(value.replaceAll('%', ''));
    if (parsed != null) {
      final clamped = parsed.clamp(0, 100);
      _updateHsv(_hsv.withAlpha(clamped / 100.0));
    }
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
    final palette = widget.palette;

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

          // Preview + eyedropper + hex input
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
              if (widget.showEyeDropper) ...[
                SizedBox(width: 8.0 * zoomScale),
                FondeEyeDropperButton(
                  onColorPicked: (c) => _updateHsv(HSVColor.fromColor(c)),
                  size: 20.0 * zoomScale,
                  color: colorScheme.base.foreground,
                ),
              ],
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
              // Opacity input (showAlpha のときのみ表示)
              if (widget.showAlpha) ...[
                SizedBox(width: 8.0 * zoomScale),
                SizedBox(
                  width: 56.0 * zoomScale,
                  child: Focus(
                    onFocusChange: (focused) {
                      setState(() => _opacityFocused = focused);
                      if (!focused) {
                        _onOpacitySubmitted(_opacityController.text);
                      }
                    },
                    child: TextField(
                      controller: _opacityController,
                      style: TextStyle(
                        fontSize: 12.0 * zoomScale,
                        color: colorScheme.base.foreground,
                      ),
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        isDense: true,
                        suffixText: '%',
                        suffixStyle: TextStyle(
                          fontSize: 12.0 * zoomScale,
                          color: colorScheme.base.foreground,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8.0 * zoomScale,
                          vertical: 6.0 * zoomScale,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            FondeBorderRadiusValues.small * zoomScale,
                          ),
                          borderSide: BorderSide(
                            color: colorScheme.base.border,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            FondeBorderRadiusValues.small * zoomScale,
                          ),
                          borderSide: BorderSide(
                            color: colorScheme.base.border,
                          ),
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
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      onSubmitted: _onOpacitySubmitted,
                    ),
                  ),
                ),
              ],
            ],
          ),

          // Palette swatches
          if (palette != null && palette.isNotEmpty) ...[
            SizedBox(height: 12.0 * zoomScale),
            _ColorPalette(
              colors: palette,
              selectedColor: _hsv.toColor(),
              onColorSelected: (c) => _updateHsv(HSVColor.fromColor(c)),
              zoomScale: zoomScale,
              borderColor: colorScheme.base.border,
            ),
          ],
        ],
      ),
    );
  }
}

/// A row of color swatches for quick selection.
class _ColorPalette extends StatelessWidget {
  const _ColorPalette({
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
    required this.zoomScale,
    required this.borderColor,
  });

  final List<Color> colors;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;
  final double zoomScale;
  final Color borderColor;

  bool _isSameColor(Color a, Color b) =>
      a.red == b.red && a.green == b.green && a.blue == b.blue;

  @override
  Widget build(BuildContext context) {
    final swatchSize = 20.0 * zoomScale;
    return Wrap(
      spacing: 6.0 * zoomScale,
      runSpacing: 6.0 * zoomScale,
      children:
          colors.map((color) {
            final isSelected = _isSameColor(color, selectedColor);
            return GestureDetector(
              onTap: () => onColorSelected(color),
              child: Container(
                width: swatchSize,
                height: swatchSize,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(
                    FondeBorderRadiusValues.small * zoomScale,
                  ),
                  border: Border.all(
                    color: isSelected ? Colors.white : borderColor,
                    width: isSelected ? 2.0 : 1.0,
                  ),
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.6),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ]
                          : null,
                ),
              ),
            );
          }).toList(),
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
        ..shader = const LinearGradient(
          colors: [Colors.white, Colors.transparent],
        ).createShader(Offset.zero & size),
    );

    // Value gradient (top = transparent, bottom = black)
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(
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

    // Checkerboard background + alpha gradient (both clipped to rounded rect)
    canvas.save();
    canvas.clipRRect(rRect);

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
    canvas.restore(); // gradient clip
    canvas.restore(); // checkerboard clip

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
      old.alpha != alpha || old.color != color;
}

/// Shows a [FondeColorPicker] in a dialog using [showFondeDialog].
Future<Color?> showFondeColorPickerDialog({
  required BuildContext context,
  Color initialColor = Colors.blue,
  bool showAlpha = false,
  List<Color>? palette,
  bool showEyeDropper = false,
}) async {
  Color current = initialColor;

  return showFondeDialog<Color>(
    context: context,
    title: 'Color Picker',
    importance: FondeDialogImportance.utility,
    width: 296.0,
    padding: const EdgeInsets.all(16.0),
    child: FondeColorPicker(
      initialColor: initialColor,
      showAlpha: showAlpha,
      palette: palette,
      showEyeDropper: showEyeDropper,
      width: 248.0,
      onColorChanged: (c) => current = c,
    ),
    footer: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FondeButton.cancel(
          label: 'Cancel',
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 8.0),
        FondeButton.primary(
          label: 'OK',
          onPressed: () => Navigator.of(context).pop(current),
        ),
      ],
    ),
  );
}
