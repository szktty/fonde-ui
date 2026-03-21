import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:fonde_ui/fonde_ui_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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

const _kGitHubUrl = 'https://github.com/szktty/fonde-ui';
const _kPackageVersion = '0.1.0';

/// Toolbar trailing area: theme toggle, font settings, and zoom controls
class CatalogToolbarControls extends ConsumerStatefulWidget {
  @override
  ConsumerState<CatalogToolbarControls> createState() =>
      _CatalogToolbarControlsState();
}

class _CatalogToolbarControlsState
    extends ConsumerState<CatalogToolbarControls> {
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

    final overflowItems = <FondeOverflowMenuEntry>[
      // Font size
      FondeOverflowMenuItem(
        value: 'font_smaller',
        title: 'Smaller Font',
        icon: LucideIcons.minus,
        enabled: currentFontSize > 10,
        onSelected: () => _adjustFontSize(-1),
      ),
      FondeOverflowMenuItem(
        value: 'font_reset',
        title: 'Reset Font Size (${currentFontSize.round()}px)',
        onSelected: () => _setFontSize(14.0),
      ),
      FondeOverflowMenuItem(
        value: 'font_larger',
        title: 'Larger Font',
        icon: LucideIcons.plus,
        enabled: currentFontSize < 24,
        onSelected: () => _adjustFontSize(1),
      ),
      const FondeOverflowMenuDivider(),
      // Zoom
      FondeOverflowMenuItem(
        value: 'zoom_out',
        title: 'Zoom Out',
        icon: LucideIcons.zoomOut,
        enabled: currentZoom > _zoomLevels.first,
        onSelected: () {
          if (zoomIdx > 0) {
            _setZoom(_zoomLevels[zoomIdx - 1]);
          } else if (zoomIdx < 0) {
            final lower = _zoomLevels.where((z) => z < currentZoom).toList();
            if (lower.isNotEmpty) _setZoom(lower.last);
          }
        },
      ),
      FondeOverflowMenuItem(
        value: 'zoom_reset',
        title: 'Reset Zoom (${(currentZoom * 100).round()}%)',
        onSelected: () => _setZoom(1.0),
      ),
      FondeOverflowMenuItem(
        value: 'zoom_in',
        title: 'Zoom In',
        icon: LucideIcons.zoomIn,
        enabled: currentZoom < _zoomLevels.last,
        onSelected: () {
          if (zoomIdx >= 0 && zoomIdx < _zoomLevels.length - 1) {
            _setZoom(_zoomLevels[zoomIdx + 1]);
          } else if (zoomIdx < 0) {
            final higher = _zoomLevels.where((z) => z > currentZoom).toList();
            if (higher.isNotEmpty) _setZoom(higher.first);
          }
        },
      ),
      const FondeOverflowMenuDivider(),
      // Theme
      FondeOverflowMenuItem(
        value: 'theme_system',
        title: 'System Theme',
        icon: LucideIcons.monitor,
        enabled: !isSystem,
        onSelected:
            () => ref
                .read(fondeActiveThemeProvider.notifier)
                .setTheme(FondeThemePresets.system),
      ),
      FondeOverflowMenuItem(
        value: 'theme_light',
        title: 'Light Theme',
        icon: LucideIcons.sun,
        enabled: isSystem || isDark,
        onSelected:
            () => ref
                .read(fondeActiveThemeProvider.notifier)
                .setTheme(FondeThemePresets.light),
      ),
      FondeOverflowMenuItem(
        value: 'theme_dark',
        title: 'Dark Theme',
        icon: LucideIcons.moon,
        enabled: isSystem || !isDark,
        onSelected:
            () => ref
                .read(fondeActiveThemeProvider.notifier)
                .setTheme(FondeThemePresets.dark),
      ),
      const FondeOverflowMenuDivider(),
      FondeOverflowMenuItem(
        value: 'github',
        title: 'GitHub',
        icon: LucideIcons.github,
        onSelected: () => launchUrl(Uri.parse(_kGitHubUrl)),
      ),
    ];

    const hPad = FondeSpacingValues.xxxl * 2;
    return LayoutBuilder(
      builder: (context, constraints) {
        final groupWidth = (constraints.maxWidth - hPad).clamp(
          0.0,
          double.infinity,
        );
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: FondeSpacingValues.xxxl,
          ),
          child: FondeToolbarGroup(
            spacing: 4.0,
            overflowItems: overflowItems,
            overflowTooltip: 'More options',
            availableWidth: groupWidth,
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
              _ToolbarDivider(),
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
              _ToolbarDivider(),
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
              _ToolbarDivider(),
              // Version
              FondeText(
                'v$_kPackageVersion',
                variant: FondeTextVariant.captionText,
                color: colorScheme.base.foreground.withValues(alpha: 0.45),
              ),
              // GitHub
              FondeIconButton.circle(
                icon: LucideIcons.github,
                tooltip: 'GitHub',
                iconSize: 16,
                backgroundColor: colorScheme.base.foreground.withValues(
                  alpha: 0.15,
                ),
                constraints: const BoxConstraints.tightFor(
                  width: 28,
                  height: 28,
                ),
                onPressed: () => launchUrl(Uri.parse(_kGitHubUrl)),
              ),
            ],
          ),
        );
      },
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
