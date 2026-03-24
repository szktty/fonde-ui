import 'package:flutter/material.dart';
import '../../internal.dart';

/// A theme-aware slider widget.
///
/// Flutter's default [Slider] does not match fonde-ui's visual style.
/// [FondeSlider] applies the active theme's primary color and uses
/// consistent sizing from the accessibility config.
///
/// Example:
/// ```dart
/// FondeSlider(
///   value: _volume,
///   min: 0.0,
///   max: 1.0,
///   onChanged: (v) => setState(() => _volume = v),
///   label: '${(_volume * 100).round()}%',
/// )
/// ```
class FondeSlider extends StatelessWidget {
  const FondeSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.onChangeStart,
    this.onChangeEnd,
    this.enabled = true,
    this.disableZoom = false,
  });

  /// Current value. Must be within [min] and [max].
  final double value;

  /// Called when the user moves the slider.
  final ValueChanged<double>? onChanged;

  /// Minimum value. Defaults to 0.0.
  final double min;

  /// Maximum value. Defaults to 1.0.
  final double max;

  /// Number of discrete divisions. Null for continuous.
  final int? divisions;

  /// Label shown above the thumb when the user is dragging.
  final String? label;

  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;

  /// Whether the slider is interactive.
  final bool enabled;

  /// Whether to disable zoom scaling.
  final bool disableZoom;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.fondeColorScheme;

    final activeColor = colorScheme.theme.primaryColor;
    final inactiveColor = colorScheme.base.divider;
    final thumbColor = colorScheme.theme.primaryColor;
    final disabledColor = colorScheme.base.border;

    final sliderTheme = SliderThemeData(
      activeTrackColor: enabled ? activeColor : disabledColor,
      inactiveTrackColor:
          enabled ? inactiveColor : disabledColor.withValues(alpha: 0.5),
      thumbColor: enabled ? thumbColor : disabledColor,
      overlayColor: Colors.transparent,
      valueIndicatorColor: colorScheme.uiAreas.dialog.background,
      valueIndicatorTextStyle: TextStyle(
        color: colorScheme.uiAreas.dialog.foreground,
        fontSize: 12.0,
      ),
      trackHeight: 3.0,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
      tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 2.0),
      activeTickMarkColor: activeColor.withValues(alpha: 0.6),
      inactiveTickMarkColor: inactiveColor,
    );

    return SliderTheme(
      data: sliderTheme,
      child: Slider(
        value: value.clamp(min, max),
        min: min,
        max: max,
        divisions: divisions,
        label: label,
        onChanged: enabled ? onChanged : null,
        onChangeStart: enabled ? onChangeStart : null,
        onChangeEnd: enabled ? onChangeEnd : null,
      ),
    );
  }
}

/// A range slider variant that allows selecting a range of values.
class FondeRangeSlider extends StatelessWidget {
  const FondeRangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.labels,
    this.onChangeStart,
    this.onChangeEnd,
    this.enabled = true,
    this.disableZoom = false,
  });

  final RangeValues values;
  final ValueChanged<RangeValues>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final RangeLabels? labels;
  final ValueChanged<RangeValues>? onChangeStart;
  final ValueChanged<RangeValues>? onChangeEnd;
  final bool enabled;
  final bool disableZoom;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.fondeColorScheme;

    final activeColor = colorScheme.theme.primaryColor;
    final inactiveColor = colorScheme.base.divider;
    final thumbColor = colorScheme.theme.primaryColor;
    final disabledColor = colorScheme.base.border;

    final sliderTheme = SliderThemeData(
      activeTrackColor: enabled ? activeColor : disabledColor,
      inactiveTrackColor:
          enabled ? inactiveColor : disabledColor.withValues(alpha: 0.5),
      thumbColor: enabled ? thumbColor : disabledColor,
      overlayColor: Colors.transparent,
      valueIndicatorColor: colorScheme.uiAreas.dialog.background,
      valueIndicatorTextStyle: TextStyle(
        color: colorScheme.uiAreas.dialog.foreground,
        fontSize: 12.0,
      ),
      trackHeight: 3.0,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
    );

    return SliderTheme(
      data: sliderTheme,
      child: RangeSlider(
        values: RangeValues(
          values.start.clamp(min, max),
          values.end.clamp(min, max),
        ),
        min: min,
        max: max,
        divisions: divisions,
        labels: labels,
        onChanged: enabled ? onChanged : null,
        onChangeStart: enabled ? onChangeStart : null,
        onChangeEnd: enabled ? onChangeEnd : null,
      ),
    );
  }
}
