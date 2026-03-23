import 'package:flutter/material.dart';
import '../../core/context_extensions.dart';
import '../../internal.dart';

/// A header element that represents a section.
class FondeSidebarListHeader extends StatelessWidget {
  /// The unique identifier for the header.
  final String id;

  /// The title of the header.
  final String title;

  /// The text style for the title.
  final TextStyle? titleStyle;

  /// The padding.
  final EdgeInsets padding;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  /// Creates a new [FondeSidebarListHeader].
  ///
  /// [id] - The unique identifier for the header.
  /// [title] - The title to display.
  /// [titleStyle] - The text style for the title.
  /// [padding] - The padding.
  const FondeSidebarListHeader({
    required this.id,
    required this.title,
    this.titleStyle,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 8),
    this.disableZoom = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final zoomScale = disableZoom ? 1.0 : context.fondeZoomScale;

    final theme = Theme.of(context);
    final effectiveTitleStyle =
        titleStyle ??
        theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.secondary,
        );

    return Padding(
      padding: padding * zoomScale,
      child: Text(title, style: effectiveTitleStyle),
    );
  }
}
