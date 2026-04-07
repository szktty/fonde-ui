import 'package:flutter/material.dart';
import '../../internal.dart';

/// A resizable split pane for use inside content areas.
///
/// Unlike [FondeScaffold] (which uses a split layout internally for the
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
  // Pixel sizes for each pane. Initialized on first layout.
  late List<double> _sizes;
  bool _initialized = false;

  // Which divider index is currently hovered (-1 = none).
  int _hoveredDivider = -1;

  int get _count => widget.children.length;

  double? _minSize(int index) =>
      widget.minSizes != null ? widget.minSizes![index] : null;

  double? _maxSize(int index) =>
      widget.maxSizes != null ? widget.maxSizes![index] : null;

  void _initSizes(double totalSize, double dividerThickness) {
    final totalDividers = _count - 1;
    final available = totalSize - totalDividers * dividerThickness;
    _sizes = List.generate(_count, (i) {
      final fraction =
          widget.initialSizes != null ? widget.initialSizes![i] : 1.0 / _count;
      return available * fraction;
    });
    _initialized = true;
  }

  void _onDividerDrag(
    int dividerIndex,
    double delta,
    double totalSize,
    double dividerThickness,
  ) {
    setState(() {
      final left = dividerIndex;
      final right = dividerIndex + 1;

      double newLeft = _sizes[left] + delta;
      double newRight = _sizes[right] - delta;

      // Apply min/max constraints.
      final minL = _minSize(left) ?? 0.0;
      final minR = _minSize(right) ?? 0.0;
      final maxL = _maxSize(left);
      final maxR = _maxSize(right);

      if (newLeft < minL) {
        final excess = minL - newLeft;
        newLeft = minL;
        newRight -= excess;
      }
      if (newRight < minR) {
        final excess = minR - newRight;
        newRight = minR;
        newLeft -= excess;
      }
      if (maxL != null && newLeft > maxL) {
        final excess = newLeft - maxL;
        newLeft = maxL;
        newRight += excess;
      }
      if (maxR != null && newRight > maxR) {
        final excess = newRight - maxR;
        newRight = maxR;
        newLeft -= excess;
      }

      _sizes[left] = newLeft;
      _sizes[right] = newRight;
    });

    if (widget.onSizesChanged != null) {
      final total = _sizes.fold(0.0, (a, b) => a + b);
      final fractions = _sizes.map((s) => s / total).toList();
      widget.onSizesChanged!(fractions);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final accessibilityConfig = context.fondeAccessibility;
    final borderScale =
        widget.disableZoom ? 1.0 : accessibilityConfig.borderScale;
    final effectiveThickness = widget.dividerThickness * borderScale;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalSize =
            widget.axis == Axis.horizontal
                ? constraints.maxWidth
                : constraints.maxHeight;

        // Layout width of each divider includes the transparent hit buffer.
        final dividerLayoutSize =
            effectiveThickness + _SplitDividerState._hitBuffer * 2;

        if (!_initialized || _sizes.length != _count) {
          _initSizes(totalSize, dividerLayoutSize);
        }

        final children = <Widget>[];
        for (int i = 0; i < _count; i++) {
          // Pane
          final paneSize = _sizes[i];
          final pane = SizedBox(
            width: widget.axis == Axis.horizontal ? paneSize : double.infinity,
            height: widget.axis == Axis.vertical ? paneSize : double.infinity,
            child: widget.children[i],
          );
          children.add(pane);

          // Divider (between panes)
          if (i < _count - 1) {
            final dividerIndex = i;
            children.add(
              _SplitDivider(
                axis: widget.axis,
                thickness: effectiveThickness,
                isHovered: _hoveredDivider == dividerIndex,
                normalColor: appColorScheme.base.divider,
                highlightColor: appColorScheme.theme.primaryColor,
                onHoverChanged: (hovered) {
                  setState(() {
                    _hoveredDivider = hovered ? dividerIndex : -1;
                  });
                },
                onDragUpdate: (delta) {
                  _onDividerDrag(
                    dividerIndex,
                    delta,
                    totalSize,
                    dividerLayoutSize,
                  );
                },
              ),
            );
          }
        }

        if (widget.axis == Axis.horizontal) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          );
        }
      },
    );
  }
}

class _SplitDivider extends StatefulWidget {
  const _SplitDivider({
    required this.axis,
    required this.thickness,
    required this.isHovered,
    required this.normalColor,
    required this.highlightColor,
    required this.onHoverChanged,
    required this.onDragUpdate,
  });

  final Axis axis;
  final double thickness;
  final bool isHovered;
  final Color normalColor;
  final Color highlightColor;
  final void Function(bool hovered) onHoverChanged;
  final void Function(double delta) onDragUpdate;

  @override
  State<_SplitDivider> createState() => _SplitDividerState();
}

class _SplitDividerState extends State<_SplitDivider> {
  bool _isDragging = false;

  // Extra transparent hit area on each side of the visible line.
  static const double _hitBuffer = 4.0;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isHovered || _isDragging;
    final isHorizontal = widget.axis == Axis.horizontal;
    final cursor =
        isHorizontal
            ? SystemMouseCursors.resizeLeftRight
            : SystemMouseCursors.resizeUpDown;

    final visibleLine = AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: isHorizontal ? widget.thickness : double.infinity,
      height: !isHorizontal ? widget.thickness : double.infinity,
      color: isActive ? widget.highlightColor : widget.normalColor,
    );

    // Wrap in a wider/taller transparent hit area so the line is easy to grab.
    final hitArea =
        isHorizontal
            ? SizedBox(
              width: widget.thickness + _hitBuffer * 2,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: const ColoredBox(color: Colors.transparent),
                  ),
                  visibleLine,
                ],
              ),
            )
            : SizedBox(
              height: widget.thickness + _hitBuffer * 2,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: const ColoredBox(color: Colors.transparent),
                  ),
                  visibleLine,
                ],
              ),
            );

    return MouseRegion(
      cursor: cursor,
      onEnter: (_) => widget.onHoverChanged(true),
      onExit: (_) => widget.onHoverChanged(false),
      child: GestureDetector(
        onHorizontalDragUpdate:
            isHorizontal ? (d) => widget.onDragUpdate(d.delta.dx) : null,
        onVerticalDragUpdate:
            !isHorizontal ? (d) => widget.onDragUpdate(d.delta.dy) : null,
        onHorizontalDragStart:
            isHorizontal ? (_) => setState(() => _isDragging = true) : null,
        onHorizontalDragEnd:
            isHorizontal ? (_) => setState(() => _isDragging = false) : null,
        onVerticalDragStart:
            !isHorizontal ? (_) => setState(() => _isDragging = true) : null,
        onVerticalDragEnd:
            !isHorizontal ? (_) => setState(() => _isDragging = false) : null,
        child: hitArea,
      ),
    );
  }
}
