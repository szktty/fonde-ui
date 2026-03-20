import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
import 'catalog_sidebar.dart';

class CatalogShell extends ConsumerStatefulWidget {
  const CatalogShell({super.key});

  @override
  ConsumerState<CatalogShell> createState() => _CatalogShellState();
}

class _CatalogShellState extends ConsumerState<CatalogShell> {
  String? _selectedItemId;
  List<String> _expandedGroupIds = catalogCategories.map((c) => c.id).toList();
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
        center: const SizedBox.shrink(),
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
const _kGitHubUrl = 'https://github.com/szktty/fonde-ui';
const _kPackageVersion = '0.1.0';

class _ToolbarControls extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ToolbarControls> createState() => _ToolbarControlsState();
}

class _ToolbarControlsState extends ConsumerState<_ToolbarControls> {
  String _selectedFontFamily = '';
  bool _fontLoading = false;

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
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    final isSystem = activeTheme.themeMode == ThemeMode.system;
    final isDark = activeTheme.themeMode == ThemeMode.dark;
    final currentFontSize = activeTheme.typography?.uiFont?.size ?? 14.0;
    final currentZoom = accessibility.zoomScale;
    final zoomIdx = _zoomIndex(currentZoom);

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: FondeSpacingValues.xxxl),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Font family selector
          FondeDropdownMenu<String>(
            enabled: !_fontLoading,
            width: 180,
            initialSelection: _selectedFontFamily,
            onSelected: (value) {
              if (value != null) _applyFontFamily(value);
            },
            dropdownMenuEntries: [
              for (final (label, value) in _fontFamilies)
                DropdownMenuEntry(value: value, label: label),
            ],
            position: FondeDropdownMenuPosition.below,
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
          const SizedBox(width: 4),
          _ToolbarDivider(),
          const SizedBox(width: 8),
          // Version
          FondeText(
            'v$_kPackageVersion',
            variant: FondeTextVariant.captionText,
            color: colorScheme.base.foreground.withValues(alpha: 0.45),
          ),
          const SizedBox(width: 6),
          // GitHub
          FondeIconButton.circle(
            icon: LucideIcons.github,
            tooltip: 'GitHub',
            iconSize: 16,
            backgroundColor: colorScheme.base.foreground.withValues(
              alpha: 0.15,
            ),
            constraints: const BoxConstraints.tightFor(width: 28, height: 28),
            onPressed: () => launchUrl(Uri.parse(_kGitHubUrl)),
          ),
          const SizedBox(width: 4),
        ],
      ),
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

class _WelcomePage extends ConsumerWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: FondeSpacingValues.xxxl,
        vertical: FondeSpacingValues.xxxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const FondeText('Fonde UI', variant: FondeTextVariant.pageTitle),
          const FondeSpacing.sm(),
          FondeText(
            'Desktop-first Flutter UI optimized for native-grade instant feedback, with accessibility built in.',
            variant: FondeTextVariant.bodyText,
            color: colorScheme.base.foreground.withValues(alpha: 0.55),
          ),
          const FondeSpacing(height: FondeSpacingValues.xxxl + 8),

          // Component grid (2 columns)
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 16.0;
              final cardWidth = (constraints.maxWidth - spacing) / 2;
              final cards = [
                _CatalogCard(
                  width: cardWidth,
                  category: 'Buttons',
                  description: 'Button, Icon Button, Segmented, Split, Group',
                  sample: const _ButtonsSample(),
                ),
                _CatalogCard(
                  width: cardWidth,
                  category: 'Input',
                  description: 'Text Field, Search, Tags, Checkbox, Dropdown',
                  sample: const _InputSample(),
                ),
                _CatalogCard(
                  width: cardWidth,
                  category: 'Menus',
                  description: 'Context Menu, Overflow Menu, Popup Menu',
                  sample: const _MenusSample(),
                ),
                _CatalogCard(
                  width: cardWidth,
                  category: 'Navigation',
                  description: 'Launch Bar, Sidebar List, Groups',
                  sample: const _NavigationSample(),
                ),
                _CatalogCard(
                  width: cardWidth,
                  category: 'Layout',
                  description: 'Tab View, Panel, Scaffold, Sidebar',
                  sample: const _LayoutSample(),
                ),
                _CatalogCard(
                  width: cardWidth,
                  category: 'Data View',
                  description: 'Table View, Outline View, List Tile',
                  sample: const _DataViewSample(),
                ),
                _CatalogCard(
                  width: cardWidth,
                  category: 'Feedback',
                  description: 'Dialog, Toast, Popover, Progress Indicator',
                  sample: const _FeedbackSample(),
                ),
                _CatalogCard(
                  width: cardWidth,
                  category: 'Typography',
                  description: 'Text variants, font scale, color scope',
                  sample: const _TypographySample(),
                ),
              ];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < cards.length; i += 2)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: i + 2 < cards.length ? spacing : 0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          cards[i],
                          const SizedBox(width: spacing),
                          if (i + 1 < cards.length) cards[i + 1],
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

const _kCardSampleHeight = 140.0;

class _CatalogCard extends ConsumerWidget {
  const _CatalogCard({
    required this.width,
    required this.category,
    required this.description,
    required this.sample,
  });

  final double width;
  final String category;
  final String description;
  final Widget sample;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.base.border),
        borderRadius: FondeBorderRadiusValues.mediumRadius,
        color: colorScheme.base.background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sample area
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(FondeBorderRadiusValues.medium),
            ),
            child: SizedBox(
              width: width,
              height: _kCardSampleHeight,
              child: ColoredBox(
                color: colorScheme.base.divider,
                child: Padding(
                  padding: const EdgeInsets.all(FondeSpacingValues.md),
                  child: sample,
                ),
              ),
            ),
          ),
          Container(height: 1, color: colorScheme.base.border),
          // Category name + description
          Padding(
            padding: const EdgeInsets.all(FondeSpacingValues.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FondeText(
                  category,
                  variant: FondeTextVariant.sectionTitleSecondary,
                  color: colorScheme.theme.primaryColor,
                ),
                const FondeSpacing.xs(),
                FondeText(
                  description,
                  variant: FondeTextVariant.smallText,
                  color: colorScheme.base.foreground.withValues(alpha: 0.55),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Static sample widgets ---

class _ButtonsSample extends ConsumerWidget {
  const _ButtonsSample();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: FondeSpacingValues.sm,
      runSpacing: FondeSpacingValues.sm,
      children: [
        FondeButton.primary(label: 'Primary', onPressed: () {}),
        FondeButton.normal(label: 'Normal', onPressed: () {}),
        FondeButton.destructive(label: 'Delete', onPressed: () {}),
        FondeButtonGroup(
          children: [
            FondeButtonGroupItem(
              icon: LucideIcons.bold,
              onPressed: () {},
              isSelected: true,
            ),
            FondeButtonGroupItem(icon: LucideIcons.italic, onPressed: () {}),
            FondeButtonGroupItem(icon: LucideIcons.underline, onPressed: () {}),
          ],
        ),
      ],
    );
  }
}

class _InputSample extends ConsumerWidget {
  const _InputSample();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const FondeTextField(hintText: 'Text field'),
        const FondeSpacing.sm(),
        const FondeSearchField(hint: 'Search...'),
        const FondeSpacing.sm(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FondeCheckbox(value: true, onChanged: null),
            const SizedBox(width: FondeSpacingValues.sm),
            const FondeText('Option A', variant: FondeTextVariant.captionText),
            const SizedBox(width: FondeSpacingValues.md),
            const FondeCheckbox(value: false, onChanged: null),
            const SizedBox(width: FondeSpacingValues.sm),
            const FondeText('Option B', variant: FondeTextVariant.captionText),
          ],
        ),
      ],
    );
  }
}

class _MenusSample extends ConsumerWidget {
  const _MenusSample();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.base.border),
        borderRadius: FondeBorderRadiusValues.smallRadius,
        color: colorScheme.uiAreas.dialog.background,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (icon, label, selected) in [
            (LucideIcons.filePlus, 'New File', false),
            (LucideIcons.pencil, 'Rename', true),
            (LucideIcons.trash2, 'Delete', false),
          ])
            Container(
              color:
                  selected
                      ? colorScheme.interactive.list.selectedBackground
                      : null,
              padding: const EdgeInsets.symmetric(
                horizontal: FondeSpacingValues.md,
                vertical: 6,
              ),
              child: Row(
                children: [
                  Icon(icon, size: 14),
                  const SizedBox(width: FondeSpacingValues.sm),
                  FondeText(label, variant: FondeTextVariant.bodyText),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _NavigationSample extends ConsumerWidget {
  const _NavigationSample();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    return ClipRRect(
      borderRadius: FondeBorderRadiusValues.smallRadius,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Launch Bar
          Container(
            width: 28,
            color: colorScheme.uiAreas.launchBar.background,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    for (final (icon, active) in [
                      (LucideIcons.layoutGrid, true),
                      (LucideIcons.search, false),
                      (LucideIcons.gitBranch, false),
                    ])
                      Container(
                        width: 28,
                        height: 28,
                        color:
                            active
                                ? colorScheme
                                    .uiAreas
                                    .launchBar
                                    .activeItemBackground
                                : null,
                        child: Icon(
                          icon,
                          size: 13,
                          color:
                              active
                                  ? colorScheme.uiAreas.launchBar.activeItem
                                  : colorScheme.uiAreas.launchBar.inactiveItem,
                        ),
                      ),
                  ],
                ),
                Container(
                  width: 28,
                  height: 28,
                  child: Icon(
                    LucideIcons.settings2,
                    size: 13,
                    color: colorScheme.uiAreas.launchBar.inactiveItem,
                  ),
                ),
              ],
            ),
          ),
          // Vertical divider
          Container(width: 1, color: colorScheme.uiAreas.sideBar.divider),
          // Sidebar list
          Expanded(
            child: Container(
              color: colorScheme.uiAreas.sideBar.background,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final (icon, label, selected) in [
                    (LucideIcons.inbox, 'Inbox', true),
                    (LucideIcons.send, 'Sent', false),
                    (LucideIcons.archive, 'Archive', false),
                    (LucideIcons.trash2, 'Trash', false),
                  ])
                    Container(
                      color:
                          selected
                              ? colorScheme.uiAreas.sideBar.activeItemBackground
                              : null,
                      padding: const EdgeInsets.symmetric(
                        horizontal: FondeSpacingValues.sm,
                        vertical: 5,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            icon,
                            size: 12,
                            color:
                                selected
                                    ? colorScheme.uiAreas.sideBar.activeItemText
                                    : colorScheme
                                        .uiAreas
                                        .sideBar
                                        .inactiveItemText,
                          ),
                          const SizedBox(width: FondeSpacingValues.xs),
                          FondeText(
                            label,
                            variant: FondeTextVariant.captionText,
                            color:
                                selected
                                    ? colorScheme.uiAreas.sideBar.activeItemText
                                    : colorScheme
                                        .uiAreas
                                        .sideBar
                                        .inactiveItemText,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LayoutSample extends ConsumerWidget {
  const _LayoutSample();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tab bar mockup
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: colorScheme.base.border)),
          ),
          child: Row(
            children: [
              for (final (label, selected) in [
                ('Files', true),
                ('Search', false),
                ('Git', false),
              ])
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FondeSpacingValues.sm,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color:
                            selected
                                ? colorScheme.theme.primaryColor
                                : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: FondeText(
                    label,
                    variant: FondeTextVariant.captionText,
                    color:
                        selected
                            ? colorScheme.base.foreground
                            : colorScheme.base.foreground.withValues(
                              alpha: 0.5,
                            ),
                  ),
                ),
            ],
          ),
        ),
        const FondeSpacing.sm(),
        // Panel mockup
        FondePanel(
          header: FondePadding.symmetric(
            horizontal: FondeSpacingValues.md,
            vertical: FondeSpacingValues.xs,
            child: const FondeText(
              'Details',
              variant: FondeTextVariant.sectionTitleSecondary,
            ),
          ),
          content: FondePadding.symmetric(
            horizontal: FondeSpacingValues.md,
            vertical: FondeSpacingValues.xs,
            child: FondeText(
              'Resizable panels',
              variant: FondeTextVariant.captionText,
              color: colorScheme.base.foreground.withValues(alpha: 0.55),
            ),
          ),
        ),
      ],
    );
  }
}

class _DataViewSample extends ConsumerWidget {
  const _DataViewSample();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Table header
        Container(
          color: colorScheme.base.background,
          padding: const EdgeInsets.symmetric(
            horizontal: FondeSpacingValues.sm,
            vertical: 5,
          ),
          child: Row(
            children: [
              for (final label in ['Name', 'Type', 'Size'])
                Expanded(
                  child: FondeText(
                    label,
                    variant: FondeTextVariant.captionText,
                    color: colorScheme.base.foreground.withValues(alpha: 0.55),
                  ),
                ),
            ],
          ),
        ),
        Container(height: 1, color: colorScheme.base.border),
        for (final (name, type, size, selected) in [
          ('main.dart', 'Dart', '4 KB', true),
          ('pubspec.yaml', 'YAML', '1 KB', false),
        ])
          Container(
            color:
                selected
                    ? colorScheme.interactive.list.selectedBackground
                    : null,
            padding: const EdgeInsets.symmetric(
              horizontal: FondeSpacingValues.sm,
              vertical: 5,
            ),
            child: Row(
              children: [
                Expanded(
                  child: FondeText(name, variant: FondeTextVariant.captionText),
                ),
                Expanded(
                  child: FondeText(
                    type,
                    variant: FondeTextVariant.captionText,
                    color: colorScheme.base.foreground.withValues(alpha: 0.6),
                  ),
                ),
                Expanded(
                  child: FondeText(
                    size,
                    variant: FondeTextVariant.captionText,
                    color: colorScheme.base.foreground.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _FeedbackSample extends ConsumerWidget {
  const _FeedbackSample();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dialog mockup
        Container(
          decoration: BoxDecoration(
            color: colorScheme.uiAreas.dialog.background,
            border: Border.all(color: colorScheme.base.border),
            borderRadius: FondeBorderRadiusValues.mediumRadius,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: FondeSpacingValues.md,
            vertical: FondeSpacingValues.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const FondeText('Confirm', variant: FondeTextVariant.itemTitle),
              const FondeSpacing.xs(),
              FondeText(
                'Are you sure?',
                variant: FondeTextVariant.captionText,
                color: colorScheme.base.foreground.withValues(alpha: 0.6),
              ),
              const FondeSpacing.xs(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FondeButton.cancel(label: 'Cancel', onPressed: () {}),
                  const SizedBox(width: FondeSpacingValues.xs),
                  FondeButton.primary(label: 'OK', onPressed: () {}),
                ],
              ),
            ],
          ),
        ),
        const FondeSpacing.sm(),
        // Progress bar
        const FondeLinearProgressIndicator(value: 0.65),
      ],
    );
  }
}

class _TypographySample extends ConsumerWidget {
  const _TypographySample();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const FondeText('Page Title', variant: FondeTextVariant.pageTitle),
        const FondeText(
          'Section Title',
          variant: FondeTextVariant.sectionTitleSecondary,
        ),
        const FondeText('Body text', variant: FondeTextVariant.bodyText),
        FondeText(
          'Caption text',
          variant: FondeTextVariant.captionText,
          color: colorScheme.base.foreground.withValues(alpha: 0.55),
        ),
        FondeText(
          'Small text',
          variant: FondeTextVariant.smallText,
          color: colorScheme.base.foreground.withValues(alpha: 0.45),
        ),
      ],
    );
  }
}
