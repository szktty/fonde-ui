import 'package:flutter/material.dart';
import '../../internal.dart';
import '../widgets/fonde_gesture_detector.dart';
import '../icons/lucide_icons.dart';
import '../typography/fonde_text.dart';
import '../typography/fonde_text_style_builder.dart';

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
    this.onColumnReorder,
    this.onColumnResize,
    this.onRowReorder,
    this.onRowReorderWillAccept,
  });

  @override
  State<FondeTableView<T>> createState() => _FondeTableViewState<T>();
}

/// Sort direction for [FondeTableView].
enum FondeTableSortDirection { ascending, descending }

enum _SortDirection { none, ascending, descending }

class _FondeTableViewState<T> extends State<FondeTableView<T>> {
  static const double _rowHeight = 28.0;
  static const double _headerHeight = 32.0;
  static const double _resizeHitWidth = 6.0;
  static const double _minColumnWidth = 50.0;
  // Minimum pointer travel before column drag starts.
  static const double _columnDragThreshold = 4.0;

  late List<double> _columnWidths;
  late List<int> _columnOrder; // indices into widget.columns
  Set<String> _selectedKeys = {};
  int? _hoveredRowIndex;
  int? _pressedRowIndex;

  // Sort state
  int? _sortColumnOrderIndex;
  _SortDirection _sortDirection = _SortDirection.none;
  late List<T> _sortedData;

  // Column resize state
  int? _resizingColumnIndex; // order index
  double _resizeStartX = 0.0;
  double _resizeStartWidth = 0.0;
  bool _isNearResizeBoundary = false;

  // Column reorder state (Overlay-based)
  int? _draggingColumnOrderIndex;
  int? _dropTargetColumnOrderIndex;
  double _colDragStartX = 0.0; // pointer-down X in header local coords
  double _colDragCurrentX = 0.0; // current pointer X in header local coords
  bool _colDragActive = false; // true once drag threshold is exceeded
  OverlayEntry? _colDragOverlay;
  final _headerKey = GlobalKey();

  // Row reorder state
  int? _dragTargetRowIndex;

  @override
  void initState() {
    super.initState();
    _initColumns();
    _applyInitialSort();
    _sortedData = List.of(widget.data);
    _applySortToData();
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
            ? _SortDirection.ascending
            : _SortDirection.descending;
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
    super.dispose();
  }

  void _initColumns() {
    _columnWidths = widget.columns.map((c) => c.width).toList();
    _columnOrder = List.generate(widget.columns.length, (i) => i);
  }

  void _applySortToData() {
    _sortedData = List.of(widget.data);
    if (_sortColumnOrderIndex != null &&
        _sortDirection != _SortDirection.none) {
      final colOrigIndex = _columnOrder[_sortColumnOrderIndex!];
      final col = widget.columns[colOrigIndex];
      if (col.sortKeyBuilder != null) {
        _sortedData.sort((a, b) {
          final ka = col.sortKeyBuilder!(a);
          final kb = col.sortKeyBuilder!(b);
          final cmp = ka.compareTo(kb);
          return _sortDirection == _SortDirection.ascending ? cmp : -cmp;
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
        if (_sortDirection == _SortDirection.ascending) {
          _sortDirection = _SortDirection.descending;
        } else if (_sortDirection == _SortDirection.descending) {
          _sortDirection = _SortDirection.none;
          _sortColumnOrderIndex = null;
        } else {
          _sortDirection = _SortDirection.ascending;
        }
      } else {
        _sortColumnOrderIndex = orderIndex;
        _sortDirection = _SortDirection.ascending;
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
  // Column reorder (Overlay-based)
  // ---------------------------------------------------------------------------

  /// Returns the order index of the column whose header contains [localX].
  int? _columnOrderIndexAt(double localX) {
    double x = 0;
    for (int i = 0; i < _columnOrder.length; i++) {
      x += _columnWidths[_columnOrder[i]];
      if (localX < x) return i;
    }
    return null;
  }

  /// Left edge of column at [orderIndex] in header-local coordinates.
  double _columnLeft(int orderIndex) {
    double x = 0;
    for (int i = 0; i < orderIndex; i++) {
      x += _columnWidths[_columnOrder[i]];
    }
    return x;
  }

  /// Total width of all columns.
  double get _totalWidth => _columnWidths.fold(0.0, (s, w) => s + w);

  void _onHeaderPointerDown(PointerDownEvent event) {
    // Resize takes priority.
    if (_resizingColumnIndex != null) return;
    if (_resizeHandleAt(event.localPosition.dx) != null) return;

    final orderIndex = _columnOrderIndexAt(event.localPosition.dx);
    if (orderIndex == null) return;

    // Track the column for both sort (tap) and drag (reorder).
    _draggingColumnOrderIndex = orderIndex;
    _colDragStartX = event.localPosition.dx;
    _colDragCurrentX = event.localPosition.dx;
    _colDragActive = false;
    _dropTargetColumnOrderIndex = null;
  }

  void _onHeaderPointerMove(PointerMoveEvent event) {
    if (_draggingColumnOrderIndex == null) return;
    if (!widget.allowColumnReordering) return;

    _colDragCurrentX = event.localPosition.dx;

    if (!_colDragActive) {
      final travel = (_colDragCurrentX - _colDragStartX).abs();
      if (travel < _columnDragThreshold) return;
      _colDragActive = true;
      _showColDragOverlay();
    }

    // Determine drop target from current X.
    final dropTarget = _columnOrderIndexAt(_colDragCurrentX);
    if (dropTarget != _dropTargetColumnOrderIndex) {
      setState(() => _dropTargetColumnOrderIndex = dropTarget);
    }

    // Update overlay position.
    _colDragOverlay?.markNeedsBuild();
  }

  void _onHeaderPointerUp(PointerUpEvent event) {
    if (!_colDragActive) {
      // No drag happened — treat as tap for sort.
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
    final box = _headerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || _draggingColumnOrderIndex == null) {
      return const SizedBox.shrink();
    }

    final headerGlobal = box.localToGlobal(Offset.zero);
    final tableHeight = box.size.height + _rowHeight * _sortedData.length;
    final colOrigIndex = _columnOrder[_draggingColumnOrderIndex!];
    final colWidth = _columnWidths[colOrigIndex];

    // Clamp overlay X to table bounds.
    final rawLeft =
        headerGlobal.dx +
        (_colDragCurrentX - _colDragStartX) +
        _columnLeft(_draggingColumnOrderIndex!);
    final clampedLeft = rawLeft.clamp(
      headerGlobal.dx,
      headerGlobal.dx + _totalWidth - colWidth,
    );

    final cs = context.fondeColorScheme;
    final textStyle = FondeTextStyleBuilder.buildTextStyleWithColor(
      variant: FondeTextVariant.uiCaption,
      context: context,
      color: cs.base.foreground,
      fontWeight: FontWeight.w500,
    );
    final col = widget.columns[colOrigIndex];

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
                // Header cell
                Container(
                  height: _headerHeight,
                  decoration: BoxDecoration(
                    color: cs.base.background,
                    border: Border(bottom: BorderSide(color: cs.base.border)),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(col.title, style: textStyle),
                ),
                // Body cells
                for (final item in _sortedData)
                  Container(
                    height: _rowHeight,
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

  void _commitColDrag() {
    final from = _draggingColumnOrderIndex;
    final to = _dropTargetColumnOrderIndex;
    _cancelColDrag();
    if (from != null && to != null && from != to) {
      setState(() {
        final item = _columnOrder.removeAt(from);
        _columnOrder.insert(to, item);
        // Update sort column index.
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

  void _onRowReorderAccept(int fromIndex, int toIndex) {
    if (fromIndex == toIndex) return;
    widget.onRowReorder?.call(fromIndex, toIndex);
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
          _buildHeader(context, cs),
          Expanded(child: _buildBody(context, cs)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _buildHeader(BuildContext context, FondeColorScheme cs) {
    final textStyle = FondeTextStyleBuilder.buildTextStyleWithColor(
      variant: FondeTextVariant.uiCaption,
      context: context,
      color: cs.base.foreground,
      fontWeight: FontWeight.w500,
    );

    // Determine cursor:
    // 1. During resize → resizeColumn
    // 2. Near resize boundary → resizeColumn
    // 3. Column drag active → grabbing
    // 4. Draggable column hovered → grab
    // 5. Otherwise → defer
    MouseCursor cursor = MouseCursor.defer;
    if (_resizingColumnIndex != null || _isNearResizeBoundary) {
      cursor = SystemMouseCursors.resizeColumn;
    } else if (_colDragActive) {
      cursor = SystemMouseCursors.grabbing;
    } else if (_draggingColumnOrderIndex != null) {
      cursor = SystemMouseCursors.grab;
    } else if (widget.allowColumnReordering) {
      cursor = SystemMouseCursors.grab;
    }

    return SizedBox(
      key: _headerKey,
      height: _headerHeight,
      child: MouseRegion(
        cursor: cursor,
        onHover: (event) {
          if (!widget.allowColumnResizing) return;
          final handle = _resizeHandleAt(event.localPosition.dx);
          final near = handle != null;
          if (near != _isNearResizeBoundary) {
            setState(() => _isNearResizeBoundary = near);
          }
        },
        onExit: (_) {
          if (_isNearResizeBoundary) {
            setState(() => _isNearResizeBoundary = false);
          }
        },
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (e) {
            // Resize check first.
            if (widget.allowColumnResizing) {
              final handle = _resizeHandleAt(e.localPosition.dx);
              if (handle != null) {
                _startResize(handle, e.localPosition.dx);
                return;
              }
            }
            _onHeaderPointerDown(e);
          },
          onPointerMove: (e) {
            if (_resizingColumnIndex != null) {
              _updateResize(e.localPosition.dx);
            } else {
              _onHeaderPointerMove(e);
            }
          },
          onPointerUp: (e) {
            if (_resizingColumnIndex != null) {
              _endResize();
            } else {
              _onHeaderPointerUp(e);
            }
          },
          onPointerCancel: (e) {
            if (_resizingColumnIndex != null) {
              _endResize();
            } else {
              _onHeaderPointerCancel(e);
            }
          },
          child: Row(
            children: [
              for (int i = 0; i < _columnOrder.length; i++)
                _buildHeaderCell(context, cs, textStyle, i),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(
    BuildContext context,
    FondeColorScheme cs,
    TextStyle textStyle,
    int orderIndex,
  ) {
    final colOrigIndex = _columnOrder[orderIndex];
    final col = widget.columns[colOrigIndex];
    final width = _columnWidths[colOrigIndex];
    final isSorted = _sortColumnOrderIndex == orderIndex;
    final sortDir = isSorted ? _sortDirection : _SortDirection.none;
    final isDragging =
        _colDragActive && _draggingColumnOrderIndex == orderIndex;
    final isDropTarget =
        _colDragActive && _dropTargetColumnOrderIndex == orderIndex;

    Color bgColor = cs.base.background;
    if (isDragging) {
      bgColor = cs.interactive.list.itemBackground.hover;
    } else if (isDropTarget) {
      bgColor = cs.interactive.list.itemBackground.active;
    }

    // Determine header text opacity.
    // - dimHeaders: true → all headers dimmed by default
    // - highlightSortedHeader: true → sorted column restored to full opacity
    final bool sortActive =
        _sortColumnOrderIndex != null && _sortDirection != _SortDirection.none;
    final bool shouldDim =
        widget.dimHeaders &&
        !(widget.highlightSortedHeader && sortActive && isSorted);
    final TextStyle cellTextStyle =
        shouldDim
            ? textStyle.copyWith(color: textStyle.color?.withAlpha(128))
            : textStyle;

    return SizedBox(
      width: width,
      height: _headerHeight,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(
            bottom: BorderSide(color: cs.base.border, width: 1.0),
            right:
                orderIndex < _columnOrder.length - 1
                    ? BorderSide(color: cs.base.border, width: 1.0)
                    : BorderSide.none,
          ),
        ),
        child: _HeaderCell(
          col: col,
          textStyle: cellTextStyle,
          sortDirection: sortDir,
          onTap: null,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Body
  // ---------------------------------------------------------------------------

  Widget _buildBody(BuildContext context, FondeColorScheme cs) {
    return ListView.builder(
      itemCount: _sortedData.length,
      itemExtent: _rowHeight,
      itemBuilder: (context, index) {
        final item = _sortedData[index];
        final key = widget.keyExtractor(item);
        final isSelected = _selectedKeys.contains(key);
        final isHovered = _hoveredRowIndex == index;
        final isPressed = _pressedRowIndex == index;
        final isDragTarget = _dragTargetRowIndex == index;
        return _buildRow(
          context,
          cs,
          index,
          item,
          isSelected,
          isHovered,
          isPressed,
          isDragTarget,
        );
      },
    );
  }

  Widget _buildRow(
    BuildContext context,
    FondeColorScheme cs,
    int index,
    T item,
    bool isSelected,
    bool isHovered,
    bool isPressed,
    bool isDragTarget,
  ) {
    Color bgColor;
    if (isSelected) {
      bgColor = cs.interactive.list.selectedBackground;
    } else if (isPressed || isDragTarget) {
      bgColor = cs.interactive.list.itemBackground.active;
    } else if (isHovered) {
      bgColor = cs.interactive.list.itemBackground.hover;
    } else {
      bgColor = cs.base.background;
    }

    Widget row = MouseRegion(
      onEnter: (_) => setState(() => _hoveredRowIndex = index),
      onExit:
          (_) => setState(() {
            if (_hoveredRowIndex == index) _hoveredRowIndex = null;
          }),
      child: FondeGestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressedRowIndex = index),
        onTapUp: (_) => setState(() => _pressedRowIndex = null),
        onTapCancel: () => setState(() => _pressedRowIndex = null),
        onTap: () => _onRowTap(item),
        onDoubleTap:
            widget.onRowDoubleTap != null
                ? () => widget.onRowDoubleTap!(item)
                : null,
        child: Container(
          height: _rowHeight,
          color: bgColor,
          child: Row(
            children: [
              for (int i = 0; i < _columnOrder.length; i++)
                _buildBodyCell(context, cs, i, item, isSelected),
            ],
          ),
        ),
      ),
    );

    if (!widget.allowRowReordering) return row;

    final totalWidth = _totalWidth;

    return MouseRegion(
      cursor: SystemMouseCursors.grab,
      child: Draggable<int>(
        data: index,
        feedback: Material(
          color: Colors.transparent,
          child: Opacity(
            opacity: 0.85,
            child: Container(
              height: _rowHeight,
              width: totalWidth,
              color: cs.interactive.list.selectedBackground,
              child: Row(
                children: [
                  for (int i = 0; i < _columnOrder.length; i++)
                    _buildBodyCell(context, cs, i, item, true),
                ],
              ),
            ),
          ),
        ),
        onDragEnd: (_) => setState(() => _dragTargetRowIndex = null),
        child: DragTarget<int>(
          onWillAcceptWithDetails: (details) {
            final allowed =
                widget.onRowReorderWillAccept?.call(details.data, index) ??
                true;
            if (allowed) setState(() => _dragTargetRowIndex = index);
            return allowed && details.data != index;
          },
          onLeave:
              (_) => setState(() {
                if (_dragTargetRowIndex == index) _dragTargetRowIndex = null;
              }),
          onAcceptWithDetails: (details) {
            _onRowReorderAccept(details.data, index);
            setState(() => _dragTargetRowIndex = null);
          },
          builder: (context, candidateData, rejectedData) => row,
        ),
      ),
    );
  }

  Widget _buildBodyCell(
    BuildContext context,
    FondeColorScheme cs,
    int orderIndex,
    T item,
    bool isSelected,
  ) {
    final colOrigIndex = _columnOrder[orderIndex];
    final col = widget.columns[colOrigIndex];
    final width = _columnWidths[colOrigIndex];

    // When primaryColumnIds is specified, primary columns use full-opacity text
    // and non-primary columns use dimmed text.
    // null → leftmost column is primary; {} → all equal; {ids} → specified ids
    final ids = widget.primaryColumnIds;
    final isPrimary =
        ids == null
            ? _columnOrder.isNotEmpty && _columnOrder[0] == colOrigIndex
            : ids.isEmpty || ids.contains(col.id);

    return SizedBox(
      width: width,
      height: _rowHeight,
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
}

// ---------------------------------------------------------------------------
// Header cell widget
// ---------------------------------------------------------------------------

class _HeaderCell<T> extends StatelessWidget {
  final FondeTableColumn<T> col;
  final TextStyle textStyle;
  final _SortDirection sortDirection;
  final VoidCallback? onTap;

  const _HeaderCell({
    required this.col,
    required this.textStyle,
    required this.sortDirection,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget label = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              col.title,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (sortDirection == _SortDirection.ascending)
            Icon(LucideIcons.chevronUp, size: 12, color: textStyle.color),
          if (sortDirection == _SortDirection.descending)
            Icon(LucideIcons.chevronDown, size: 12, color: textStyle.color),
        ],
      ),
    );

    if (onTap != null) {
      label = GestureDetector(onTap: onTap, child: label);
    }

    return label;
  }
}

// ---------------------------------------------------------------------------
// Column definition
// ---------------------------------------------------------------------------

/// Column definition for [FondeTableView].
class FondeTableColumn<T> {
  /// Unique column identifier.
  final String id;

  /// Column header label.
  final String title;

  /// Initial column width in logical pixels.
  final double width;

  /// Minimum column width. Defaults to 50px.
  final double? minWidth;

  /// Maximum column width. Unlimited by default.
  final double? maxWidth;

  /// Builds the cell widget for the given [item].
  /// [isSelected] is true when the row is currently selected.
  final Widget Function(T item, bool isSelected) cellBuilder;

  /// Whether this column supports sorting.
  final bool sortable;

  /// Whether this column can be resized.
  final bool resizable;

  /// Extracts a comparable sort key from an item.
  /// Required when [sortable] is true.
  final Comparable Function(T item)? sortKeyBuilder;

  const FondeTableColumn({
    required this.id,
    required this.title,
    required this.width,
    required this.cellBuilder,
    this.minWidth,
    this.maxWidth,
    this.sortable = false,
    this.resizable = true,
    this.sortKeyBuilder,
  });

  FondeTableColumn<T> copyWith({
    String? id,
    String? title,
    double? width,
    double? minWidth,
    double? maxWidth,
    Widget Function(T item, bool isSelected)? cellBuilder,
    bool? sortable,
    bool? resizable,
    Comparable Function(T item)? sortKeyBuilder,
  }) {
    return FondeTableColumn<T>(
      id: id ?? this.id,
      title: title ?? this.title,
      width: width ?? this.width,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      cellBuilder: cellBuilder ?? this.cellBuilder,
      sortable: sortable ?? this.sortable,
      resizable: resizable ?? this.resizable,
      sortKeyBuilder: sortKeyBuilder ?? this.sortKeyBuilder,
    );
  }
}
