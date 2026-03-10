import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal.dart'; // Import ThemeConfig and fondeEffectiveColorSchemeProvider

/// A widget that displays the main content area of the application.
///
/// Applies the appropriate background color based on the theme settings.
class FondeMainContentArea extends ConsumerWidget {
  /// The content to display.
  final Widget child;

  const FondeMainContentArea({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the effective FondeColorScheme
    final appColorScheme = ref.watch(fondeEffectiveColorSchemeProvider);

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
