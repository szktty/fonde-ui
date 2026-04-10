import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../internal.dart';
import 'fonde_table_column.dart';
import 'table_view_body.dart';
import 'table_view_col_drag_overlay.dart';
import 'table_view_header.dart';
import 'table_view_header_cell.dart';
import 'table_view_row_drag_overlay.dart';

export 'fonde_table_column.dart';

/// A desktop-optimized table view component.
///
/// Supports column resizing, reordering, sorting, single/multi-row selection,
/// row reordering, and accessibility zoom scaling.
///
/// ## Basic Usage
/// ```dart
/// FondeTableView<MyItem>(
///   data: items,
///   columns: [
///     FondeTableColumn(
///       id: 'name',
///       title: 'Name',
///       width: 200,
///       cellBuilder: (item, isSelected) => FondeText(item.name, variant: FondeTextVariant.uiCaption),
///     ),
///   ],
///   keyExtractor: (item) => item.id,
/// )
/// ```
class FondeTableView<T> extends StatefulWidget {
  /// Table data items.
  final List<T> data;

  /// Column definitions.
  final List<FondeTableColumn<T>> columns;

  /// Function to extract a unique string key from a data item.
  final String Function(T) keyExtractor;

  /// Called when the row selection changes.
  final void Function(List<T>)? onRowsSelected;

  /// Called when a row is double-tapped.
  final void Function(T)? onRowDoubleTap;

  /// Whether multiple rows can be selected simultaneously.
  final bool allowMultiSelect;

  /// Whether columns can be reordered by dragging.
  final bool allowColumnReordering;

  /// Whether columns can be resized.
  final bool allowColumnResizing;

  /// Whether rows can be reordered by dragging.
  final bool allowRowReordering;

  /// Called when a column is reordered. Indices are into the current column order.
  final void Function(int oldIndex, int newIndex)? onColumnReorder;

  /// Called when a column is resized. Index is into the current column order.
  final void Function(int index, double newWidth)? onColumnResize;

  /// Called when a row is reordered via drag.
  final void Function(int oldIndex, int newIndex)? onRowReorder;

  /// Called while a dragged row hovers over another row.
  /// Return false to disallow dropping onto [targetIndex].
  final bool Function(int draggedIndex, int targetIndex)?
  onRowReorderWillAccept;

  /// Column id to sort by on initial display. Requires the column to have
  /// [FondeTableColumn.sortable] true and a [FondeTableColumn.sortKeyBuilder].
  final String? initialSortColumnId;

  /// Initial sort direction. Defaults to [FondeTableSortDirection.ascending].
  final FondeTableSortDirection initialSortDirection;

  /// When true, header text and icons are shown at reduced opacity (dimmed).
  /// Defaults to true.
  final bool dimHeaders;

  /// When true and a column is actively sorted, that column's header is shown
  /// at full opacity while others remain dimmed. Only meaningful when
  /// [dimHeaders] is true. Defaults to true.
  final bool highlightSortedHeader;

  /// Column ids whose cell content is shown at full opacity.
  /// All other columns are dimmed.
  ///
  /// Defaults to `null`, which means the leftmost column (in current display
  /// order) is automatically treated as primary. Pass `const {}` to disable
  /// this behavior and show all columns at equal opacity.
  final Set<String>? primaryColumnIds;

  /// When true, the dragged column and its drop target are highlighted during
  /// column reordering. Defaults to false.
  final bool highlightHeaderOnDrag;

  /// When true, rows are highlighted when hovered. Defaults to false.
  final bool highlightRowOnHover;

  /// Visual indicator style for the row insertion position during reordering.
  /// Defaults to [FondeTableRowReorderIndicator.line].
  final FondeTableRowReorderIndicator rowReorderIndicator;

  /// Controls what is shown as the drag overlay during row reordering.
  /// Defaults to [FondeTableRowDragStyle.fullRow].
  final FondeTableRowDragStyle rowDragStyle;

  /// Builds a widget shown to the left of the header row.
  /// The widget is not part of any column and sits outside the column area.
  final Widget Function()? headerLeadingBuilder;

  /// Builds a widget shown to the left of each data row.
  /// The widget is not part of any column and sits outside the column area.
  final Widget Function(T item)? rowLeadingBuilder;

  /// Builds a widget shown to the right of the header row.
  final Widget Function()? headerTrailingBuilder;

  /// Builds a widget shown to the right of each data row.
  final Widget Function(T item)? rowTrailingBuilder;

  const FondeTableView({
    super.key,
    required this.data,
    required this.columns,
    required this.keyExtractor,
    this.onRowsSelected,
    this.onRowDoubleTap,
    this.allowMultiSelect = false,
    this.allowColumnReordering = true,
    this.allowColumnResizing = true,
    this.allowRowReordering = false,
    this.initialSortColumnId,
    this.initialSortDirection = FondeTableSortDirection.ascending,
    this.dimHeaders = true,
    this.highlightSortedHeader = true,
    this.primaryColumnIds,
    this.highlightHeaderOnDrag = false,
    this.highlightRowOnHover = false,
    this.rowReorderIndicator = FondeTableRowReorderIndicator.line,
    this.rowDragStyle = FondeTableRowDragStyle.fullRow,
    this.headerLeadingBuilder,
    this.rowLeadingBuilder,
    this.headerTrailingBuilder,
    this.rowTrailingBuilder,
    this.onColumnReorder,
    this.onColumnResize,
    this.onRowReorder,
    this.onRowReorderWillAccept,
  });

  @override
  State<FondeTableView<T>> createState() => _FondeTableViewState<T>();
}

/// Controls what is shown as the drag overlay during row reordering.
enum FondeTableRowDragStyle {
  /// The entire row is shown as the drag overlay. (default)
  fullRow,

  /// Only the cell that was pressed is shown as the drag overlay.
  cellOnly,
}

/// Controls the visual indicator shown at the drop position during row reordering.
enum FondeTableRowReorderIndicator {
  /// A simple horizontal line at the insertion position. (default)
  line,

  /// A horizontal line with a small circle at the left end.
  lineWithDot,
}

/// Sort direction for [FondeTableView].
enum FondeTableSortDirection { ascending, descending }

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class _FondeTableViewState<T> extends State<FondeTableView<T>> {
  static const double _rowHeight = 28.0;
  static const double _headerHeight = 32.0;
  static const double _resizeHitWidth = 6.0;
  static const double _minColumnWidth = 50.0;
  static const double _columnDragThreshold = 4.0;
  static const double _rowDragThreshold = 4.0;
  static const double _edgeWidgetDefaultWidth = 8.0;

  late List<double> _columnWidths;
  late List<int> _columnOrder;
  Set<String> _selectedKeys = {};
  int? _hoveredRowIndex;
  int? _pressedRowIndex;

  // Sort state
  int? _sortColumnOrderIndex;
  TableViewSortDirection _sortDirection = TableViewSortDirection.none;
  late List<T> _sortedData;

  // Column resize state
  int? _resizingColumnIndex;
  double _resizeStartX = 0.0;
  double _resizeStartWidth = 0.0;
  bool _isNearResizeBoundary = false;

  // Column reorder state
  int? _draggingColumnOrderIndex;
  int? _dropTargetColumnOrderIndex;
  double _colDragStartX = 0.0;
  double _colDragCurrentX = 0.0;
  bool _colDragActive = false;
  OverlayEntry? _colDragOverlay;
  final _headerKey = GlobalKey();

  // Row reorder state
  int? _draggingRowIndex;
  int? _draggingRowCellOrderIndex;
  int? _dropTargetRowIndex;
  double _rowDragStartY = 0.0;
  double _rowDragCurrentY = 0.0;
  bool _rowDragActive = false;
  OverlayEntry? _rowDragOverlay;
  final _bodyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initColumns();
    _applyInitialSort();
    _sortedData = List.of(widget.data);
    _applySortToData();
  }

  @override
  void didUpdateWidget(FondeTableView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.columns != oldWidget.columns) {
      _initColumns();
    }
    if (widget.data != oldWidget.data) {
      _applySortToData();
      final existingKeys = widget.data.map(widget.keyExtractor).toSet();
      _selectedKeys = _selectedKeys.intersection(existingKeys);
    }
  }

  @override
  void dispose() {
    _removeColDragOverlay();
    _removeRowDragOverlay();
    super.dispose();
  }

  void _initColumns() {
    _columnWidths = widget.columns.map((c) => c.width).toList();
    _columnOrder = List.generate(widget.columns.length, (i) => i);
  }

  void _applyInitialSort() {
    final id = widget.initialSortColumnId;
    if (id == null) return;
    final origIndex = widget.columns.indexWhere((c) => c.id == id);
    if (origIndex == -1) return;
    final orderIndex = _columnOrder.indexOf(origIndex);
    if (orderIndex == -1) return;
    _sortColumnOrderIndex = orderIndex;
    _sortDirection =
        widget.initialSortDirection == FondeTableSortDirection.ascending
            ? TableViewSortDirection.ascending
            : TableViewSortDirection.descending;
  }

  void _applySortToData() {
    _sortedData = List.of(widget.data);
    if (_sortColumnOrderIndex != null &&
        _sortDirection != TableViewSortDirection.none) {
      final colOrigIndex = _columnOrder[_sortColumnOrderIndex!];
      final col = widget.columns[colOrigIndex];
      if (col.sortKeyBuilder != null) {
        _sortedData.sort((a, b) {
          final ka = col.sortKeyBuilder!(a);
          final kb = col.sortKeyBuilder!(b);
          final cmp = ka.compareTo(kb);
          return _sortDirection == TableViewSortDirection.ascending
              ? cmp
              : -cmp;
        });
      }
    }
  }

  void _onSortColumn(int orderIndex) {
    final colOrigIndex = _columnOrder[orderIndex];
    final col = widget.columns[colOrigIndex];
    if (!col.sortable) return;

    setState(() {
      if (_sortColumnOrderIndex == orderIndex) {
        if (_sortDirection == TableViewSortDirection.ascending) {
          _sortDirection = TableViewSortDirection.descending;
        } else if (_sortDirection == TableViewSortDirection.descending) {
          _sortDirection = TableViewSortDirection.none;
          _sortColumnOrderIndex = null;
        } else {
          _sortDirection = TableViewSortDirection.ascending;
        }
      } else {
        _sortColumnOrderIndex = orderIndex;
        _sortDirection = TableViewSortDirection.ascending;
      }
      _applySortToData();
    });
  }

  void _onRowTap(T item) {
    final key = widget.keyExtractor(item);
    setState(() {
      if (widget.allowMultiSelect) {
        if (_selectedKeys.contains(key)) {
          _selectedKeys = Set.of(_selectedKeys)..remove(key);
        } else {
          _selectedKeys = Set.of(_selectedKeys)..add(key);
        }
      } else {
        _selectedKeys = {key};
      }
    });
    final selected =
        _sortedData
            .where((d) => _selectedKeys.contains(widget.keyExtractor(d)))
            .toList();
    widget.onRowsSelected?.call(selected);
  }

  // ---------------------------------------------------------------------------
  // Column resize
  // ---------------------------------------------------------------------------

  int? _resizeHandleAt(double localX) {
    double x = 0;
    for (int i = 0; i < _columnOrder.length; i++) {
      x += _columnWidths[_columnOrder[i]];
      if ((localX - x).abs() < _resizeHitWidth) return i;
    }
    return null;
  }

  void _startResize(int orderIndex, double startX) {
    _resizingColumnIndex = orderIndex;
    _resizeStartX = startX;
    _resizeStartWidth = _columnWidths[_columnOrder[orderIndex]];
  }

  void _updateResize(double currentX) {
    if (_resizingColumnIndex == null) return;
    final colOrigIndex = _columnOrder[_resizingColumnIndex!];
    final col = widget.columns[colOrigIndex];
    final delta = currentX - _resizeStartX;
    final minW = col.minWidth ?? _minColumnWidth;
    final maxW = col.maxWidth ?? double.infinity;
    final newWidth = (_resizeStartWidth + delta).clamp(minW, maxW);
    setState(() => _columnWidths[colOrigIndex] = newWidth);
    widget.onColumnResize?.call(_resizingColumnIndex!, newWidth);
  }

  void _endResize() => setState(() => _resizingColumnIndex = null);

  // ---------------------------------------------------------------------------
  // Column reorder
  // ---------------------------------------------------------------------------

  int? _columnOrderIndexAt(double localX) {
    double x = 0;
    for (int i = 0; i < _columnOrder.length; i++) {
      x += _columnWidths[_columnOrder[i]];
      if (localX < x) return i;
    }
    return null;
  }

  int _dropInsertIndexAt(double localX) {
    final minDrop = _minDropOrderIndex();
    double x = 0;
    for (int i = 0; i < _columnOrder.length; i++) {
      final w = _columnWidths[_columnOrder[i]];
      final mid = x + w / 2;
      if (localX < mid) {
        return i.clamp(minDrop, _columnOrder.length - 1);
      }
      x += w;
    }
    return _columnOrder.length - 1;
  }

  double _columnLeft(int orderIndex) {
    double x = 0;
    for (int i = 0; i < orderIndex; i++) {
      x += _columnWidths[_columnOrder[i]];
    }
    return x;
  }

  double get _totalWidth => _columnWidths.fold(0.0, (s, w) => s + w);

  int _minDropOrderIndex() {
    int min = 0;
    for (int i = 0; i < _columnOrder.length; i++) {
      if (widget.columns[_columnOrder[i]].fixed) {
        min = i + 1;
      } else {
        break;
      }
    }
    return min;
  }

  void _onHeaderPointerDown(PointerDownEvent event) {
    if (_resizingColumnIndex != null) return;
    if (_resizeHandleAt(event.localPosition.dx) != null) return;

    final orderIndex = _columnOrderIndexAt(event.localPosition.dx);
    if (orderIndex == null) return;

    _draggingColumnOrderIndex = orderIndex;
    _colDragStartX = event.localPosition.dx;
    _colDragCurrentX = event.localPosition.dx;
    _colDragActive = false;
    _dropTargetColumnOrderIndex = null;
  }

  void _onHeaderPointerMove(PointerMoveEvent event) {
    if (_draggingColumnOrderIndex == null) return;
    if (!widget.allowColumnReordering) return;

    final dragOrigIndex = _columnOrder[_draggingColumnOrderIndex!];
    if (widget.columns[dragOrigIndex].fixed) return;

    _colDragCurrentX = event.localPosition.dx;

    if (!_colDragActive) {
      final travel = (_colDragCurrentX - _colDragStartX).abs();
      if (travel < _columnDragThreshold) return;
      _colDragActive = true;
      _showColDragOverlay();
    }

    final dropTarget = _dropInsertIndexAt(_colDragCurrentX);
    if (dropTarget != _dropTargetColumnOrderIndex) {
      setState(() => _dropTargetColumnOrderIndex = dropTarget);
    }

    _colDragOverlay?.markNeedsBuild();
  }

  void _onHeaderPointerUp(PointerUpEvent event) {
    if (!_colDragActive) {
      final orderIndex = _draggingColumnOrderIndex;
      _cancelColDrag();
      if (orderIndex != null) _onSortColumn(orderIndex);
      return;
    }
    if (widget.allowColumnReordering) {
      _commitColDrag();
    } else {
      _cancelColDrag();
    }
  }

  void _onHeaderPointerCancel(PointerCancelEvent event) => _cancelColDrag();

  void _showColDragOverlay() {
    _removeColDragOverlay();
    final overlay = Overlay.of(context);
    _colDragOverlay = OverlayEntry(builder: _buildColDragOverlay);
    overlay.insert(_colDragOverlay!);
    setState(() {});
  }

  void _removeColDragOverlay() {
    _colDragOverlay?.remove();
    _colDragOverlay = null;
  }

  Widget _buildColDragOverlay(BuildContext context) {
    final idx = _draggingColumnOrderIndex;
    if (idx == null) return const SizedBox.shrink();
    return TableViewColDragOverlay<T>(
      headerKey: _headerKey,
      columns: widget.columns,
      columnOrder: _columnOrder,
      columnWidths: _columnWidths,
      sortedData: _sortedData,
      draggingColumnOrderIndex: idx,
      colDragCurrentX: _colDragCurrentX,
      colDragStartX: _colDragStartX,
      rowHeight: _rowHeight,
      headerHeight: _headerHeight,
      columnLeft: _columnLeft,
      totalWidth: _totalWidth,
      minDropOrderIndex: _minDropOrderIndex(),
    );
  }

  void _commitColDrag() {
    final from = _draggingColumnOrderIndex;
    final to = _dropTargetColumnOrderIndex;
    _cancelColDrag();
    if (from == null || to == null) return;
    if (from != to) {
      setState(() {
        final item = _columnOrder.removeAt(from);
        _columnOrder.insert(to, item);
        if (_sortColumnOrderIndex != null) {
          if (_sortColumnOrderIndex == from) {
            _sortColumnOrderIndex = to;
          } else if (from < to) {
            if (_sortColumnOrderIndex! > from && _sortColumnOrderIndex! <= to) {
              _sortColumnOrderIndex = _sortColumnOrderIndex! - 1;
            }
          } else {
            if (_sortColumnOrderIndex! >= to && _sortColumnOrderIndex! < from) {
              _sortColumnOrderIndex = _sortColumnOrderIndex! + 1;
            }
          }
        }
      });
      widget.onColumnReorder?.call(from, to);
    }
  }

  void _cancelColDrag() {
    _removeColDragOverlay();
    setState(() {
      _draggingColumnOrderIndex = null;
      _dropTargetColumnOrderIndex = null;
      _colDragActive = false;
    });
  }

  // ---------------------------------------------------------------------------
  // Row reorder
  // ---------------------------------------------------------------------------

  void _onRowPointerDown(PointerDownEvent event, int rowIndex, double localX) {
    if (!widget.allowRowReordering) return;
    _draggingRowIndex = rowIndex;
    _draggingRowCellOrderIndex = _columnOrderIndexAt(localX);
    _rowDragStartY = event.position.dy;
    _rowDragCurrentY = event.position.dy;
    _rowDragActive = false;
    _dropTargetRowIndex = null;
  }

  void _onRowPointerMove(PointerMoveEvent event) {
    if (_draggingRowIndex == null) return;
    _rowDragCurrentY = event.position.dy;

    if (!_rowDragActive) {
      if ((_rowDragCurrentY - _rowDragStartY).abs() < _rowDragThreshold) {
        return;
      }
      _rowDragActive = true;
      _showRowDragOverlay();
    }

    final dropTarget = _rowDropIndexAt(_rowDragCurrentY);
    if (dropTarget != _dropTargetRowIndex) {
      setState(() => _dropTargetRowIndex = dropTarget);
    }
    _rowDragOverlay?.markNeedsBuild();
  }

  void _onRowPointerUp(PointerUpEvent event) {
    if (!_rowDragActive) {
      _cancelRowDrag();
      return;
    }
    _commitRowDrag();
  }

  void _onRowPointerCancel(PointerCancelEvent event) => _cancelRowDrag();

  int _rowDropIndexAt(double globalY) {
    final box = _bodyKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return _draggingRowIndex!;
    final localY = box.globalToLocal(Offset(0, globalY)).dy;
    final rowIndex = (localY / _rowHeight).floor().clamp(
      0,
      _sortedData.length - 1,
    );
    final rowMid = rowIndex * _rowHeight + _rowHeight / 2;
    final insertAt = localY < rowMid ? rowIndex : rowIndex + 1;
    return insertAt.clamp(0, _sortedData.length);
  }

  void _showRowDragOverlay() {
    _removeRowDragOverlay();
    _rowDragOverlay = OverlayEntry(builder: _buildRowDragOverlay);
    Overlay.of(context).insert(_rowDragOverlay!);
    setState(() {});
  }

  void _removeRowDragOverlay() {
    _rowDragOverlay?.remove();
    _rowDragOverlay = null;
  }

  Widget _buildRowDragOverlay(BuildContext context) {
    final idx = _draggingRowIndex;
    if (idx == null) return const SizedBox.shrink();
    return TableViewRowDragOverlay<T>(
      bodyKey: _bodyKey,
      columns: widget.columns,
      columnOrder: _columnOrder,
      columnWidths: _columnWidths,
      sortedData: _sortedData,
      draggingRowIndex: idx,
      draggingRowCellOrderIndex: _draggingRowCellOrderIndex,
      rowDragCurrentY: _rowDragCurrentY,
      rowHeight: _rowHeight,
      isCellOnly: widget.rowDragStyle == FondeTableRowDragStyle.cellOnly,
      primaryColumnIds: widget.primaryColumnIds,
      columnLeft: _columnLeft,
      totalWidth: _totalWidth,
    );
  }

  void _commitRowDrag() {
    final from = _draggingRowIndex;
    final to = _dropTargetRowIndex;
    _cancelRowDrag();
    if (from == null || to == null || from == to) return;
    widget.onRowReorder?.call(from, to);
  }

  void _cancelRowDrag() {
    _removeRowDragOverlay();
    setState(() {
      _draggingRowIndex = null;
      _draggingRowCellOrderIndex = null;
      _dropTargetRowIndex = null;
      _rowDragActive = false;
    });
  }

  // ---------------------------------------------------------------------------
  // Header pointer dispatch (resize takes priority over reorder)
  // ---------------------------------------------------------------------------

  void _handleHeaderPointerDown(PointerDownEvent e) {
    if (widget.allowColumnResizing) {
      final handle = _resizeHandleAt(e.localPosition.dx);
      if (handle != null) {
        _startResize(handle, e.localPosition.dx);
        return;
      }
    }
    _onHeaderPointerDown(e);
  }

  void _handleHeaderPointerMove(PointerMoveEvent e) {
    if (_resizingColumnIndex != null) {
      _updateResize(e.localPosition.dx);
    } else {
      _onHeaderPointerMove(e);
    }
  }

  void _handleHeaderPointerUp(PointerUpEvent e) {
    if (_resizingColumnIndex != null) {
      _endResize();
    } else {
      _onHeaderPointerUp(e);
    }
  }

  void _handleHeaderPointerCancel(PointerCancelEvent e) {
    if (_resizingColumnIndex != null) {
      _endResize();
    } else {
      _onHeaderPointerCancel(e);
    }
  }

  void _handleHeaderHover(PointerHoverEvent event) {
    if (!widget.allowColumnResizing) return;
    final handle = _resizeHandleAt(event.localPosition.dx);
    final near = handle != null;
    if (near != _isNearResizeBoundary) {
      setState(() => _isNearResizeBoundary = near);
    }
  }

  void _handleHeaderExit(PointerExitEvent _) {
    if (_isNearResizeBoundary) {
      setState(() => _isNearResizeBoundary = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final cs = context.fondeColorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.base.background,
        border: Border.all(
          color: cs.base.border,
          width: 1.0 * context.fondeBorderScale,
        ),
      ),
      child: Column(
        children: [
          TableViewHeader<T>(
            columns: widget.columns,
            columnOrder: _columnOrder,
            columnWidths: _columnWidths,
            sortColumnOrderIndex: _sortColumnOrderIndex,
            sortDirection: _sortDirection,
            dimHeaders: widget.dimHeaders,
            highlightSortedHeader: widget.highlightSortedHeader,
            highlightHeaderOnDrag: widget.highlightHeaderOnDrag,
            allowColumnResizing: widget.allowColumnResizing,
            isResizing: _resizingColumnIndex != null,
            isNearResizeBoundary: _isNearResizeBoundary,
            colDragActive: _colDragActive,
            draggingColumnOrderIndex: _draggingColumnOrderIndex,
            dropTargetColumnOrderIndex: _dropTargetColumnOrderIndex,
            leadingBuilder: widget.headerLeadingBuilder,
            trailingBuilder: widget.headerTrailingBuilder,
            headerKey: _headerKey,
            headerHeight: _headerHeight,
            edgeWidgetDefaultWidth: _edgeWidgetDefaultWidth,
            onPointerDown: _handleHeaderPointerDown,
            onPointerMove: _handleHeaderPointerMove,
            onPointerUp: _handleHeaderPointerUp,
            onPointerCancel: _handleHeaderPointerCancel,
            onHover: _handleHeaderHover,
            onExit: _handleHeaderExit,
          ),
          Expanded(
            child: TableViewBody<T>(
              sortedData: _sortedData,
              keyExtractor: widget.keyExtractor,
              columns: widget.columns,
              columnOrder: _columnOrder,
              columnWidths: _columnWidths,
              selectedKeys: _selectedKeys,
              primaryColumnIds: widget.primaryColumnIds,
              hoveredRowIndex: _hoveredRowIndex,
              pressedRowIndex: _pressedRowIndex,
              rowDragActive: _rowDragActive,
              draggingRowIndex: _draggingRowIndex,
              dropTargetRowIndex: _dropTargetRowIndex,
              allowRowReordering: widget.allowRowReordering,
              highlightRowOnHover: widget.highlightRowOnHover,
              rowReorderIndicator: widget.rowReorderIndicator,
              rowHeight: _rowHeight,
              edgeWidgetDefaultWidth: _edgeWidgetDefaultWidth,
              bodyKey: _bodyKey,
              rowLeadingBuilder: widget.rowLeadingBuilder,
              rowTrailingBuilder: widget.rowTrailingBuilder,
              onPointerDown: _onRowPointerDown,
              onPointerMove: _onRowPointerMove,
              onPointerUp: _onRowPointerUp,
              onPointerCancel: _onRowPointerCancel,
              onRowTap: _onRowTap,
              onRowDoubleTap: widget.onRowDoubleTap,
              onTapDown: (index) => setState(() => _pressedRowIndex = index),
              onTapUp: () => setState(() => _pressedRowIndex = null),
              onTapCancel: () => setState(() => _pressedRowIndex = null),
              onEnter: (index) => setState(() => _hoveredRowIndex = index),
              onExit:
                  (index) => setState(() {
                    if (_hoveredRowIndex == index) _hoveredRowIndex = null;
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
