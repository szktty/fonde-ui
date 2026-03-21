import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../internal.dart';
import '../overflow_menu/overflow_menu.dart';

import 'toolbar_state.dart';
import 'toolbar_providers.dart';

/// Toolbar widget.
class _Toolbar extends ConsumerWidget {
  const _Toolbar({
    required this.children,
    this.axis = Axis.horizontal,
    this.spacing = 8.0,
    this.padding = const EdgeInsets.all(8.0),
    this.decoration,
    this.clipBehavior = Clip.none,
    this.disableZoom = false,
  });

  /// Widgets within the toolbar.
  final List<Widget> children;

  /// Direction of the toolbar (horizontal/vertical).
  final Axis axis;

  /// Space between items.
  final double spacing;

  /// Internal padding of the toolbar.
  final EdgeInsetsGeometry padding;

  /// Decoration of the toolbar.
  final BoxDecoration? decoration;

  /// Clipping behavior.
  final Clip clipBehavior;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final accessibilityConfig = ref.watch(fondeAccessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = disableZoom ? 1.0 : accessibilityConfig.borderScale;

    return Container(
      decoration:
          decoration ??
          BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outlineVariant,
                width: borderScale,
              ),
            ),
          ),
      clipBehavior: clipBehavior,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          (padding as EdgeInsets).left * zoomScale,
          (padding as EdgeInsets).top * zoomScale,
          (padding as EdgeInsets).right * zoomScale,
          (padding as EdgeInsets).bottom * zoomScale,
        ),
        child:
            axis == Axis.horizontal
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _addSpacing(children, spacing * zoomScale),
                )
                : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _addSpacing(children, spacing * zoomScale),
                ),
      ),
    );
  }

  List<Widget> _addSpacing(List<Widget> widgets, double space) {
    return widgets
        .expand((widget) sync* {
          yield SizedBox(
            width: axis == Axis.horizontal ? space : 0,
            height: axis == Axis.vertical ? space : 0,
          );
          yield widget;
        })
        .skip(1)
        .toList();
  }
}

/// Item group for the toolbar.
///
/// When [overflowItems] is provided and [availableWidth] is given (finite),
/// the group hides children that don't fit and shows an overflow menu button
/// (⋯) for the hidden ones. The [availableWidth] must be provided by the
/// parent (e.g. via [LayoutBuilder]) for overflow to work correctly.
class FondeToolbarGroup extends ConsumerWidget {
  const FondeToolbarGroup({
    super.key,
    required this.children,
    this.spacing = 4.0,
    this.overflowItems,
    this.overflowTooltip,
    this.availableWidth,
    this.disableZoom = false,
  });

  final List<Widget> children;
  final double spacing;

  /// Menu entries shown in the overflow popup when children don't fit.
  /// When null, no overflow handling is performed (original behaviour).
  final List<FondeOverflowMenuEntry>? overflowItems;

  /// Tooltip for the overflow menu button.
  final String? overflowTooltip;

  /// The finite width available for this group. Must be provided for
  /// overflow handling to work. Obtain this from a parent [LayoutBuilder].
  final double? availableWidth;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityConfig = ref.watch(fondeAccessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final scaledSpacing = spacing * zoomScale;

    final hasOverflow =
        overflowItems != null &&
        overflowItems!.isNotEmpty &&
        availableWidth != null &&
        availableWidth!.isFinite;

    if (!hasOverflow) {
      final spaced =
          children
              .expand((child) sync* {
                yield SizedBox(width: scaledSpacing);
                yield child;
              })
              .skip(1)
              .toList();
      return Row(mainAxisSize: MainAxisSize.min, children: spaced);
    }

    return _FondeOverflowToolbarGroup(
      spacing: scaledSpacing,
      overflowItems: overflowItems!,
      overflowTooltip: overflowTooltip,
      availableWidth: availableWidth!,
      disableZoom: disableZoom,
      children: children,
    );
  }
}

/// Internal stateful widget that measures each child's width and hides
/// children that don't fit, placing them behind an overflow menu button.
class _FondeOverflowToolbarGroup extends StatefulWidget {
  const _FondeOverflowToolbarGroup({
    required this.children,
    required this.spacing,
    required this.overflowItems,
    this.overflowTooltip,
    required this.availableWidth,
    required this.disableZoom,
  });

  final List<Widget> children;
  final double spacing;
  final List<FondeOverflowMenuEntry> overflowItems;
  final String? overflowTooltip;
  final double availableWidth;
  final bool disableZoom;

  @override
  State<_FondeOverflowToolbarGroup> createState() =>
      _FondeOverflowToolbarGroupState();
}

class _FondeOverflowToolbarGroupState
    extends State<_FondeOverflowToolbarGroup> {
  // Keys used only during the measurement frame.
  late List<GlobalKey> _keys;

  // Cached natural widths of each child (null = not yet measured).
  List<double>? _childWidths;

  // How many children fit in the available width (-1 = not yet computed).
  int _visibleCount = -1;

  @override
  void initState() {
    super.initState();
    _keys = List.generate(widget.children.length, (_) => GlobalKey());
  }

  @override
  void didUpdateWidget(_FondeOverflowToolbarGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children.length != widget.children.length) {
      _keys = List.generate(widget.children.length, (_) => GlobalKey());
      _childWidths = null;
      _visibleCount = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_childWidths == null) {
      // Measurement frame: render all children unconstrained to get their
      // natural widths, then cache and compute the visible count.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final widths = <double>[];
        for (final key in _keys) {
          final rb = key.currentContext?.findRenderObject() as RenderBox?;
          widths.add(rb != null && rb.hasSize ? rb.size.width : 0);
        }
        final count = _computeCount(widths, widget.availableWidth);
        setState(() {
          _childWidths = widths;
          _visibleCount = count;
        });
      });

      // Render all children in an unconstrained box for measurement.
      // ClipRect prevents visual overflow during this single frame.
      final measureChildren = <Widget>[];
      for (var i = 0; i < widget.children.length; i++) {
        if (i > 0) measureChildren.add(SizedBox(width: widget.spacing));
        measureChildren.add(
          KeyedSubtree(key: _keys[i], child: widget.children[i]),
        );
      }
      return ClipRect(
        child: OverflowBox(
          alignment: Alignment.centerLeft,
          maxWidth: double.infinity,
          child: Row(mainAxisSize: MainAxisSize.min, children: measureChildren),
        ),
      );
    }

    // Recompute when availableWidth changes (parent LayoutBuilder re-runs).
    final newCount = _computeCount(_childWidths!, widget.availableWidth);
    if (newCount != _visibleCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _visibleCount = newCount);
      });
    }

    final effectiveCount =
        _visibleCount < 0 ? _childWidths!.length : _visibleCount;
    final hasOverflow = effectiveCount < widget.children.length;

    final rowChildren = <Widget>[];
    for (var i = 0; i < effectiveCount; i++) {
      if (i > 0) rowChildren.add(SizedBox(width: widget.spacing));
      rowChildren.add(widget.children[i]);
    }
    if (hasOverflow) {
      if (effectiveCount > 0) rowChildren.add(SizedBox(width: widget.spacing));
      rowChildren.add(
        FondeOverflowMenu(
          items: widget.overflowItems,
          icon: LucideIcons.ellipsis,
          tooltip: widget.overflowTooltip,
          disableZoom: widget.disableZoom,
        ),
      );
    }

    return Row(mainAxisSize: MainAxisSize.min, children: rowChildren);
  }

  /// Computes how many children fit in [availableWidth] using cached widths.
  int _computeCount(List<double> widths, double availableWidth) {
    // Overflow menu button width (approximate: 32px).
    const overflowButtonWidth = 32.0;

    double usedWidth = 0;
    int count = 0;

    for (var i = 0; i < widths.length; i++) {
      final gap = i > 0 ? widget.spacing : 0.0;
      final needed = usedWidth + gap + widths[i];
      final remainingChildren = widths.length - (i + 1);
      final totalNeeded =
          needed +
          (remainingChildren > 0 ? widget.spacing + overflowButtonWidth : 0);

      if (totalNeeded <= availableWidth) {
        usedWidth = needed;
        count = i + 1;
      } else {
        break;
      }
    }

    return count;
  }
}

/// Toolbar item.
class FondeToolbarItem extends ConsumerWidget {
  const FondeToolbarItem({
    super.key,
    required this.child,
    this.onPressed,
    this.tooltip,
    this.enabled = true,
    this.disableZoom = false,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool enabled;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityConfig = ref.watch(fondeAccessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    final button = IconButton(
      onPressed: enabled ? onPressed : null,
      icon: child,
      iconSize: 24 * zoomScale,
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}

/// Toolbar widget using Riverpod.
class FondeToolbar extends ConsumerWidget {
  const FondeToolbar({
    super.key,
    required this.axis,
    required this.items,
    this.disableZoom = false,
  });

  final Axis axis;
  final List<FondeToolbarItemData> items;

  /// Whether to disable the zoom function.
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(toolbarStateProvider);
    final toolbarNotifier = ref.read(toolbarStateProvider.notifier);
    final accessibilityConfig = ref.watch(fondeAccessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    return _Toolbar(
      axis: axis,
      spacing: 8.0 * zoomScale,
      padding: EdgeInsets.all(8.0 * zoomScale),
      decoration: null,
      clipBehavior: Clip.none,
      disableZoom: disableZoom,
      children:
          items.map((item) {
            // Deleted because it is not used
            final isEnabled = state.enabledTools.contains(item.id);

            return FondeToolbarItem(
              onPressed:
                  isEnabled ? () => toolbarNotifier.selectTool(item.id) : null,
              tooltip: item.tooltip,
              enabled: isEnabled,
              disableZoom: disableZoom,
              child: item.icon,
            );
          }).toList(),
    );
  }
}
