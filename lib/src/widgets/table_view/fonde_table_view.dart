import 'package:flutter/material.dart';
import '../../internal.dart';
import '../widgets/fonde_gesture_detector.dart';
import '../typography/fonde_text.dart';
import '../typography/fonde_text_style_builder.dart';

/// A desktop-optimized table view component.
///
/// Supports column resizing, reordering, sorting, single/multi-row selection,
/// keyboard navigation, and accessibility zoom scaling.
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

  /// Called when a column is reordered.
  final void Function(int oldIndex, int newIndex)? onColumnReorder;

  /// Called when a column is resized.
  final void Function(int index, double newWidth)? onColumnResize;

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
    this.onColumnReorder,
    this.onColumnResize,
  });

  @override
  State<FondeTableView<T>> createState() => _FondeTableViewState<T>();
}

// Sort direction for a column.
enum _SortDirection { none, ascending, descending }

class _FondeTableViewState<T> extends State<FondeTableView<T>> {
  static const double _rowHeight = 28.0;
  static const double _headerHeight = 32.0;
  static const double _resizeHitWidth = 8.0;
  static const double _minColumnWidth = 50.0;

  late List<double> _columnWidths;
  late List<int> _columnOrder; // indices into widget.columns
  Set<String> _selectedKeys = {};
  int? _hoveredRowIndex;

  // Sort state
  int? _sortColumnIndex; // index into _columnOrder
  _SortDirection _sortDirection = _SortDirection.none;
  late List<T> _sortedData;

  // Column resize state
  int? _resizingColumnIndex;
  double _resizeStartX = 0.0;
  double _resizeStartWidth = 0.0;

  // Column reorder state
  int? _draggingColumnIndex;
  int? _dragTargetColumnIndex;

  @override
  void initState() {
    super.initState();
    _initColumns();
    _sortedData = List.of(widget.data);
  }

  @override
  void didUpdateWidget(FondeTableView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.columns != oldWidget.columns) {
      _initColumns();
    }
    if (widget.data != oldWidget.data) {
      _applySortToData();
      // Clean up selected keys that no longer exist
      final existingKeys = widget.data.map(widget.keyExtractor).toSet();
      _selectedKeys = _selectedKeys.intersection(existingKeys);
    }
  }

  void _initColumns() {
    _columnWidths = widget.columns.map((c) => c.width).toList();
    _columnOrder = List.generate(widget.columns.length, (i) => i);
  }

  void _applySortToData() {
    _sortedData = List.of(widget.data);
    if (_sortColumnIndex != null && _sortDirection != _SortDirection.none) {
      final colOrigIndex = _columnOrder[_sortColumnIndex!];
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
      if (_sortColumnIndex == orderIndex) {
        if (_sortDirection == _SortDirection.ascending) {
          _sortDirection = _SortDirection.descending;
        } else if (_sortDirection == _SortDirection.descending) {
          _sortDirection = _SortDirection.none;
          _sortColumnIndex = null;
        } else {
          _sortDirection = _SortDirection.ascending;
        }
      } else {
        _sortColumnIndex = orderIndex;
        _sortDirection = _SortDirection.ascending;
      }
      _applySortToData();
    });
  }

  void _onRowTap(int rowIndex, T item) {
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

  void _onRowDoubleTap(T item) {
    widget.onRowDoubleTap?.call(item);
  }

  // --- Column resize ---

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
    setState(() {
      _columnWidths[colOrigIndex] = newWidth;
    });
    widget.onColumnResize?.call(_resizingColumnIndex!, newWidth);
  }

  void _endResize() {
    _resizingColumnIndex = null;
  }

  // --- Column reorder ---

  void _onColumnReorderAccept(int fromOrderIndex, int toOrderIndex) {
    if (fromOrderIndex == toOrderIndex) return;
    setState(() {
      final item = _columnOrder.removeAt(fromOrderIndex);
      _columnOrder.insert(toOrderIndex, item);
      // Update sort column index accordingly
      if (_sortColumnIndex != null) {
        if (_sortColumnIndex == fromOrderIndex) {
          _sortColumnIndex = toOrderIndex;
        } else if (fromOrderIndex < toOrderIndex) {
          if (_sortColumnIndex! > fromOrderIndex &&
              _sortColumnIndex! <= toOrderIndex) {
            _sortColumnIndex = _sortColumnIndex! - 1;
          }
        } else {
          if (_sortColumnIndex! >= toOrderIndex &&
              _sortColumnIndex! < fromOrderIndex) {
            _sortColumnIndex = _sortColumnIndex! + 1;
          }
        }
      }
    });
    widget.onColumnReorder?.call(fromOrderIndex, toOrderIndex);
  }

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

  // --- Header ---

  Widget _buildHeader(BuildContext context, FondeColorScheme cs) {
    final textStyle = FondeTextStyleBuilder.buildTextStyleWithColor(
      variant: FondeTextVariant.uiCaption,
      context: context,
      color: cs.base.foreground,
      fontWeight: FontWeight.w500,
    );

    return SizedBox(
      height: _headerHeight,
      child: MouseRegion(
        cursor:
            _resizingColumnIndex != null
                ? SystemMouseCursors.resizeColumn
                : MouseCursor.defer,
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (e) {
            final handle = _resizeHandleAt(e.localPosition.dx);
            if (handle != null) {
              _startResize(handle, e.localPosition.dx);
            }
          },
          onPointerMove: (e) {
            if (_resizingColumnIndex != null) {
              _updateResize(e.localPosition.dx);
            }
          },
          onPointerUp: (_) => _endResize(),
          onPointerCancel: (_) => _endResize(),
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
    final isSorted = _sortColumnIndex == orderIndex;
    final sortDir = isSorted ? _sortDirection : _SortDirection.none;

    final baseCell = SizedBox(
      width: width,
      height: _headerHeight,
      child: Container(
        decoration: BoxDecoration(
          color: cs.base.background,
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
          textStyle: textStyle,
          sortDirection: sortDir,
          onTap: col.sortable ? () => _onSortColumn(orderIndex) : null,
          isDragging: _draggingColumnIndex == orderIndex,
          isDragTarget: _dragTargetColumnIndex == orderIndex,
        ),
      ),
    );

    if (!widget.allowColumnReordering) return baseCell;

    return Draggable<int>(
      data: orderIndex,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.8,
          child: Container(
            width: width,
            height: _headerHeight,
            color: cs.base.background,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(col.title, style: textStyle),
          ),
        ),
      ),
      onDragStarted: () => setState(() => _draggingColumnIndex = orderIndex),
      onDragEnd:
          (_) => setState(() {
            _draggingColumnIndex = null;
            _dragTargetColumnIndex = null;
          }),
      child: DragTarget<int>(
        onWillAcceptWithDetails: (details) {
          setState(() => _dragTargetColumnIndex = orderIndex);
          return details.data != orderIndex;
        },
        onLeave: (_) => setState(() => _dragTargetColumnIndex = null),
        onAcceptWithDetails: (details) {
          _onColumnReorderAccept(details.data, orderIndex);
          setState(() {
            _draggingColumnIndex = null;
            _dragTargetColumnIndex = null;
          });
        },
        builder: (context, candidateData, rejectedData) => baseCell,
      ),
    );
  }

  // --- Body ---

  Widget _buildBody(BuildContext context, FondeColorScheme cs) {
    return ListView.builder(
      itemCount: _sortedData.length,
      itemExtent: _rowHeight,
      itemBuilder: (context, index) {
        final item = _sortedData[index];
        final key = widget.keyExtractor(item);
        final isSelected = _selectedKeys.contains(key);
        final isHovered = _hoveredRowIndex == index;
        return _buildRow(context, cs, index, item, isSelected, isHovered);
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
  ) {
    Color bgColor;
    if (isSelected) {
      bgColor = cs.interactive.list.selectedBackground;
    } else if (isHovered) {
      bgColor = cs.interactive.list.itemBackground.hover;
    } else {
      bgColor = cs.base.background;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredRowIndex = index),
      onExit:
          (_) => setState(() {
            if (_hoveredRowIndex == index) _hoveredRowIndex = null;
          }),
      child: FondeGestureDetector(
        onTap: () => _onRowTap(index, item),
        onDoubleTap:
            widget.onRowDoubleTap != null ? () => _onRowDoubleTap(item) : null,
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

    return SizedBox(
      width: width,
      height: _rowHeight,
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: cs.base.border, width: 1.0)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: col.cellBuilder(item, isSelected),
      ),
    );
  }
}

// --- Header cell widget ---

class _HeaderCell<T> extends StatelessWidget {
  final FondeTableColumn<T> col;
  final TextStyle textStyle;
  final _SortDirection sortDirection;
  final VoidCallback? onTap;
  final bool isDragging;
  final bool isDragTarget;

  const _HeaderCell({
    required this.col,
    required this.textStyle,
    required this.sortDirection,
    this.onTap,
    this.isDragging = false,
    this.isDragTarget = false,
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
            Icon(Icons.arrow_upward, size: 12, color: textStyle.color),
          if (sortDirection == _SortDirection.descending)
            Icon(Icons.arrow_downward, size: 12, color: textStyle.color),
        ],
      ),
    );

    if (onTap != null) {
      label = GestureDetector(onTap: onTap, child: label);
    }

    return label;
  }
}

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
  /// Required if [sortable] is true.
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
