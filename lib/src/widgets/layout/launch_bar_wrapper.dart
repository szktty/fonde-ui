import 'package:flutter/material.dart';

/// Wrapper widget for the launch bar.
///
/// Applies a fixed width constraint to the launch bar and supports zoom scaling.
class FondeLaunchBarWrapper extends StatelessWidget {
  const FondeLaunchBarWrapper({
    required this.child,
    this.zoomScale = 1.0,
    this.width = 44.0,
    super.key,
  });

  /// The widget for the launch bar.
  final Widget child;

  /// The zoom scale.
  final double zoomScale;

  /// The width of the launch bar (default: 44px).
  final double width;

  @override
  Widget build(BuildContext context) {
    final scaledWidth = width * zoomScale;

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: scaledWidth, maxWidth: scaledWidth),
      child: child,
    );
  }
}
