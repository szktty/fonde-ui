import 'package:flutter/material.dart';
import '../../internal.dart';
import '../typography/fonde_text_style_builder.dart';
import '../typography/fonde_text.dart';
import 'fonde_table_column.dart';

class TableViewColDragOverlay<T> extends StatelessWidget {
  final GlobalKey headerKey;
  final List<FondeTableColumn<T>> columns;
  final List<int> columnOrder;
  final List<double> columnWidths;
  final List<T> sortedData;
  final int draggingColumnOrderIndex;
  final double colDragCurrentX;
  final double colDragStartX;
  final double rowHeight;
  final double headerHeight;

  // Geometry helpers provided by state
  final double Function(int orderIndex) columnLeft;
  final double totalWidth;
  final int minDropOrderIndex;

  const TableViewColDragOverlay({
    super.key,
    required this.headerKey,
    required this.columns,
    required this.columnOrder,
    required this.columnWidths,
    required this.sortedData,
    required this.draggingColumnOrderIndex,
    required this.colDragCurrentX,
    required this.colDragStartX,
    required this.rowHeight,
    required this.headerHeight,
    required this.columnLeft,
    required this.totalWidth,
    required this.minDropOrderIndex,
  });

  @override
  Widget build(BuildContext context) {
    final box = headerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return const SizedBox.shrink();

    final headerGlobal = box.localToGlobal(Offset.zero);
    final tableHeight = box.size.height + rowHeight * sortedData.length;
    final colOrigIndex = columnOrder[draggingColumnOrderIndex];
    final colWidth = columnWidths[colOrigIndex];

    final minLeft = headerGlobal.dx + columnLeft(minDropOrderIndex);
    final rawLeft =
        headerGlobal.dx +
        (colDragCurrentX - colDragStartX) +
        columnLeft(draggingColumnOrderIndex);
    final clampedLeft = rawLeft.clamp(
      minLeft,
      headerGlobal.dx + totalWidth - colWidth,
    );

    final cs = context.fondeColorScheme;
    final textStyle = FondeTextStyleBuilder.buildTextStyleWithColor(
      variant: FondeTextVariant.uiCaption,
      context: context,
      color: cs.base.foreground,
      fontWeight: FontWeight.w500,
    );
    final col = columns[colOrigIndex];

    return Positioned(
      left: clampedLeft,
      top: headerGlobal.dy,
      width: colWidth,
      height: tableHeight,
      child: IgnorePointer(
        child: Opacity(
          opacity: 0.7,
          child: Container(
            decoration: BoxDecoration(
              color: cs.base.background,
              border: Border.symmetric(
                vertical: BorderSide(
                  color: cs.interactive.input.focusBorder,
                  width: 1.5,
                ),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: headerHeight,
                  decoration: BoxDecoration(
                    color: cs.base.background,
                    border: Border(bottom: BorderSide(color: cs.base.border)),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(col.title, style: textStyle),
                ),
                for (final item in sortedData)
                  Container(
                    height: rowHeight,
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: cs.base.border)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: col.cellBuilder(item, false),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
