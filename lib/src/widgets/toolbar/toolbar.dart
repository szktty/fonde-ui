import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/context_extensions.dart';
import '../../core/controllers.dart';
import '../../internal.dart';
import '../overflow_menu/overflow_menu.dart';

import 'toolbar_state.dart';

/// Internal toolbar layout widget.
class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.children,
    this.axis = Axis.horizontal,
    this.spacing = 8.0,
    this.padding = const EdgeInsets.all(8.0),
    this.decoration,
    this.clipBehavior = Clip.none,
    this.disableZoom = false,
  });

  final List<Widget> children;
  final Axis axis;
  final double spacing;
  final EdgeInsetsGeometry padding;
  final BoxDecoration? decoration;
  final Clip clipBehavior;
  final bool disableZoom;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final zoomScale = disableZoom ? 1.0 : context.fondeZoomScale;
    final borderScale = disableZoom ? 1.0 : context.fondeBorderScale;

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
class FondeToolbarGroup extends StatelessWidget {
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
  final List<FondeOverflowMenuEntry>? overflowItems;
  final String? overflowTooltip;
  final double? availableWidth;
  final bool disableZoom;

  @override
  Widget build(BuildContext context) {
    final zoomScale = disableZoom ? 1.0 : context.fondeZoomScale;
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
  late List<GlobalKey> _keys;
  List<double>? _childWidths;
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

  int _computeCount(List<double> widths, double availableWidth) {
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

/// Toolbar item widget.
class FondeToolbarItem extends StatelessWidget {
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
  final bool disableZoom;

  @override
  Widget build(BuildContext context) {
    final zoomScale = disableZoom ? 1.0 : context.fondeZoomScale;

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

/// Data-driven toolbar backed by [FondeToolbarController].
///
/// Wrap the toolbar (and its siblings) in a [FondeToolbarControllerScope] to
/// provide a shared [FondeToolbarController]. When no scope is found, the
/// toolbar renders all items as enabled with no selection.
class FondeToolbar extends StatefulWidget {
  const FondeToolbar({
    super.key,
    required this.axis,
    required this.items,
    this.disableZoom = false,
  });

  final Axis axis;
  final List<FondeToolbarItemData> items;
  final bool disableZoom;

  @override
  State<FondeToolbar> createState() => _FondeToolbarState();
}

class _FondeToolbarState extends State<FondeToolbar> {
  FondeToolbarController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = FondeToolbarControllerScope.of(context);
    if (controller != _controller) {
      _controller?.removeListener(_onStateChanged);
      _controller = controller;
      _controller?.addListener(_onStateChanged);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final state = _controller?.state ?? const FondeToolbarState();
    final zoomScale = widget.disableZoom ? 1.0 : context.fondeZoomScale;

    return _Toolbar(
      axis: widget.axis,
      spacing: 8.0 * zoomScale,
      padding: EdgeInsets.all(8.0 * zoomScale),
      disableZoom: widget.disableZoom,
      children:
          widget.items.map((item) {
            final isEnabled = state.enabledTools.contains(item.id);
            return FondeToolbarItem(
              onPressed:
                  isEnabled ? () => _controller?.selectTool(item.id) : null,
              tooltip: item.tooltip,
              enabled: isEnabled,
              disableZoom: widget.disableZoom,
              child: item.icon,
            );
          }).toList(),
    );
  }
}
