import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import '../../internal.dart';

/// A resizable split pane for use inside content areas.
///
/// Unlike [FondeScaffold] (which uses multi_split_view internally for the
/// top-level sidebar layout), [FondeSplitPane] is designed for arbitrary
/// splits within content — e.g., editor + preview, master + detail, etc.
///
/// Example:
/// ```dart
/// FondeSplitPane(
///   axis: Axis.horizontal,
///   children: [
///     EditorPanel(),
///     PreviewPanel(),
///   ],
///   initialSizes: [0.6, 0.4],
/// )
/// ```
class FondeSplitPane extends StatefulWidget {
  const FondeSplitPane({
    super.key,
    required this.children,
    this.axis = Axis.horizontal,
    this.initialSizes,
    this.minSizes,
    this.maxSizes,
    this.dividerThickness = 4.0,
    this.onSizesChanged,
    this.disableZoom = false,
  }) : assert(
         children.length >= 2,
         'FondeSplitPane requires at least 2 children',
       ),
       assert(
         initialSizes == null || initialSizes.length == children.length,
         'initialSizes must have the same length as children',
       );

  /// The pane widgets to lay out.
  final List<Widget> children;

  /// Whether to split horizontally or vertically. Defaults to horizontal.
  final Axis axis;

  /// Initial fractional sizes for each pane (0.0–1.0). Must sum to 1.0.
  /// Defaults to equal distribution.
  final List<double>? initialSizes;

  /// Minimum pixel sizes for each pane. Null means no minimum.
  final List<double?>? minSizes;

  /// Maximum pixel sizes for each pane. Null means no maximum.
  final List<double?>? maxSizes;

  /// Thickness of the divider in logical pixels. Defaults to 4.
  final double dividerThickness;

  /// Called whenever a divider is dragged, with the new fractional sizes.
  final void Function(List<double> sizes)? onSizesChanged;

  /// Whether to disable zoom scaling on the divider thickness.
  final bool disableZoom;

  @override
  State<FondeSplitPane> createState() => _FondeSplitPaneState();
}

class _FondeSplitPaneState extends State<FondeSplitPane> {
  late MultiSplitViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MultiSplitViewController(areas: _buildAreas());
  }

  List<Area> _buildAreas() {
    final count = widget.children.length;
    return List.generate(count, (i) {
      final flex =
          widget.initialSizes != null ? widget.initialSizes![i] : 1.0 / count;
      return Area(
        id: 'pane_$i',
        flex: flex,
        min: widget.minSizes != null ? widget.minSizes![i] : null,
        max: widget.maxSizes != null ? widget.maxSizes![i] : null,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final accessibilityConfig = context.fondeAccessibility;
    final borderScale =
        widget.disableZoom ? 1.0 : accessibilityConfig.borderScale;

    return MultiSplitViewTheme(
      data: MultiSplitViewThemeData(
        dividerThickness: widget.dividerThickness * borderScale,
        dividerPainter: DividerPainters.background(
          color: appColorScheme.base.divider,
          highlightedColor: appColorScheme.theme.primaryColor,
        ),
        dividerHandleBuffer: 6,
      ),
      child: MultiSplitView(
        controller: _controller,
        axis: widget.axis,
        onDividerDragUpdate: (_) {
          if (widget.onSizesChanged != null) {
            final sizes = _controller.areas.map((a) => a.flex ?? 0.0).toList();
            widget.onSizesChanged!(sizes);
          }
        },
        builder: (context, area) {
          final index = int.parse(area.id!.replaceFirst('pane_', ''));
          return widget.children[index];
        },
      ),
    );
  }
}
