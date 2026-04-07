import 'package:flutter/material.dart';
import '../../internal.dart';
import '../../core/context_extensions.dart';

/// App-specific page indicator.
///
/// Displays a row (or column) of dots representing pages, with the active dot
/// highlighted in the theme's primary color.
class FondePageIndicator extends StatelessWidget {
  /// Constructs the page indicator.
  ///
  /// [dotsCount] specifies the total number of pages, and [position] specifies
  /// the current page position (starting from 0).
  const FondePageIndicator({
    super.key,
    required this.dotsCount,
    required this.position,
    this.onDotTapped,
    this.axis = Axis.horizontal,
    this.dotSize = 6.0,
    this.dotSpacing = 15.0,
    this.mainAxisSize = MainAxisSize.min,
  });

  /// Total number of dots (number of pages).
  final int dotsCount;

  /// Position of the current active dot (0-based).
  final double position;

  /// Callback when a dot is tapped.
  final Function(int)? onDotTapped;

  /// Orientation of the dots (horizontal or vertical).
  final Axis axis;

  /// Size of each dot.
  final double dotSize;

  /// Spacing between dots.
  final double dotSpacing;

  /// Size of the main axis.
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final inactiveColor = appColorScheme.interactive.input.border;
    final activeColor = appColorScheme.theme.primaryColor;

    final dots = List.generate(dotsCount, (index) {
      final isActive = index == position.round();
      final size = isActive ? dotSize + 2.0 : dotSize;
      Widget dot = GestureDetector(
        onTap: onDotTapped != null ? () => onDotTapped!(index) : null,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            shape: BoxShape.circle,
          ),
        ),
      );

      final padding = dotSpacing / 2;
      dot = Padding(
        padding:
            axis == Axis.horizontal
                ? EdgeInsets.symmetric(horizontal: padding)
                : EdgeInsets.symmetric(vertical: padding),
        child: dot,
      );

      return dot;
    });

    if (axis == Axis.horizontal) {
      return Row(mainAxisSize: mainAxisSize, children: dots);
    } else {
      return Column(mainAxisSize: mainAxisSize, children: dots);
    }
  }
}
