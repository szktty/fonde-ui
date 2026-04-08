import 'package:flutter/material.dart';
import '../../internal.dart';
import 'fonde_rectangle_border.dart';
import '../styling/fonde_border.dart';

/// A themed segmented button that automatically applies colors from FondeColorConfig.
class FondeSegmentedButton<T extends Object> extends StatelessWidget {
  /// The set of segments currently selected.
  final Set<T> selected;

  /// The configuration for each segment in the button.
  final List<ButtonSegment<T>> segments;

  /// The callback that is called when the selection changes.
  final ValueChanged<Set<T>> onSelectionChanged;

  /// Whether to disable zoom functionality.
  final bool disableZoom;

  /// Creates a themed segmented button.
  const FondeSegmentedButton({
    required this.selected,
    required this.segments,
    required this.onSelectionChanged,
    this.disableZoom = false,
    super.key,
    // TODO: Add other SegmentedButton properties if needed
  });

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final accessibilityConfig = context.fondeAccessibility;
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = disableZoom ? 1.0 : accessibilityConfig.borderScale;

    return SegmentedButton<T>(
      segments: segments,
      selected: selected,
      onSelectionChanged: onSelectionChanged,
      showSelectedIcon: false, // Disable checkbox display
      style: SegmentedButton.styleFrom(
        // Use base background color
        backgroundColor: appColorScheme.base.background,
        // Use theme color when selected
        selectedBackgroundColor: appColorScheme.theme.primaryColor.withValues(
          alpha: 0.1,
        ),
        // Text color when not selected
        foregroundColor: appColorScheme.base.foreground,
        // Text color when selected (theme color)
        selectedForegroundColor: appColorScheme.theme.primaryColor,
        side: BorderSide(
          // Border color
          color: appColorScheme.base.border,
          width: FondeBorderWidth.medium * borderScale,
        ),
        // Conforms to design guidelines: Build shape from context
        // Prevent animation: Use consistent shape object
        shape: SquircleBorder(
          borderRadius: SquircleBorderRadius(
            cornerRadius: 8.0,
            cornerSmoothing: 0.6,
          ),
          side: BorderSide(color: appColorScheme.base.border, width: 1.5),
        ),
        // TextStyle conforming to FondeTextVariant (zoom support is automatic)
        textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontSize:
              (Theme.of(context).textTheme.labelMedium?.fontSize ?? 14.0) *
              zoomScale,
        ),
        // Zoom support: Icon size is also adjusted
        iconSize: 18.0 * zoomScale,
        // Zoom support: Ensure minimum tap target size (design guideline: 44px or more)
        minimumSize: Size(44.0 * zoomScale, 44.0 * zoomScale),
        // Disable animation: Prevent unnecessary animation during zoom
        animationDuration: Duration.zero,
        // Disable ripple animation: Disable ripple effect on tap
        splashFactory: NoSplash.splashFactory,
      ),
    );
  }
}
