import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:fonde_ui/fonde_ui_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../pages/button_page.dart';
import '../pages/icon_button_page.dart';
import '../pages/segmented_button_page.dart';
import '../pages/split_button_page.dart';
import '../pages/context_menu_page.dart';
import '../pages/text_field_page.dart';
import '../pages/search_field_page.dart';
import '../pages/tags_field_page.dart';
import '../pages/number_field_page.dart';
import '../pages/date_picker_page.dart';
import '../pages/checkbox_page.dart';
import '../pages/radio_button_page.dart';
import '../pages/dropdown_menu_page.dart';
import '../pages/typography_page.dart';
import '../pages/tab_view_page.dart';
import '../pages/outline_view_page.dart';
import '../pages/table_view_page.dart';
import '../pages/dialog_page.dart';
import '../pages/toast_page.dart';
import '../pages/popover_page.dart';
import '../pages/progress_page.dart';
import '../pages/gesture_detector_page.dart';
import '../pages/selection_decorator_page.dart';
import '../pages/panel_page.dart';
import '../pages/list_tile_page.dart';
import '../pages/overflow_menu_page.dart';
import '../pages/platform_menus_page.dart';
import '../pages/sidebar_list_page.dart';
import '../pages/launch_bar_page.dart';
import '../pages/navigation_page.dart';
import '../pages/placeholder_page.dart';
import '../pages/status_bar_page.dart';
import '../pages/shortcut_scope_page.dart';
import '../pages/tooltip_page.dart';
import '../pages/draggable_page.dart';
import '../pages/split_pane_page.dart';
import '../pages/slider_page.dart';
import '../pages/notification_overlay_page.dart';
import '../pages/color_picker_page.dart';
import '../pages/rectangle_border_page.dart';
import 'catalog_sidebar.dart';
import 'catalog_toolbar.dart';
import 'catalog_welcome.dart';

class CatalogShell extends ConsumerStatefulWidget {
  const CatalogShell({super.key});

  @override
  ConsumerState<CatalogShell> createState() => _CatalogShellState();
}

class _CatalogShellState extends ConsumerState<CatalogShell> {
  String? _selectedItemId;
  List<String> _expandedGroupIds = catalogCategories.map((c) => c.id).toList();
  int _launchBarIndex = 0;
  FondeSidebarStyle _sidebarStyle = FondeSidebarStyle.standard;

  Widget _buildPrimarySidebar() {
    final toolbar = _CatalogSidebarToolbar(
      sidebarStyle: _sidebarStyle,
      onSidebarStyleChanged: (style) => setState(() => _sidebarStyle = style),
    );
    final list = CatalogSidebar(
      selectedItemId: _selectedItemId ?? '_welcome',
      expandedGroupIds: _expandedGroupIds,
      onItemSelected:
          (id) =>
              setState(() => _selectedItemId = id == '_welcome' ? null : id),
      onGroupToggled:
          (id) => setState(() {
            if (_expandedGroupIds.contains(id)) {
              _expandedGroupIds = List.of(_expandedGroupIds)..remove(id);
            } else {
              _expandedGroupIds = List.of(_expandedGroupIds)..add(id);
            }
          }),
    );
    return FondeSidebar(style: _sidebarStyle, toolbar: toolbar, child: list);
  }

  Widget _buildContent() {
    return switch (_selectedItemId) {
      // Buttons
      'fonde_button' => const ButtonPage(),
      'fonde_icon_button' => const IconButtonPage(),
      'fonde_segmented_button' => const SegmentedButtonPage(),
      'fonde_split_button' => const SplitButtonPage(),
      'fonde_context_menu' => const ContextMenuPage(),
      'fonde_overflow_menu' => const OverflowMenuPage(),
      // Input
      'fonde_text_field' => const TextFieldPage(),
      'fonde_search_field' => const SearchFieldPage(),
      'fonde_tags_field' => const TagsFieldPage(),
      'fonde_number_field' => const NumberFieldPage(),
      'fonde_date_picker' => const DatePickerPage(),
      'fonde_checkbox' => const CheckboxPage(),
      'fonde_radio_button' => const RadioButtonPage(),
      'fonde_dropdown_menu' => const DropdownMenuPage(),
      // Typography
      'fonde_text' => const TypographyPage(),
      // Navigation
      'navigation_overview' => const NavigationPage(),
      'launch_bar' => const LaunchBarPage(),
      'sidebar_list' => const SidebarListPage(),
      // Layout
      'tab_view' => const TabViewPage(),
      'outline_view' => const OutlineViewPage(),
      'table_view' => const TableViewPage(),
      // Feedback
      'fonde_dialog' => const DialogPage(),
      'fonde_toast' => const ToastPage(),
      'fonde_popover' => const PopoverPage(),
      'fonde_progress_indicator' => const ProgressPage(),
      // Decoration
      'gesture_detector' => const GestureDetectorPage(),
      'selection_decorator' => const SelectionDecoratorPage(),
      'fonde_panel' => const PanelPage(),
      'fonde_list_tile' => const ListTilePage(),
      // New components
      'fonde_status_bar' => const StatusBarPage(),
      'fonde_shortcut_scope' => const ShortcutScopePage(),
      'fonde_tooltip' => const TooltipPage(),
      'fonde_draggable' => const DraggablePage(),
      'fonde_split_pane' => const SplitPanePage(),
      'fonde_slider' => const SliderPage(),
      'fonde_notification_overlay' => const NotificationOverlayPage(),
      'fonde_color_picker' => const ColorPickerPage(),
      // Visual
      'fonde_rectangle_border' => const RectangleBorderPage(),
      // Platform
      'platform_menus' => const PlatformMenusPage(),
      // Other: dummy pages
      null => const CatalogWelcomePage(),
      final id => PlaceholderPage(title: _labelFor(id)),
    };
  }

  String _labelFor(String id) {
    for (final category in catalogCategories) {
      for (final item in category.items) {
        if (item.id == id) return item.label;
      }
    }
    return id;
  }

  bool get _isDesktop =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux);

  @override
  Widget build(BuildContext context) {
    final body = FondeScaffold(
      toolbar: FondeMainToolbar(
        center: const SizedBox.shrink(),
        trailing: CatalogToolbarControls(),
      ),
      launchBar: FondeLaunchBar(
        selectedIndex: _launchBarIndex,
        topItems: [
          FondeLaunchBarItem(
            icon: LucideIcons.layoutGrid,
            label: 'Components',
            logicalIndex: 0,
            onTap: () => setState(() => _launchBarIndex = 0),
          ),
          FondeLaunchBarItem(
            icon: LucideIcons.search,
            label: 'Search',
            logicalIndex: 1,
            onTap: () => setState(() => _launchBarIndex = 1),
          ),
          FondeLaunchBarItem(
            icon: LucideIcons.gitBranch,
            label: 'Source Control',
            logicalIndex: 2,
            onTap: () => setState(() => _launchBarIndex = 2),
          ),
          FondeLaunchBarItem(
            icon: LucideIcons.zap,
            label: 'Debug',
            logicalIndex: 3,
            onTap: () => setState(() => _launchBarIndex = 3),
          ),
        ],
        bottomItems: [
          FondeLaunchBarItem(
            icon: LucideIcons.settings2,
            label: 'Settings',
            logicalIndex: 10,
            onTap: () => setState(() => _launchBarIndex = 10),
          ),
        ],
      ),
      showPrimarySidebar: _launchBarIndex == 0,
      primarySidebar: _buildPrimarySidebar(),
      content:
          _launchBarIndex == 0
              ? _buildContent()
              : _LaunchBarPlaceholder(index: _launchBarIndex),
    );
    if (!_isDesktop) return body;
    final menus = FondePlatformMenus(context: context);
    return PlatformMenuBar(
      menus: [
        menus.appMenu(appName: 'Fonde UI Catalog'),
        PlatformMenu(
          label: 'File',
          menus: [
            PlatformMenuItemGroup(members: menus.fileSaveItems()),
            PlatformMenuItemGroup(members: menus.filePrintItems()),
          ],
        ),
        PlatformMenu(
          label: 'Edit',
          menus: [
            PlatformMenuItemGroup(members: menus.editUndoItems()),
            PlatformMenuItemGroup(members: menus.editClipboardItems()),
            PlatformMenuItemGroup(members: menus.editFindItems()),
          ],
        ),
        PlatformMenu(
          label: 'View',
          menus: [
            PlatformMenuItemGroup(members: menus.viewZoomItems()),
            PlatformMenuItemGroup(members: menus.viewFullScreenItems()),
          ],
        ),
        menus.windowMenu(),
      ],
      child: body,
    );
  }
}

class _LaunchBarPlaceholder extends ConsumerWidget {
  const _LaunchBarPlaceholder({required this.index});
  final int index;

  static const _labels = {
    1: 'Search',
    2: 'Source Control',
    3: 'Debug',
    10: 'Settings',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    final label = _labels[index] ?? 'Launch Bar';
    return Center(
      child: FondeText(
        'This is a sample screen for the Launch Bar.\nCurrent: $label',
        variant: FondeTextVariant.bodyText,
        color: colorScheme.base.foreground.withValues(alpha: 0.4),
      ),
    );
  }
}

class _CatalogSidebarToolbar extends ConsumerWidget {
  const _CatalogSidebarToolbar({
    required this.sidebarStyle,
    required this.onSidebarStyleChanged,
  });

  final FondeSidebarStyle sidebarStyle;
  final void Function(FondeSidebarStyle) onSidebarStyleChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    final isFloating = sidebarStyle == FondeSidebarStyle.floatingPanel;

    final backgroundColor =
        isFloating
            ? colorScheme.uiAreas.sideBar.floatingPanelBackground
            : colorScheme.uiAreas.toolbar.background;
    final borderColor =
        isFloating ? Colors.transparent : colorScheme.uiAreas.toolbar.border;

    return SizedBox(
      height: 50,
      child: ColoredBox(
        color: backgroundColor,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Row(
                  children: [
                    FondeIconButton(
                      icon: LucideIcons.panelLeftClose,
                      iconSize: 20,
                      onPressed:
                          () =>
                              ref
                                  .read(
                                    fondePrimarySidebarStateProvider.notifier,
                                  )
                                  .hide(),
                      tooltip: 'Close Sidebar',
                      padding: EdgeInsets.zero,
                      hoverColor: Colors.transparent,
                    ),
                    const Spacer(),
                    FondeIconButton(
                      icon:
                          isFloating
                              ? LucideIcons.panelLeft
                              : LucideIcons.appWindowMac,
                      iconSize: 16,
                      tooltip:
                          isFloating
                              ? 'Switch to Standard Style'
                              : 'Switch to Floating Panel Style',
                      onPressed:
                          () => onSidebarStyleChanged(
                            isFloating
                                ? FondeSidebarStyle.standard
                                : FondeSidebarStyle.floatingPanel,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            if (borderColor != Colors.transparent)
              Divider(height: 1, thickness: 1, color: borderColor),
          ],
        ),
      ),
    );
  }
}
