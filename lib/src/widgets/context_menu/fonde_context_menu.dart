import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal.dart';
import '../icons/icon_theme_providers.dart';

/// A context menu item.
class FondeContextMenuItem {
  /// Item label
  final String label;

  /// Callback when item is pressed
  final VoidCallback onPressed;

  /// Whether this item represents a dangerous operation (displayed in error color)
  final bool isDangerous;

  /// Whether this item is enabled
  final bool enabled;

  /// Create [FondeContextMenuItem]
  const FondeContextMenuItem({
    required this.label,
    required this.onPressed,
    this.isDangerous = false,
    this.enabled = true,
  });
}

/// A divider for use in a [FondeContextMenu] items list.
class FondeContextMenuDivider extends FondeContextMenuItem {
  /// Create [FondeContextMenuDivider]
  const FondeContextMenuDivider()
    : super(label: '', onPressed: _noop, enabled: false);

  static void _noop() {}
}

/// A generic context menu widget based on [MenuAnchor].
///
/// The trigger widget is provided via [builder], making this widget
/// usable with any trigger (button, right-click, long-press, etc.).
///
/// For a ready-made icon button trigger, use [FondeContextMenuButton].
class FondeContextMenu extends ConsumerStatefulWidget {
  /// List of menu items
  final List<FondeContextMenuItem> items;

  /// Builds the widget that triggers the menu.
  ///
  /// Call [controller.open] / [controller.close] to control the menu.
  final Widget Function(
    BuildContext context,
    MenuController controller,
    Widget? child,
  )
  builder;

  /// Create [FondeContextMenu]
  const FondeContextMenu({
    super.key,
    required this.items,
    required this.builder,
  });

  @override
  ConsumerState<FondeContextMenu> createState() => _FondeContextMenuState();
}

class _FondeContextMenuState extends ConsumerState<FondeContextMenu> {
  @override
  Widget build(BuildContext context) {
    final appColorScheme = ref.watch(fondeEffectiveColorSchemeProvider);

    return MenuAnchor(
      builder: widget.builder,
      menuChildren: widget.items.map((item) {
        if (item is FondeContextMenuDivider) {
          return const Divider(height: 1);
        }
        return MenuItemButton(
          onPressed: item.enabled ? item.onPressed : null,
          child: Text(
            item.label,
            style: TextStyle(
              color: item.isDangerous
                  ? appColorScheme.status.error
                  : item.enabled
                  ? null
                  : appColorScheme.uiAreas.sideBar.inactiveItemText,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// A context menu with an icon button as the trigger.
///
/// A convenience wrapper around [FondeContextMenu] that uses an [IconButton]
/// (defaulting to the "more vertical" icon) to open the menu.
class FondeContextMenuButton extends ConsumerWidget {
  /// List of menu items
  final List<FondeContextMenuItem> items;

  /// Icon to display (defaults to moreVert from the active icon theme)
  final IconData? icon;

  /// Icon color
  final Color? iconColor;

  /// Icon size
  final double iconSize;

  /// Tooltip for the button
  final String? tooltip;

  /// Create [FondeContextMenuButton]
  const FondeContextMenuButton({
    super.key,
    required this.items,
    this.icon,
    this.iconColor,
    this.iconSize = 24.0,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    final iconTheme = ref.watch(fondeDefaultIconThemeProvider);

    return FondeContextMenu(
      items: items,
      builder: (context, controller, child) {
        return IconButton(
          tooltip: tooltip,
          icon: Icon(
            icon ?? iconTheme.moreVert,
            color: iconColor ?? appColorScheme.uiAreas.sideBar.inactiveItemText,
            size: iconSize,
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
    );
  }
}
