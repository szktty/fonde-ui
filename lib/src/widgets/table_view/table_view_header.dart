import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../internal.dart';
import '../typography/fonde_text_style_builder.dart';
import '../typography/fonde_text.dart';
import 'fonde_table_view.dart';
import 'table_view_header_cell.dart';

class TableViewHeader<T> extends StatelessWidget {
  final List<FondeTableColumn<T>> columns;
  final List<int> columnOrder;
  final List<double> columnWidths;
  final int? sortColumnOrderIndex;
  final TableViewSortDirection sortDirection;
  final bool dimHeaders;
  final bool highlightSortedHeader;
  final bool highlightHeaderOnDrag;
  final bool allowColumnResizing;
  final bool isResizing;
  final bool isNearResizeBoundary;
  final bool colDragActive;
  final int? draggingColumnOrderIndex;
  final int? dropTargetColumnOrderIndex;
  final Widget Function()? leadingBuilder;
  final Widget Function()? trailingBuilder;
  final GlobalKey headerKey;
  final double headerHeight;
  final double edgeWidgetDefaultWidth;
  final FondeTableColumnStyle columnStyle;

  // Pointer callbacks (forwarded to state)
  final void Function(PointerDownEvent) onPointerDown;
  final void Function(PointerMoveEvent) onPointerMove;
  final void Function(PointerUpEvent) onPointerUp;
  final void Function(PointerCancelEvent) onPointerCancel;
  final void Function(PointerHoverEvent) onHover;
  final void Function(PointerExitEvent) onExit;

  const TableViewHeader({
    super.key,
    required this.columns,
    required this.columnOrder,
    required this.columnWidths,
    required this.sortColumnOrderIndex,
    required this.sortDirection,
    required this.dimHeaders,
    required this.highlightSortedHeader,
    required this.highlightHeaderOnDrag,
    required this.allowColumnResizing,
    required this.isResizing,
    required this.isNearResizeBoundary,
    required this.colDragActive,
    required this.draggingColumnOrderIndex,
    required this.dropTargetColumnOrderIndex,
    required this.leadingBuilder,
    required this.trailingBuilder,
    required this.headerKey,
    required this.headerHeight,
    required this.edgeWidgetDefaultWidth,
    required this.columnStyle,
    required this.onPointerDown,
    required this.onPointerMove,
    required this.onPointerUp,
    required this.onPointerCancel,
    required this.onHover,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.fondeColorScheme;
    final textStyle = FondeTextStyleBuilder.buildTextStyleWithColor(
      variant: FondeTextVariant.uiCaption,
      context: context,
      color: cs.base.foreground,
      fontWeight: FontWeight.w500,
    );

    MouseCursor cursor = MouseCursor.defer;
    if (isResizing || isNearResizeBoundary) {
      cursor = SystemMouseCursors.resizeColumn;
    } else if (colDragActive) {
      cursor = SystemMouseCursors.grabbing;
    }

    final header = SizedBox(
      key: headerKey,
      height: headerHeight,
      child: MouseRegion(
        cursor: cursor,
        onHover: onHover,
        onExit: onExit,
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: onPointerDown,
          onPointerMove: onPointerMove,
          onPointerUp: onPointerUp,
          onPointerCancel: onPointerCancel,
          child: Row(
            children: [
              for (int i = 0; i < columnOrder.length; i++)
                _buildHeaderCell(context, cs, textStyle, i),
            ],
          ),
        ),
      ),
    );

    return Row(
      children: [
        leadingBuilder?.call() ?? SizedBox(width: edgeWidgetDefaultWidth),
        Expanded(child: header),
        trailingBuilder?.call() ?? SizedBox(width: edgeWidgetDefaultWidth),
      ],
    );
  }

  Widget _buildHeaderCell(
    BuildContext context,
    FondeColorScheme cs,
    TextStyle textStyle,
    int orderIndex,
  ) {
    final colOrigIndex = columnOrder[orderIndex];
    final col = columns[colOrigIndex];
    final width = columnWidths[colOrigIndex];
    final isSorted = sortColumnOrderIndex == orderIndex;
    final sortDir = isSorted ? sortDirection : TableViewSortDirection.none;
    final isDragging = colDragActive && draggingColumnOrderIndex == orderIndex;
    final isDropTarget =
        colDragActive && dropTargetColumnOrderIndex == orderIndex;

    Color bgColor = cs.base.background;
    if (highlightHeaderOnDrag) {
      if (isDragging) {
        bgColor = cs.interactive.list.itemBackground.hover;
      } else if (isDropTarget) {
        bgColor = cs.interactive.list.itemBackground.active;
      }
    }

    final bool sortActive =
        sortColumnOrderIndex != null &&
        sortDirection != TableViewSortDirection.none;
    final bool shouldDim =
        dimHeaders && !(highlightSortedHeader && sortActive && isSorted);
    final TextStyle cellTextStyle =
        shouldDim
            ? textStyle.copyWith(color: textStyle.color?.withAlpha(128))
            : textStyle;

    const dividerInset = 5.0;
    final showColumnDivider =
        columnStyle == FondeTableColumnStyle.divider &&
        orderIndex < columnOrder.length - 1;

    return SizedBox(
      width: width,
      height: headerHeight,
      child: ColoredBox(
        color: bgColor,
        child: Row(
          children: [
            Expanded(
              child: HeaderCell(
                col: col,
                textStyle: cellTextStyle,
                sortDirection: sortDir,
                onTap: null,
              ),
            ),
            if (showColumnDivider)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: dividerInset),
                child: VerticalDivider(
                  width: 1.0,
                  thickness: 1.0,
                  color: cs.base.border,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
