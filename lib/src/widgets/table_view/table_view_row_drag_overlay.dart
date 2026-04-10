import 'package:flutter/material.dart';
import '../../internal.dart';
import 'fonde_table_column.dart';

class TableViewRowDragOverlay<T> extends StatelessWidget {
  final GlobalKey bodyKey;
  final List<FondeTableColumn<T>> columns;
  final List<int> columnOrder;
  final List<double> columnWidths;
  final List<T> sortedData;
  final int draggingRowIndex;
  final int? draggingRowCellOrderIndex;
  final double rowDragCurrentY;
  final double rowHeight;
  final bool isCellOnly;
  final Set<String>? primaryColumnIds;

  // Geometry helpers provided by state
  final double Function(int orderIndex) columnLeft;
  final double totalWidth;

  const TableViewRowDragOverlay({
    super.key,
    required this.bodyKey,
    required this.columns,
    required this.columnOrder,
    required this.columnWidths,
    required this.sortedData,
    required this.draggingRowIndex,
    required this.draggingRowCellOrderIndex,
    required this.rowDragCurrentY,
    required this.rowHeight,
    required this.isCellOnly,
    required this.primaryColumnIds,
    required this.columnLeft,
    required this.totalWidth,
  });

  @override
  Widget build(BuildContext context) {
    final box = bodyKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return const SizedBox.shrink();

    final bodyGlobal = box.localToGlobal(Offset.zero);
    final item = sortedData[draggingRowIndex];
    final cs = context.fondeColorScheme;

    final rawTop = rowDragCurrentY - rowHeight / 2;
    final clampedTop = rawTop.clamp(
      bodyGlobal.dy,
      bodyGlobal.dy + box.size.height - rowHeight,
    );

    final cellOrderIndex = draggingRowCellOrderIndex;
    double overlayLeft = bodyGlobal.dx;
    double overlayWidth = totalWidth;
    if (isCellOnly && cellOrderIndex != null) {
      overlayLeft = bodyGlobal.dx + columnLeft(cellOrderIndex);
      overlayWidth = columnWidths[columnOrder[cellOrderIndex]];
    }

    Widget cellContent;
    if (isCellOnly && cellOrderIndex != null) {
      final col = columns[columnOrder[cellOrderIndex]];
      cellContent = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: col.cellBuilder(item, true),
      );
    } else {
      cellContent = Row(
        children: [
          for (int i = 0; i < columnOrder.length; i++)
            _buildCell(context, cs, i, item),
        ],
      );
    }

    return Positioned(
      left: overlayLeft,
      top: clampedTop,
      width: overlayWidth,
      height: rowHeight,
      child: IgnorePointer(
        child: Opacity(
          opacity: 0.85,
          child: Container(
            color: cs.interactive.list.selectedBackground,
            child: cellContent,
          ),
        ),
      ),
    );
  }

  Widget _buildCell(
    BuildContext context,
    FondeColorScheme cs,
    int orderIndex,
    T item,
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
          child: col.cellBuilder(item, true),
        ),
      ),
    );
  }
}
