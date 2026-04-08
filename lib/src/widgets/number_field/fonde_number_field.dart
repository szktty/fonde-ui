import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../icons/lucide_icons.dart';
import '../widgets/fonde_rectangle_border.dart';
import '../../internal.dart';
import '../text_field/fonde_text_field.dart';

/// Numeric input field with increment/decrement buttons.
///
/// Displays a text field accepting numeric input flanked by − and + buttons.
/// Supports integer and decimal values, with optional min/max bounds and step.
class FondeNumberField extends StatefulWidget {
  /// Initial value.
  final num? initialValue;

  /// Minimum allowed value (no limit if null).
  final num? min;

  /// Maximum allowed value (no limit if null).
  final num? max;

  /// Amount to increment/decrement per button press.
  final num step;

  /// Number of decimal places to display. 0 means integer mode.
  final int decimalPlaces;

  /// Hint text shown when the field is empty.
  final String? hintText;

  /// Label suffix (e.g. "px", "%").
  final String? suffix;

  /// Callback when the value changes.
  final ValueChanged<num?>? onChanged;

  /// Whether the field is enabled.
  final bool enabled;

  /// Field width. Defaults to 120.
  final double? width;

  /// Whether to disable zoom scaling.
  final bool disableZoom;

  const FondeNumberField({
    super.key,
    this.initialValue,
    this.min,
    this.max,
    this.step = 1,
    this.decimalPlaces = 0,
    this.hintText,
    this.suffix,
    this.onChanged,
    this.enabled = true,
    this.width,
    this.disableZoom = false,
  });

  @override
  State<FondeNumberField> createState() => _FondeNumberFieldState();
}

class _FondeNumberFieldState extends State<FondeNumberField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  num? _value;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _controller = TextEditingController(
      text: _value != null ? _formatValue(_value!) : '',
    );
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
    if (!_focusNode.hasFocus) {
      _commitText(_controller.text);
    }
  }

  String _formatValue(num value) {
    if (widget.decimalPlaces == 0) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(widget.decimalPlaces);
  }

  num? _parseText(String text) {
    if (text.isEmpty) return null;
    if (widget.decimalPlaces == 0) {
      return int.tryParse(text);
    }
    return double.tryParse(text);
  }

  num _clamp(num value) {
    var v = value;
    if (widget.min != null && v < widget.min!) v = widget.min!;
    if (widget.max != null && v > widget.max!) v = widget.max!;
    return v;
  }

  void _commitText(String text) {
    final parsed = _parseText(text);
    if (parsed == null) {
      // Revert to last valid value
      _controller.text = _value != null ? _formatValue(_value!) : '';
    } else {
      final clamped = _clamp(parsed);
      setState(() => _value = clamped);
      _controller.text = _formatValue(clamped);
      widget.onChanged?.call(clamped);
    }
  }

  void _increment() {
    if (!widget.enabled) return;
    final current = _value ?? (widget.min ?? 0);
    _applyValue(_clamp(current + widget.step));
  }

  void _decrement() {
    if (!widget.enabled) return;
    final current = _value ?? (widget.min ?? 0);
    _applyValue(_clamp(current - widget.step));
  }

  void _applyValue(num value) {
    setState(() => _value = value);
    _controller.text = _formatValue(value);
    widget.onChanged?.call(value);
  }

  bool get _canIncrement {
    if (!widget.enabled) return false;
    if (widget.max == null) return true;
    return (_value ?? (widget.min ?? 0)) < widget.max!;
  }

  Widget _buildEditableText({
    required Color textColor,
    required Color hintColor,
    required double zoomScale,
    required List<TextInputFormatter> formatters,
  }) {
    return FondeTextField(
      controller: _controller,
      focusNode: _focusNode,
      hintText: widget.hintText,
      enabled: widget.enabled,
      readOnly: !widget.enabled,
      style: TextStyle(fontSize: 13.0 * zoomScale, color: textColor),
      textAlign: TextAlign.center,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      inputFormatters: formatters,
      onSubmitted: _commitText,
      cursorColor: textColor,
      cursorWidth: 1.5,
      // Transparent border/background — FondeNumberField provides its own outer frame
      backgroundColor: Colors.transparent,
      borderColor: Colors.transparent,
      activeBorderColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      disableZoom: true,
    );
  }

  bool get _canDecrement {
    if (!widget.enabled) return false;
    if (widget.min == null) return true;
    return (_value ?? (widget.min ?? 0)) > widget.min!;
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final accessibilityConfig = context.fondeAccessibility;
    final zoomScale = widget.disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale =
        widget.disableZoom ? 1.0 : accessibilityConfig.borderScale;

    final height = 32.0 * zoomScale;
    final width = (widget.width ?? 120.0) * zoomScale;
    final buttonWidth = 24.0 * zoomScale;

    final backgroundColor =
        widget.enabled
            ? appColorScheme.interactive.input.background
            : appColorScheme.interactive.input.background.withValues(
              alpha: 0.5,
            );
    final borderColor =
        _isFocused
            ? appColorScheme.interactive.input.focusBorder
            : appColorScheme.interactive.input.border;
    final textColor =
        widget.enabled
            ? appColorScheme.base.foreground
            : appColorScheme.base.foreground.withValues(alpha: 0.4);
    final hintColor = appColorScheme.base.foreground.withValues(alpha: 0.35);
    final iconColor =
        widget.enabled
            ? appColorScheme.base.foreground.withValues(alpha: 0.6)
            : appColorScheme.base.foreground.withValues(alpha: 0.25);
    final dividerColor = appColorScheme.interactive.input.border;

    final List<TextInputFormatter> formatters = [
      if (widget.decimalPlaces == 0)
        FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'))
      else
        FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
    ];

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: SquircleBorder(
            borderRadius: SquircleBorderRadius(
              cornerRadius: 8.0 * zoomScale,
              cornerSmoothing: 0.6,
            ),
            side: BorderSide(color: borderColor, width: 1.5 * borderScale),
          ),
        ),
        child: Row(
          children: [
            // Decrement button
            _StepButton(
              icon: LucideIcons.minus,
              width: buttonWidth,
              height: height,
              enabled: _canDecrement,
              iconColor: iconColor,
              onPressed: _decrement,
              zoomScale: zoomScale,
              isLeft: true,
            ),
            // Divider
            SizedBox(
              height: height * 0.5,
              child: VerticalDivider(
                width: 1,
                thickness: 1 * borderScale,
                color: dividerColor,
              ),
            ),
            // Text field — EditableText handles pointer events directly
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: _buildEditableText(
                        textColor: textColor,
                        hintColor: hintColor,
                        zoomScale: zoomScale,
                        formatters: formatters,
                      ),
                    ),
                    if (widget.suffix != null)
                      Text(
                        widget.suffix!,
                        style: TextStyle(
                          fontSize: 12.0 * zoomScale,
                          color: textColor.withValues(alpha: 0.6),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Divider
            SizedBox(
              height: height * 0.5,
              child: VerticalDivider(
                width: 1,
                thickness: 1 * borderScale,
                color: dividerColor,
              ),
            ),
            // Increment button
            _StepButton(
              icon: LucideIcons.plus,
              width: buttonWidth,
              height: height,
              enabled: _canIncrement,
              iconColor: iconColor,
              onPressed: _increment,
              zoomScale: zoomScale,
              isLeft: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _StepButton extends StatefulWidget {
  const _StepButton({
    required this.icon,
    required this.width,
    required this.height,
    required this.enabled,
    required this.iconColor,
    required this.onPressed,
    required this.zoomScale,
    required this.isLeft,
  });

  final IconData icon;
  final double width;
  final double height;
  final bool enabled;
  final Color iconColor;
  final VoidCallback onPressed;
  final double zoomScale;
  final bool isLeft;

  @override
  State<_StepButton> createState() => _StepButtonState();
}

class _StepButtonState extends State<_StepButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final hoverBg = appColorScheme.interactive.button.background.hover;

    Color? bg;
    if (!widget.enabled) {
      bg = null;
    } else if (_isPressed) {
      bg = appColorScheme.interactive.button.background.active;
    } else if (_isHovered) {
      bg = hoverBg;
    }

    return MouseRegion(
      cursor:
          widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: widget.enabled ? (_) => setState(() => _isHovered = true) : null,
      onExit: widget.enabled ? (_) => setState(() => _isHovered = false) : null,
      child: GestureDetector(
        onTapDown:
            widget.enabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp:
            widget.enabled
                ? (_) {
                  setState(() => _isPressed = false);
                  widget.onPressed();
                }
                : null,
        onTapCancel:
            widget.enabled ? () => setState(() => _isPressed = false) : null,
        child: Container(
          width: widget.width,
          height: widget.height,
          color: bg,
          child: Icon(
            widget.icon,
            size: 12.0 * widget.zoomScale,
            color: widget.iconColor,
          ),
        ),
      ),
    );
  }
}
