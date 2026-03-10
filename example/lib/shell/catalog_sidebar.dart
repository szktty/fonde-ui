import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Catalog category definitions
class CatalogCategory {
  const CatalogCategory({
    required this.id,
    required this.label,
    required this.items,
  });

  final String id;
  final String label;
  final List<CatalogItem> items;
}

class CatalogItem {
  const CatalogItem({required this.id, required this.label});

  final String id;
  final String label;
}

const catalogCategories = [
  CatalogCategory(
    id: 'buttons',
    label: 'Buttons',
    items: [
      CatalogItem(id: 'fonde_button', label: 'Button'),
      CatalogItem(id: 'fonde_icon_button', label: 'Icon Button'),
      CatalogItem(id: 'fonde_segmented_button', label: 'Segmented Button'),
      CatalogItem(id: 'fonde_split_button', label: 'Split Button'),
    ],
  ),
  CatalogCategory(
    id: 'menus',
    label: 'Menus',
    items: [
      CatalogItem(id: 'fonde_context_menu', label: 'Context Menu'),
      CatalogItem(id: 'fonde_overflow_menu', label: 'Overflow Menu'),
      CatalogItem(id: 'fonde_dropdown_menu', label: 'Dropdown Menu'),
    ],
  ),
  CatalogCategory(
    id: 'input',
    label: 'Input',
    items: [
      CatalogItem(id: 'fonde_text_field', label: 'Text Field'),
      CatalogItem(id: 'fonde_search_field', label: 'Search Field'),
      CatalogItem(id: 'fonde_tags_field', label: 'Tags Field'),
      CatalogItem(id: 'fonde_checkbox', label: 'Checkbox'),
    ],
  ),
  CatalogCategory(
    id: 'typography',
    label: 'Typography',
    items: [CatalogItem(id: 'fonde_text', label: 'Text')],
  ),
  CatalogCategory(
    id: 'navigation',
    label: 'Navigation',
    items: [
      CatalogItem(id: 'navigation_overview', label: 'Navigation'),
      CatalogItem(id: 'launch_bar', label: 'Launch Bar'),
      CatalogItem(id: 'sidebar_list', label: 'Sidebar List'),
    ],
  ),
  CatalogCategory(
    id: 'layout',
    label: 'Layout',
    items: [
      CatalogItem(id: 'tab_view', label: 'Tab View'),
      CatalogItem(id: 'outline_view', label: 'Outline View'),
      CatalogItem(id: 'table_view', label: 'Table View'),
      CatalogItem(id: 'fonde_panel', label: 'Panel'),
      CatalogItem(id: 'fonde_list_tile', label: 'List Tile'),
    ],
  ),
  CatalogCategory(
    id: 'feedback',
    label: 'Feedback',
    items: [
      CatalogItem(id: 'fonde_dialog', label: 'Dialog'),
      CatalogItem(id: 'fonde_toast', label: 'Toast'),
      CatalogItem(id: 'fonde_popover', label: 'Popover'),
      CatalogItem(id: 'fonde_progress_indicator', label: 'Progress Indicator'),
    ],
  ),
  CatalogCategory(
    id: 'interaction',
    label: 'Interaction',
    items: [
      CatalogItem(id: 'gesture_detector', label: 'Gesture Detector'),
      CatalogItem(id: 'selection_decorator', label: 'Selection Decorator'),
    ],
  ),
  CatalogCategory(
    id: 'platform',
    label: 'Platform',
    items: [CatalogItem(id: 'platform_menus', label: 'Platform Menus')],
  ),
];

/// Catalog navigation displayed in the sidebar
class CatalogSidebar extends ConsumerWidget {
  const CatalogSidebar({
    super.key,
    required this.selectedItemId,
    required this.expandedGroupIds,
    required this.onItemSelected,
    required this.onGroupToggled,
  });

  final String? selectedItemId;
  final List<String> expandedGroupIds;
  final void Function(String? itemId) onItemSelected;
  final void Function(String groupId) onGroupToggled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FondeSidebarList(
      selectedItemId: selectedItemId,
      expandedGroupIds: expandedGroupIds,
      onItemSelected: onItemSelected,
      onGroupToggled: onGroupToggled,
      children: [
        FondeSidebarListItem(
          id: '_welcome',
          title: 'Welcome',
          leading: const Icon(LucideIcons.house, size: 16),
        ),
        for (final category in catalogCategories)
          FondeSidebarListGroup(
            id: category.id,
            title: category.label,
            isExpanded: expandedGroupIds.contains(category.id),
            children: [
              for (final item in category.items)
                FondeSidebarListItem(id: item.id, title: item.label),
            ],
          ),
      ],
    );
  }
}
