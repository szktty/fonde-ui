import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../internal.dart';

part 'fonde_list_tile.g.dart';

/// Provider that supplies an effective FondeColorScheme.
@riverpod
FondeColorScheme effectiveAppColorSchemeForListTile(Ref ref) {
  return FondeThemePresets.light.appColorScheme;
}

/// A list tile that handles selection state and applies appropriate theme colors.
class FondeListTile extends ConsumerWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool dense;
  final EdgeInsetsGeometry? contentPadding;
  final bool enableHover;
  final Color? hoverColor;

  /// Whether to disable zoom functionality.
  final bool disableZoom;

  const FondeListTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    required this.isSelected,
    this.onTap,
    this.onLongPress,
    this.dense = false,
    this.contentPadding,
    this.enableHover = true,
    this.hoverColor,
    this.disableZoom = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get FondeColorScheme and accessibility config
    final appColorScheme = ref.watch(effectiveColorSchemeWithThemeProvider);
    final accessibilityConfig = ref.watch(fondeAccessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    // Determine hover color (temporary implementation)
    final theme = Theme.of(context);
    final effectiveHoverColor = enableHover
        ? (hoverColor ?? theme.hoverColor)
        : Colors.transparent;

    return ListTile(
      leading: leading,
      trailing: trailing,
      title: title,
      subtitle: subtitle,
      selected: isSelected,
      selectedTileColor: appColorScheme.interactive.list.selectedBackground,
      selectedColor: appColorScheme.interactive.list.selectedText,
      hoverColor: effectiveHoverColor,
      splashColor: Colors.transparent,
      //highlightColor: Colors.transparent,
      enabled: onTap != null,
      onTap: onTap,
      onLongPress: onLongPress,
      dense: dense,
      contentPadding: contentPadding != null
          ? contentPadding! * zoomScale
          : null,
    );
  }
}
