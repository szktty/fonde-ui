import 'package:flutter/material.dart';
import '../../core/context_extensions.dart';
import '../../internal.dart';

/// Visual style of [FondeSwitch].
enum FondeSwitchStyle {
  /// Compact style: 36×20px track, 16px circular knob.
  /// Default. Suitable for high-density desktop UIs.
  compact,

  /// Wide style: 52×28px track, pill-shaped knob (36×22px).
  /// Higher visual prominence. Corner radius is fully rounded.
  wide,
}

/// A toggle switch widget for Fonde UI.
///
/// Supports two visual styles ([FondeSwitchStyle.compact] and
/// [FondeSwitchStyle.wide]) and animates the knob position and track color
/// on state change. The animation is always enabled because an instant
/// transition is visually jarring; a gentle slide reduces eye strain.
///
/// Example:
/// ```dart
/// FondeSwitch(
///   value: isEnabled,
///   onChanged: (v) => setState(() => isEnabled = v),
/// )
/// ```
class FondeSwitch extends StatefulWidget {
  /// Current value of the switch.
  final bool value;

  /// Called when the user toggles the switch. Pass `null` to disable.
  final ValueChanged<bool>? onChanged;

  /// Visual style of the switch track and knob.
  final FondeSwitchStyle style;

  /// Focus node.
  final FocusNode? focusNode;

  /// Whether the switch should request focus on mount.
  final bool autofocus;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  /// Whether to opt out of zoom scaling.
  final bool disableZoom;

  const FondeSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.style = FondeSwitchStyle.compact,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.disableZoom = false,
  });

  @override
  State<FondeSwitch> createState() => _FondeSwitchState();
}

class _FondeSwitchState extends State<FondeSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<Color?> _colorAnimation;

  static const Duration _animationDuration = Duration(milliseconds: 300);

  // Compact dimensions (unscaled)
  static const double _compactTrackWidth = 32.0;
  static const double _compactTrackHeight = 20.0;
  static const double _compactKnobSize = 16.0;
  static const double _compactKnobMargin = 2.0;

  // Wide dimensions (unscaled)
  static const double _wideTrackWidth = 38.0;
  static const double _wideTrackHeight = 18.0;
  static const double _wideKnobWidth = 22.0;
  static const double _wideKnobHeight = 14.0;
  static const double _wideKnobMarginV = 2.0;
  static const double _wideKnobMarginH = 2.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
      value: widget.value ? 1.0 : 0.0,
    );
    _positionAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(FondeSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onChanged?.call(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final accessibilityConfig = context.fondeAccessibility;

    final zoomScale = widget.disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final isEnabled = widget.onChanged != null;

    final Color trackOnColor = appColorScheme.theme.primaryColor;
    final Color trackOffColor = appColorScheme.base.border;
    final Color knobColor = appColorScheme.interactive.button.primaryText;

    _colorAnimation = ColorTween(
      begin: trackOffColor,
      end: trackOnColor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    final Widget switchWidget;
    if (widget.style == FondeSwitchStyle.compact) {
      switchWidget = _buildCompact(
        zoomScale: zoomScale,
        trackOnColor: trackOnColor,
        trackOffColor: trackOffColor,
        knobColor: knobColor,
        isEnabled: isEnabled,
      );
    } else {
      switchWidget = _buildWide(
        zoomScale: zoomScale,
        trackOnColor: trackOnColor,
        trackOffColor: trackOffColor,
        knobColor: knobColor,
        isEnabled: isEnabled,
      );
    }

    return GestureDetector(
      onTap: isEnabled ? _handleTap : null,
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        child: Semantics(
          label: widget.semanticLabel,
          toggled: widget.value,
          enabled: isEnabled,
          child: MouseRegion(
            cursor:
                isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
            child: Opacity(opacity: isEnabled ? 1.0 : 0.4, child: switchWidget),
          ),
        ),
      ),
    );
  }

  Widget _buildCompact({
    required double zoomScale,
    required Color trackOnColor,
    required Color trackOffColor,
    required Color knobColor,
    required bool isEnabled,
  }) {
    final trackWidth = _compactTrackWidth * zoomScale;
    final trackHeight = _compactTrackHeight * zoomScale;
    final knobSize = _compactKnobSize * zoomScale;
    final knobMargin = _compactKnobMargin * zoomScale;
    final trackRadius = trackHeight / 2;
    // Travel distance: track width - knob size - margins on both sides
    final travel = trackWidth - knobSize - knobMargin * 2;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final trackColor = _colorAnimation.value ?? trackOffColor;
        final knobOffset = knobMargin + _positionAnimation.value * travel;

        return SizedBox(
          width: trackWidth,
          height: trackHeight,
          child: Stack(
            children: [
              // Track
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: trackColor,
                    borderRadius: BorderRadius.circular(trackRadius),
                  ),
                ),
              ),
              // Knob
              Positioned(
                left: knobOffset,
                top: knobMargin,
                child: Container(
                  width: knobSize,
                  height: knobSize,
                  decoration: BoxDecoration(
                    color: knobColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x33000000),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWide({
    required double zoomScale,
    required Color trackOnColor,
    required Color trackOffColor,
    required Color knobColor,
    required bool isEnabled,
  }) {
    final trackWidth = _wideTrackWidth * zoomScale;
    final trackHeight = _wideTrackHeight * zoomScale;
    final knobWidth = _wideKnobWidth * zoomScale;
    final knobHeight = _wideKnobHeight * zoomScale;
    final knobMarginV = _wideKnobMarginV * zoomScale;
    final knobMarginH = _wideKnobMarginH * zoomScale;
    final trackRadius = trackHeight / 2;
    final knobRadius = knobHeight / 2;
    // Travel distance: track width - knob width - horizontal margins on both sides
    final travel = trackWidth - knobWidth - knobMarginH * 2;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final trackColor = _colorAnimation.value ?? trackOffColor;
        final knobOffset = knobMarginH + _positionAnimation.value * travel;

        return SizedBox(
          width: trackWidth,
          height: trackHeight,
          child: Stack(
            children: [
              // Track
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: trackColor,
                    borderRadius: BorderRadius.circular(trackRadius),
                  ),
                ),
              ),
              // Knob (pill shape)
              Positioned(
                left: knobOffset,
                top: knobMarginV,
                child: Container(
                  width: knobWidth,
                  height: knobHeight,
                  decoration: BoxDecoration(
                    color: knobColor,
                    borderRadius: BorderRadius.circular(knobRadius),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x33000000),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
