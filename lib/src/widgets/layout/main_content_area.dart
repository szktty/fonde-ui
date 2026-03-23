import 'package:flutter/material.dart';
import '../../core/context_extensions.dart';
import '../../internal.dart';

/// A widget that displays the main content area of the application.
///
/// Applies the appropriate background color based on the theme settings.
class FondeMainContentArea extends StatelessWidget {
  /// The content to display.
  final Widget child;

  const FondeMainContentArea({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    // Get the effective FondeColorScheme
    final appColorScheme = context.fondeColorScheme;

    // Determine the background color of the main content area
    final backgroundColor = appColorScheme.base.background;

    // Add debug log
    // print(
    //   'MainContentArea: selected=${selectedThemeConfig.name}, '
    //   'brightness=$currentBrightness, '
    //   'bgColor=$backgroundColor, '
    //   'fallbackSurface=${Theme.of(context).colorScheme.surface}'
    // );

    return Material(color: backgroundColor, child: child);
  }
}
