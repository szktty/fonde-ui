import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../internal.dart';
import 'fonde_table_view.dart';
import 'table_view_row.dart';

class TableViewBody<T> extends StatelessWidget {
  final List<T> sortedData;
  final String Function(T) keyExtractor;
  final List<FondeTableColumn<T>> columns;
  final List<int> columnOrder;
  final List<double> columnWidths;
  final Set<String> selectedKeys;
  final Set<String>? primaryColumnIds;
  final int? hoveredRowIndex;
  final int? pressedRowIndex;
  final bool rowDragActive;
  final int? draggingRowIndex;
  final int? dropTargetRowIndex;
  final bool allowRowReordering;
  final bool highlightRowOnHover;
  final FondeTableRowReorderIndicator rowReorderIndicator;
  final FondeTableColumnStyle columnStyle;
  final Color? stripeColor;
  final double rowHeight;
  final double edgeWidgetDefaultWidth;
  final GlobalKey bodyKey;
  final Widget Function(T item)? rowLeadingBuilder;
  final Widget Function(T item)? rowTrailingBuilder;

  final void Function(PointerDownEvent, int rowIndex, double localX)
  onPointerDown;
  final void Function(PointerMoveEvent) onPointerMove;
  final void Function(PointerUpEvent) onPointerUp;
  final void Function(PointerCancelEvent) onPointerCancel;
  final void Function(T item) onRowTap;
  final void Function(T item)? onRowDoubleTap;
  final void Function(int index) onTapDown;
  final VoidCallback onTapUp;
  final VoidCallback onTapCancel;
  final void Function(int index) onEnter;
  final void Function(int index) onExit;

  const TableViewBody({
    super.key,
    required this.sortedData,
    required this.keyExtractor,
    required this.columns,
    required this.columnOrder,
    required this.columnWidths,
    required this.selectedKeys,
    required this.primaryColumnIds,
    required this.hoveredRowIndex,
    required this.pressedRowIndex,
    required this.rowDragActive,
    required this.draggingRowIndex,
    required this.dropTargetRowIndex,
    required this.allowRowReordering,
    required this.highlightRowOnHover,
    required this.rowReorderIndicator,
    required this.columnStyle,
    required this.stripeColor,
    required this.rowHeight,
    required this.edgeWidgetDefaultWidth,
    required this.bodyKey,
    required this.rowLeadingBuilder,
    required this.rowTrailingBuilder,
    required this.onPointerDown,
    required this.onPointerMove,
    required this.onPointerUp,
    required this.onPointerCancel,
    required this.onRowTap,
    required this.onRowDoubleTap,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
    required this.onEnter,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.fondeColorScheme;
    final resolvedStripeColor =
        stripeColor ?? cs.interactive.list.stripeBackground;

    return Listener(
      key: bodyKey,
      behavior: HitTestBehavior.translucent,
      onPointerDown:
          allowRowReordering
              ? (e) {
                final index = (e.localPosition.dy / rowHeight).floor().clamp(
                  0,
                  sortedData.length - 1,
                );
                onPointerDown(e, index, e.localPosition.dx);
              }
              : null,
      onPointerMove: allowRowReordering ? onPointerMove : null,
      onPointerUp: allowRowReordering ? onPointerUp : null,
      onPointerCancel: allowRowReordering ? onPointerCancel : null,
      child: ListView.builder(
        itemCount: sortedData.length,
        itemExtent: rowHeight,
        itemBuilder: (context, index) {
          final item = sortedData[index];
          final key = keyExtractor(item);
          final isSelected = selectedKeys.contains(key);
          final isHovered = hoveredRowIndex == index;
          final isPressed = pressedRowIndex == index;
          final isDragging = rowDragActive && draggingRowIndex == index;
          final showLineAbove = rowDragActive && dropTargetRowIndex == index;
          final showLineBelow =
              rowDragActive &&
              index == sortedData.length - 1 &&
              dropTargetRowIndex == sortedData.length;
          final isStripeRow =
              columnStyle == FondeTableColumnStyle.stripe && index.isOdd;

          return TableViewRow<T>(
            item: item,
            index: index,
            columns: columns,
            columnOrder: columnOrder,
            columnWidths: columnWidths,
            primaryColumnIds: primaryColumnIds,
            isSelected: isSelected,
            isHovered: isHovered && highlightRowOnHover,
            isPressed: isPressed,
            isDragging: isDragging,
            showLineAbove: showLineAbove,
            showLineBelow: showLineBelow,
            allowRowReordering: allowRowReordering,
            rowDragActive: rowDragActive,
            rowReorderIndicator: rowReorderIndicator,
            columnStyle: columnStyle,
            stripeRowBackground: isStripeRow ? resolvedStripeColor : null,
            rowHeight: rowHeight,
            edgeWidgetDefaultWidth: edgeWidgetDefaultWidth,
            insertLineColor: cs.interactive.input.focusBorder,
            leadingBuilder: rowLeadingBuilder,
            trailingBuilder: rowTrailingBuilder,
            onTap: () => onRowTap(item),
            onDoubleTap:
                onRowDoubleTap != null ? () => onRowDoubleTap!(item) : null,
            onTapDown: (_) => onTapDown(index),
            onTapUp: (_) => onTapUp(),
            onTapCancel: onTapCancel,
            onEnter: (_) => onEnter(index),
            onExit: (_) => onExit(index),
          );
        },
      ),
    );
  }
}
