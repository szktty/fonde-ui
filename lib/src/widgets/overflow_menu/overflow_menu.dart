import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal.dart';
import '../icons/icon_theme_providers.dart';
import '../widgets/fonde_popup_menu.dart';
import '../widgets/fonde_icon_button.dart';

/// Menu that contains features that cannot be displayed due to screen size.
///
/// Displays items that cannot be shown when screen size becomes small as a
/// dropdown menu triggered by a "more" icon button.
class FondeOverflowMenu extends ConsumerWidget {
  /// List of items to display in menu.
  final List<FondeOverflowMenuEntry> items;

  /// Menu icon (defaults to moreVert from the active icon theme).
  final IconData? icon;

  /// Icon color.
  final Color? iconColor;

  /// Icon size.
  final double iconSize;

  /// Menu description (tooltip).
  final String? tooltip;

  /// Whether to disable zoom functionality.
  final bool disableZoom;

  const FondeOverflowMenu({
    super.key,
    required this.items,
    this.icon,
    this.iconColor,
    this.iconSize = 18.0,
    this.tooltip,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconTheme = ref.watch(fondeDefaultIconThemeProvider);
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);

    final popupEntries =
        items.map<FondePopupMenuEntry<String>>((entry) {
          if (entry is FondeOverflowMenuDivider) {
            return const FondePopupMenuDividerEntry();
          }
          final item = entry as FondeOverflowMenuItem;
          return FondePopupMenuItemEntry(
            FondePopupMenuItem<String>(
              value: item.value,
              title: item.title,
              icon: item.icon,
              enabled: item.enabled,
              onSelected: item.onSelected,
            ),
          );
        }).toList();

    return FondePopupMenu<String>(
      items: popupEntries,
      tooltip: tooltip,
      disableZoom: disableZoom,
      child: FondeIconButton(
        icon: icon ?? iconTheme.moreVert,
        iconSize: iconSize,
        iconColor:
            iconColor ?? colorScheme.base.foreground.withValues(alpha: 0.7),
      ),
    );
  }
}

/// Base class for overflow menu entries.
abstract class FondeOverflowMenuEntry {
  const FondeOverflowMenuEntry();
}

/// An item in an overflow menu.
class FondeOverflowMenuItem extends FondeOverflowMenuEntry {
  /// Item title.
  final String title;

  /// Value identifying this item.
  final String value;

  /// Icon to display (optional).
  final IconData? icon;

  /// Whether the item is selectable.
  final bool enabled;

  /// Callback when the item is selected.
  final VoidCallback? onSelected;

  const FondeOverflowMenuItem({
    required this.title,
    required this.value,
    this.icon,
    this.enabled = true,
    this.onSelected,
  });
}

/// A divider in an overflow menu.
class FondeOverflowMenuDivider extends FondeOverflowMenuEntry {
  const FondeOverflowMenuDivider();
}
