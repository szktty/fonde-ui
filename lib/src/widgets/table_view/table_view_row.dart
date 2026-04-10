import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../internal.dart';
import '../widgets/fonde_gesture_detector.dart';
import '../widgets/fonde_rectangle_border.dart';
import 'fonde_table_view.dart';

class TableViewRow<T> extends StatelessWidget {
  final T item;
  final int index;
  final List<FondeTableColumn<T>> columns;
  final List<int> columnOrder;
  final List<double> columnWidths;
  final Set<String>? primaryColumnIds;
  final bool isSelected;
  final bool isHovered;
  final bool isPressed;
  final bool isDragging;
  final bool showLineAbove;
  final bool showLineBelow;
  final bool allowRowReordering;
  final bool rowDragActive;
  final FondeTableRowReorderIndicator rowReorderIndicator;
  final double rowHeight;
  final double edgeWidgetDefaultWidth;
  final Color insertLineColor;
  final Widget Function(T item)? leadingBuilder;
  final Widget Function(T item)? trailingBuilder;

  final VoidCallback onTap;
  final VoidCallback? onDoubleTap;
  final void Function(TapDownDetails) onTapDown;
  final void Function(TapUpDetails) onTapUp;
  final VoidCallback onTapCancel;
  final void Function(PointerEnterEvent) onEnter;
  final void Function(PointerExitEvent) onExit;

  const TableViewRow({
    super.key,
    required this.item,
    required this.index,
    required this.columns,
    required this.columnOrder,
    required this.columnWidths,
    required this.primaryColumnIds,
    required this.isSelected,
    required this.isHovered,
    required this.isPressed,
    required this.isDragging,
    required this.showLineAbove,
    required this.showLineBelow,
    required this.allowRowReordering,
    required this.rowDragActive,
    required this.rowReorderIndicator,
    required this.rowHeight,
    required this.edgeWidgetDefaultWidth,
    required this.insertLineColor,
    required this.leadingBuilder,
    required this.trailingBuilder,
    required this.onTap,
    required this.onDoubleTap,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
    required this.onEnter,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.fondeColorScheme;

    Color bgColor;
    if (isSelected) {
      bgColor = cs.interactive.list.selectedBackground;
    } else if (isPressed) {
      bgColor = cs.interactive.list.itemBackground.active;
    } else if (isHovered) {
      bgColor = cs.interactive.list.itemBackground.hover;
    } else {
      bgColor = cs.base.background;
    }

    const lineThickness = 2.0;
    const dotDiameter = 6.0;
    const dotOverhang = 4.0;
    const highlightRadius = 6.0;

    final highlightDecoration = ShapeDecoration(
      color: bgColor,
      shape: SquircleBorder(
        borderRadius: SquircleBorderRadius(
          cornerRadius: highlightRadius,
          cornerSmoothing: 0.6,
        ),
      ),
    );

    final cellArea = FondeGestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        height: rowHeight,
        decoration: highlightDecoration,
        child: Row(
          children: [
            for (int i = 0; i < columnOrder.length; i++)
              _buildBodyCell(context, cs, i),
          ],
        ),
      ),
    );

    return MouseRegion(
      cursor:
          allowRowReordering
              ? (rowDragActive
                  ? SystemMouseCursors.grabbing
                  : SystemMouseCursors.grab)
              : MouseCursor.defer,
      onEnter: onEnter,
      onExit: onExit,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: rowHeight,
            child: Row(
              children: [
                leadingBuilder?.call(item) ??
                    SizedBox(width: edgeWidgetDefaultWidth),
                Expanded(child: cellArea),
                trailingBuilder?.call(item) ??
                    SizedBox(width: edgeWidgetDefaultWidth),
              ],
            ),
          ),
          if (showLineAbove)
            _buildInsertLine(
              lineThickness,
              dotDiameter,
              dotOverhang,
              above: true,
            ),
          if (showLineBelow)
            _buildInsertLine(
              lineThickness,
              dotDiameter,
              dotOverhang,
              above: false,
            ),
        ],
      ),
    );
  }

  Widget _buildBodyCell(
    BuildContext context,
    FondeColorScheme cs,
    int orderIndex,
  ) {
    final colOrigIndex = columnOrder[orderIndex];
    final col = columns[colOrigIndex];
    final width = columnWidths[colOrigIndex];

    final ids = primaryColumnIds;
    final isPrimary =
        ids == null
            ? columnOrder.isNotEmpty && columnOrder[0] == colOrigIndex
            : ids.isEmpty || ids.contains(col.id);

    return SizedBox(
      width: width,
      height: rowHeight,
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: cs.base.border, width: 1.0)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Opacity(
          opacity: isPrimary ? 1.0 : 0.5,
          child: col.cellBuilder(item, isSelected),
        ),
      ),
    );
  }

  Widget _buildInsertLine(
    double lineThickness,
    double dotDiameter,
    double dotOverhang, {
    required bool above,
  }) {
    final offset = -lineThickness / 2;
    final useDot =
        rowReorderIndicator == FondeTableRowReorderIndicator.lineWithDot;

    return Positioned(
      top: above ? offset : null,
      bottom: above ? null : offset,
      left: useDot ? -dotOverhang : 0,
      right: 0,
      height: useDot ? dotDiameter : lineThickness,
      child:
          useDot
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: dotDiameter,
                    height: dotDiameter,
                    decoration: BoxDecoration(
                      color: insertLineColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: lineThickness,
                      color: insertLineColor,
                    ),
                  ),
                ],
              )
              : ColoredBox(color: insertLineColor),
    );
  }
}
