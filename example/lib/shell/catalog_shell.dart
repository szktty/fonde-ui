import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:fonde_ui/fonde_ui_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../pages/button_page.dart';
import '../pages/icon_button_page.dart';
import '../pages/segmented_button_page.dart';
import '../pages/split_button_page.dart';
import '../pages/context_menu_page.dart';
import '../pages/text_field_page.dart';
import '../pages/search_field_page.dart';
import '../pages/tags_field_page.dart';
import '../pages/checkbox_page.dart';
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
import 'catalog_sidebar.dart';

class CatalogShell extends ConsumerStatefulWidget {
  const CatalogShell({super.key});

  @override
  ConsumerState<CatalogShell> createState() => _CatalogShellState();
}

class _CatalogShellState extends ConsumerState<CatalogShell> {
  String? _selectedItemId;
  List<String> _expandedGroupIds = ['layout'];
  int _launchBarIndex = 0;

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
      'fonde_checkbox' => const CheckboxPage(),
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
      // Platform
      'platform_menus' => const PlatformMenusPage(),
      // Other: dummy pages
      null => const _WelcomePage(),
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
        center:
            kIsWeb
                ? Consumer(
                  builder: (context, ref, _) {
                    final colorScheme = ref.watch(
                      fondeEffectiveColorSchemeProvider,
                    );
                    return FondeText(
                      'Web preview — some interactions may differ from the native app',
                      variant: FondeTextVariant.captionText,
                      color: colorScheme.base.foreground.withValues(
                        alpha: 0.55,
                      ),
                    );
                  },
                )
                : null,
        trailing: _ToolbarControls(),
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
            icon: LucideIcons.bug,
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
      primarySidebar: CatalogSidebar(
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
      ),
      content:
          _launchBarIndex == 0
              ? _buildContent()
              : _LaunchBarPlaceholder(index: _launchBarIndex),
    );
    if (!_isDesktop) return body;
    final menus = FondePlatformMenus(context: context);
    return PlatformMenuBar(
      menus: [
        menus.appMenu(appName: 'fonde_ui Catalog'),
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

// Font family options (downloaded via google_fonts)
// (display name, font name passed to GoogleFonts method, or empty string for system default)
const _fontFamilies = [
  ('System Default', ''),
  ('Inter', 'Inter'),
  ('Roboto', 'Roboto'),
  ('Noto Sans', 'Noto Sans'),
  ('Source Code Pro', 'Source Code Pro'),
  ('Lato', 'Lato'),
  ('Open Sans', 'Open Sans'),
];

// Zoom level options
const _zoomLevels = [0.75, 0.9, 1.0, 1.1, 1.25, 1.5];

/// Toolbar trailing area: theme toggle, font settings, and zoom controls
class _ToolbarControls extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ToolbarControls> createState() => _ToolbarControlsState();
}

class _ToolbarControlsState extends ConsumerState<_ToolbarControls> {
  String _selectedFontFamily = '';
  bool _fontLoading = false;

  String get _fontFamilyLabel {
    for (final (label, value) in _fontFamilies) {
      if (value == _selectedFontFamily) return label;
    }
    return 'System Default';
  }

  Future<void> _applyFontFamily(String fontFamily) async {
    if (fontFamily.isEmpty) {
      setState(() {
        _selectedFontFamily = fontFamily;
        _fontLoading = false;
      });
      final current = ref.read(fondeActiveThemeProvider);
      // Explicitly restore the preset typography (Roboto) instead of using clearTypography.
      // Setting it to null leaves ThemeData.textTheme in an undefined state,
      // which breaks widgets that depend on theme.textTheme.titleSmall,
      // such as sidebar_list_group.
      final preset = FondeThemePresets.system;
      ref
          .read(fondeActiveThemeProvider.notifier)
          .setTheme(current.copyWith(typography: preset.typography));
      return;
    }

    setState(() {
      _selectedFontFamily = fontFamily;
      _fontLoading = true;
    });

    // Trigger download and wait for completion
    final textStyle = GoogleFonts.getFont(fontFamily);
    await GoogleFonts.pendingFonts([textStyle]);

    if (!mounted) return;

    final resolvedFamily = textStyle.fontFamily ?? fontFamily;
    final current = ref.read(fondeActiveThemeProvider);
    final typography = FondeTypographyConfig(
      uiFont: FondeFontConfig(
        fontFamily: resolvedFamily,
        size: current.typography?.uiFont?.size ?? 14.0,
        weight: current.typography?.uiFont?.weight ?? FontWeight.w400,
        letterSpacing: current.typography?.uiFont?.letterSpacing ?? 0.25,
        lineHeight: current.typography?.uiFont?.lineHeight ?? 1.2,
      ),
      textFont: FondeFontConfig(
        fontFamily: resolvedFamily,
        size: current.typography?.textFont?.size ?? 16.0,
        weight: current.typography?.textFont?.weight ?? FontWeight.w400,
        letterSpacing: current.typography?.textFont?.letterSpacing ?? 0.5,
        lineHeight: current.typography?.textFont?.lineHeight ?? 1.5,
      ),
      codeBlockFont: current.typography?.codeBlockFont,
    );
    ref
        .read(fondeActiveThemeProvider.notifier)
        .setTheme(current.copyWith(typography: typography));

    setState(() => _fontLoading = false);
  }

  void _setFontSize(double newSize) {
    final current = ref.read(fondeActiveThemeProvider);
    final defaultTypography = FondeThemePresets.system.typography!;
    final typography = (current.typography ?? defaultTypography).copyWith(
      uiFont: (current.typography?.uiFont ?? defaultTypography.uiFont!)
          .copyWith(size: newSize),
      textFont: (current.typography?.textFont ?? defaultTypography.textFont!)
          .copyWith(size: newSize + 2),
    );
    ref
        .read(fondeActiveThemeProvider.notifier)
        .setTheme(current.copyWith(typography: typography));
  }

  void _adjustFontSize(int delta) {
    final current = ref.read(fondeActiveThemeProvider);
    final baseSize = current.typography?.uiFont?.size ?? 14.0;
    _setFontSize((baseSize + delta).clamp(10.0, 24.0));
  }

  void _setZoom(double zoom) {
    final config = ref.read(fondeAccessibilityConfigProvider);
    ref
        .read(fondeAccessibilityConfigProvider.notifier)
        .updateConfig(config.copyWith(zoomScale: zoom));
  }

  int _zoomIndex(double zoom) {
    for (var i = 0; i < _zoomLevels.length; i++) {
      if ((_zoomLevels[i] - zoom).abs() < 0.001) return i;
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    final activeTheme = ref.watch(fondeActiveThemeProvider);
    final accessibility = ref.watch(fondeAccessibilityConfigProvider);
    final isSystem = activeTheme.themeMode == ThemeMode.system;
    final isDark = activeTheme.themeMode == ThemeMode.dark;
    final currentFontSize = activeTheme.typography?.uiFont?.size ?? 14.0;
    final currentZoom = accessibility.zoomScale;
    final zoomIdx = _zoomIndex(currentZoom);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Font family selector
          _ToolbarLabel(label: 'Font:'),
          const SizedBox(width: 2),
          FondePopupMenu<String>(
            enabled: !_fontLoading,
            items: [
              for (final (label, value) in _fontFamilies)
                FondePopupMenuItemEntry(
                  FondePopupMenuItem(
                    value: value,
                    title: label,
                    onSelected: () => _applyFontFamily(value),
                  ),
                ),
            ],
            child: _FontFamilyButton(
              label: _fontFamilyLabel,
              loading: _fontLoading,
            ),
          ),
          const SizedBox(width: 4),
          // Font size
          FondeIconButton(
            icon: LucideIcons.minus,
            tooltip: 'Smaller Font',
            enabled: currentFontSize > 10,
            onPressed: () => _adjustFontSize(-1),
          ),
          _FontSizeLabel(
            size: currentFontSize,
            onTap: () => _setFontSize(14.0),
          ),
          FondeIconButton(
            icon: LucideIcons.plus,
            tooltip: 'Larger Font',
            enabled: currentFontSize < 24,
            onPressed: () => _adjustFontSize(1),
          ),
          const SizedBox(width: 4),
          _ToolbarDivider(),
          const SizedBox(width: 4),
          // Zoom controls
          FondeIconButton(
            icon: LucideIcons.zoomOut,
            tooltip: 'Zoom Out',
            enabled: currentZoom > _zoomLevels.first,
            onPressed: () {
              if (zoomIdx > 0) {
                _setZoom(_zoomLevels[zoomIdx - 1]);
              } else if (zoomIdx < 0) {
                final lower =
                    _zoomLevels.where((z) => z < currentZoom).toList();
                if (lower.isNotEmpty) _setZoom(lower.last);
              }
            },
          ),
          _ZoomLabel(zoom: currentZoom, onTap: () => _setZoom(1.0)),
          FondeIconButton(
            icon: LucideIcons.zoomIn,
            tooltip: 'Zoom In',
            enabled: currentZoom < _zoomLevels.last,
            onPressed: () {
              if (zoomIdx >= 0 && zoomIdx < _zoomLevels.length - 1) {
                _setZoom(_zoomLevels[zoomIdx + 1]);
              } else if (zoomIdx < 0) {
                final higher =
                    _zoomLevels.where((z) => z > currentZoom).toList();
                if (higher.isNotEmpty) _setZoom(higher.first);
              }
            },
          ),
          const SizedBox(width: 4),
          _ToolbarDivider(),
          const SizedBox(width: 4),
          // Theme toggle
          FondeIconButton(
            icon: LucideIcons.monitor,
            tooltip: 'System',
            enabled: !isSystem,
            onPressed:
                () => ref
                    .read(fondeActiveThemeProvider.notifier)
                    .setTheme(FondeThemePresets.system),
          ),
          FondeIconButton(
            icon: LucideIcons.sun,
            tooltip: 'Light',
            enabled: isSystem || isDark,
            onPressed:
                () => ref
                    .read(fondeActiveThemeProvider.notifier)
                    .setTheme(FondeThemePresets.light),
          ),
          FondeIconButton(
            icon: LucideIcons.moon,
            tooltip: 'Dark',
            enabled: isSystem || !isDark,
            onPressed:
                () => ref
                    .read(fondeActiveThemeProvider.notifier)
                    .setTheme(FondeThemePresets.dark),
          ),
        ],
      ),
    );
  }
}

class _ToolbarLabel extends ConsumerWidget {
  const _ToolbarLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    return FondeText(
      label,
      variant: FondeTextVariant.captionText,
      color: colorScheme.base.foreground.withValues(alpha: 0.55),
    );
  }
}

class _ToolbarDivider extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    return SizedBox(
      height: 16,
      child: VerticalDivider(
        width: 1,
        thickness: 1,
        color: colorScheme.base.divider,
      ),
    );
  }
}

class _ZoomLabel extends ConsumerWidget {
  const _ZoomLabel({required this.zoom, required this.onTap});
  final double zoom;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = zoom == 1.0 ? '100%' : '${(zoom * 100).round()}%';
    return _ToolbarTextButton(
      label: label,
      tooltip: 'Reset Zoom',
      onTap: onTap,
    );
  }
}

class _FontSizeLabel extends ConsumerWidget {
  const _FontSizeLabel({required this.size, required this.onTap});
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ToolbarTextButton(
      label: '${size.round()}px',
      tooltip: 'Reset Font Size',
      onTap: onTap,
    );
  }
}

class _FontFamilyButton extends ConsumerWidget {
  const _FontFamilyButton({required this.label, this.loading = false});
  final String label;
  final bool loading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    final fgColor = colorScheme.base.foreground.withValues(
      alpha: loading ? 0.4 : 0.75,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (loading) ...[
            SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: fgColor,
              ),
            ),
            const SizedBox(width: 4),
          ],
          FondeText(
            label,
            variant: FondeTextVariant.captionText,
            color: fgColor,
          ),
        ],
      ),
    );
  }
}

class _ToolbarTextButton extends ConsumerWidget {
  const _ToolbarTextButton({
    required this.label,
    required this.onTap,
    this.tooltip,
  });
  final String label;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    final widget = GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: FondeText(
            label,
            variant: FondeTextVariant.captionText,
            color: colorScheme.base.foreground.withValues(alpha: 0.75),
          ),
        ),
      ),
    );
    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: widget);
    }
    return widget;
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

class _WelcomePage extends StatefulWidget {
  const _WelcomePage();

  @override
  State<_WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<_WelcomePage> {
  Set<String> _segmentSelected = {'week'};
  bool _checkbox1 = true;
  bool _checkbox2 = false;
  String? _outlineSelected = 'home';
  Set<String> _outlineExpanded = {'root', 'lib', 'pages'};

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
        return _buildContent(colorScheme);
      },
    );
  }

  Widget _buildContent(FondeColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: FondeSpacingValues.xxxl + 16,
        vertical: FondeSpacingValues.xxxl + 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const FondeText(
            'Welcome to Fonde UI',
            variant: FondeTextVariant.pageTitle,
          ),
          const FondeSpacing.sm(),
          FondeText(
            'Desktop-first UI components for Flutter',
            variant: FondeTextVariant.bodyText,
            color: colorScheme.base.foreground.withValues(alpha: 0.55),
          ),
          const FondeSpacing(height: FondeSpacingValues.xxxl + 8),

          // Preview grid
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _PreviewCard(
                title: 'Buttons',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FondeButton.primary(label: 'Primary', onPressed: () {}),
                    FondeButton.normal(label: 'Normal', onPressed: () {}),
                    FondeButton.cancel(label: 'Cancel', onPressed: () {}),
                    FondeButton.destructive(label: 'Delete', onPressed: () {}),
                    FondeSegmentedButton<String>(
                      selected: _segmentSelected,
                      onSelectionChanged:
                          (v) => setState(() => _segmentSelected = v),
                      segments: const [
                        ButtonSegment(value: 'day', label: Text('Day')),
                        ButtonSegment(value: 'week', label: Text('Week')),
                        ButtonSegment(value: 'month', label: Text('Month')),
                      ],
                    ),
                    FondeButtonGroup(
                      children: [
                        FondeButtonGroupItem(
                          icon: LucideIcons.bold,
                          onPressed: () {},
                          isSelected: true,
                        ),
                        FondeButtonGroupItem(
                          icon: LucideIcons.italic,
                          onPressed: () {},
                        ),
                        FondeButtonGroupItem(
                          icon: LucideIcons.underline,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _PreviewCard(
                title: 'Input',
                child: SizedBox(
                  width: 260,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FondeTextField(hintText: 'Text field'),
                      const SizedBox(height: 10),
                      FondeSearchField(
                        hint: 'Search...',
                        suggestions: const ['Apple', 'Banana', 'Cherry'],
                      ),
                      const SizedBox(height: 10),
                      FondeTagsField(
                        initialTags: const ['Flutter', 'Dart'],
                        hintText: 'Add tag...',
                        onTagsChanged: (_) {},
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          FondeCheckbox(
                            value: _checkbox1,
                            onChanged:
                                (v) => setState(() => _checkbox1 = v ?? false),
                          ),
                          const SizedBox(width: 8),
                          const Text('Option A'),
                          const SizedBox(width: 16),
                          FondeCheckbox(
                            value: _checkbox2,
                            onChanged:
                                (v) => setState(() => _checkbox2 = v ?? false),
                          ),
                          const SizedBox(width: 8),
                          const Text('Option B'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              _PreviewCard(
                title: 'Layout',
                child: SizedBox(
                  width: 300,
                  height: 220,
                  child: FondeTabView(
                    tabs: const [
                      FondeTab(
                        id: 'files',
                        label: 'Files',
                        icon: LucideIcons.folder,
                      ),
                      FondeTab(
                        id: 'search',
                        label: 'Search',
                        icon: LucideIcons.search,
                      ),
                      FondeTab(
                        id: 'settings',
                        label: 'Settings',
                        icon: LucideIcons.settings,
                      ),
                    ],
                    contents: [
                      FondeTabContent(
                        id: 'files',
                        content: FondeOutlineView<_WelcomeNode>(
                          items: _welcomeNodes,
                          selectedItem:
                              _outlineSelected != null
                                  ? _findWelcomeNode(_outlineSelected!)
                                  : null,
                          expandedItems: Set.of(
                            _allWelcomeNodes.where(
                              (n) => _outlineExpanded.contains(n.id),
                            ),
                          ),
                          onItemTap:
                              (n) => setState(() => _outlineSelected = n.id),
                          onExpansionChanged:
                              (n) => setState(() {
                                if (_outlineExpanded.contains(n.id)) {
                                  _outlineExpanded =
                                      _outlineExpanded
                                          .where((id) => id != n.id)
                                          .toSet();
                                } else {
                                  _outlineExpanded = {
                                    ..._outlineExpanded,
                                    n.id,
                                  };
                                }
                              }),
                          itemBuilder:
                              (n, isSelected, isExpanded, hasChildren, depth) =>
                                  FondeOutlineItem(
                                    title: Text(n.label),
                                    isSelected: isSelected,
                                    isExpanded: isExpanded,
                                    hasChildren: hasChildren,
                                    depth: depth,
                                    leading: Icon(
                                      hasChildren
                                          ? LucideIcons.folder
                                          : LucideIcons.file,
                                      size: 14,
                                    ),
                                  ),
                          childrenBuilder: (n) => n.children,
                        ),
                      ),
                      FondeTabContent(
                        id: 'search',
                        content: const Center(
                          child: FondeText(
                            'Search',
                            variant: FondeTextVariant.bodyText,
                          ),
                        ),
                      ),
                      FondeTabContent(
                        id: 'settings',
                        content: const Center(
                          child: FondeText(
                            'Settings',
                            variant: FondeTextVariant.bodyText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _PreviewCard(
                title: 'Decoration',
                child: SizedBox(
                  width: 260,
                  child: Column(
                    children: [
                      FondeListTile(
                        leading: const Icon(LucideIcons.inbox, size: 16),
                        title: const FondeText(
                          'Inbox',
                          variant: FondeTextVariant.bodyText,
                        ),
                        isSelected: true,
                        onTap: () {},
                      ),
                      FondeListTile(
                        leading: const Icon(LucideIcons.send, size: 16),
                        title: const FondeText(
                          'Sent',
                          variant: FondeTextVariant.bodyText,
                        ),
                        isSelected: false,
                        onTap: () {},
                      ),
                      FondeListTile(
                        leading: const Icon(LucideIcons.archive, size: 16),
                        title: const FondeText(
                          'Archive',
                          variant: FondeTextVariant.bodyText,
                        ),
                        subtitle: const FondeText(
                          '42 items',
                          variant: FondeTextVariant.captionText,
                        ),
                        isSelected: false,
                        onTap: () {},
                      ),
                      const FondeSpacing.md(),
                      FondePanel(
                        header: FondePadding.symmetric(
                          horizontal: FondeSpacingValues.md,
                          vertical: FondeSpacingValues.sm,
                          child: const FondeText(
                            'Panel',
                            variant: FondeTextVariant.sectionTitleSecondary,
                          ),
                        ),
                        content: FondePadding(
                          padding: const EdgeInsets.fromLTRB(
                            FondeSpacingValues.md,
                            FondeSpacingValues.xs,
                            FondeSpacingValues.md,
                            FondeSpacingValues.md,
                          ),
                          child: const FondeText(
                            'Header · Content · Footer structure',
                            variant: FondeTextVariant.bodyText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _WelcomeNode? _findWelcomeNode(String id) {
    for (final n in _allWelcomeNodes) {
      if (n.id == id) return n;
    }
    return null;
  }
}

class _PreviewCard extends ConsumerWidget {
  const _PreviewCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.base.divider),
        borderRadius: FondeBorderRadiusValues.mediumRadius,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 260),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FondePadding(
              padding: const EdgeInsets.fromLTRB(
                FondeSpacingValues.lg,
                FondeSpacingValues.md,
                FondeSpacingValues.lg,
                FondeSpacingValues.sm,
              ),
              child: FondeText(
                title,
                variant: FondeTextVariant.sectionTitleSecondary,
                color: colorScheme.base.foreground.withValues(alpha: 0.55),
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: colorScheme.base.divider,
            ),
            FondePadding.all(FondeSpacingValues.lg, child: child),
          ],
        ),
      ),
    );
  }
}

class _WelcomeNode {
  const _WelcomeNode(this.id, this.label, [this.children = const []]);
  final String id;
  final String label;
  final List<_WelcomeNode> children;
}

const _welcomeNodes = [
  _WelcomeNode('root', 'my_app', [
    _WelcomeNode('lib', 'lib', [
      _WelcomeNode('main', 'main.dart'),
      _WelcomeNode('pages', 'pages', [
        _WelcomeNode('home', 'home_page.dart'),
        _WelcomeNode('settings', 'settings_page.dart'),
      ]),
    ]),
    _WelcomeNode('pubspec', 'pubspec.yaml'),
  ]),
];

List<_WelcomeNode> get _allWelcomeNodes {
  final result = <_WelcomeNode>[];
  void collect(_WelcomeNode n) {
    result.add(n);
    for (final c in n.children) {
      collect(c);
    }
  }

  for (final n in _welcomeNodes) {
    collect(n);
  }
  return result;
}
