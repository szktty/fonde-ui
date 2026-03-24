import 'package:flutter/material.dart';
import '../../internal.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../typography/fonde_text_style_builder.dart';
import '../typography/fonde_text.dart';

/// A desktop-optimized table view component based on pluto_grid.
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

class _FondeTableViewState<T> extends State<FondeTableView<T>> {
  List<T> _selectedRows = [];
  PlutoGridStateManager? _stateManager;
  late List<PlutoColumn> _plutoColumns;
  late List<PlutoRow> _plutoRows;

  // For double-tap detection
  DateTime? _lastTapTime;
  static const Duration _doubleTapTimeout = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _buildPlutoData();
  }

  @override
  void didUpdateWidget(FondeTableView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.columns != oldWidget.columns || widget.data != oldWidget.data) {
      _buildPlutoData();
      if (mounted) setState(() {});
    }
  }

  void _buildPlutoData() {
    _plutoColumns =
        widget.columns.map((col) {
          return PlutoColumn(
            title: col.title,
            field: col.id,
            type: PlutoColumnType.text(),
            width: col.width,
            minWidth: col.minWidth ?? 50.0,
            enableColumnDrag: widget.allowColumnReordering,
            enableSorting: col.sortable,
            enableContextMenu: false,
            enableDropToResize: widget.allowColumnResizing,
            renderer: (rendererContext) {
              final rowIndex = rendererContext.rowIdx;
              if (rowIndex < widget.data.length) {
                final item = widget.data[rowIndex];
                final isSelected = _selectedRows.any(
                  (s) => widget.keyExtractor(s) == widget.keyExtractor(item),
                );
                return col.cellBuilder(item, isSelected);
              }
              return const SizedBox.shrink();
            },
          );
        }).toList();

    _plutoRows =
        widget.data.asMap().entries.map((entry) {
          final item = entry.value;
          final key = widget.keyExtractor(item);
          final cells = <String, PlutoCell>{};
          for (final col in widget.columns) {
            cells[col.id] = PlutoCell(value: key);
          }
          return PlutoRow(key: ValueKey(key), cells: cells);
        }).toList();
  }

  void _onSelectionChanged(List<T> items) {
    setState(() => _selectedRows = items);
    widget.onRowsSelected?.call(items);
  }

  void _handlePointerDown(PointerDownEvent event) {
    final rowIndex = _rowIndexFromPosition(event.localPosition);
    if (rowIndex == null) return;

    final now = DateTime.now();
    final isDoubleTap =
        _lastTapTime != null &&
        now.difference(_lastTapTime!) < _doubleTapTimeout;

    if (isDoubleTap) {
      _lastTapTime = null;
      if (rowIndex < widget.data.length) {
        widget.onRowDoubleTap?.call(widget.data[rowIndex]);
      }
      return;
    }

    _lastTapTime = now;
    _handleRowSelection(rowIndex);
  }

  /// Calculates row index from a tap position, accounting for scroll offset.
  int? _rowIndexFromPosition(Offset localPosition) {
    final sm = _stateManager;
    if (sm == null) return null;

    final headerHeight = sm.configuration.style.columnHeight;
    if (localPosition.dy < headerHeight) return null;

    final rowHeight = sm.configuration.style.rowHeight;
    final scrollOffset = sm.scroll.bodyRowsVertical?.offset ?? 0.0;
    final contentY = localPosition.dy - headerHeight + scrollOffset;
    final rowIndex = (contentY / rowHeight).floor();

    if (rowIndex < 0 || rowIndex >= widget.data.length) return null;
    return rowIndex;
  }

  void _handleRowSelection(int rowIndex) {
    final sm = _stateManager;
    if (sm == null || rowIndex >= _plutoRows.length) return;

    final item = widget.data[rowIndex];
    final targetRow = _plutoRows[rowIndex];

    if (widget.allowMultiSelect) {
      if (sm.checkedRows.contains(targetRow)) {
        sm.setRowChecked(targetRow, false);
      } else {
        sm.setRowChecked(targetRow, true);
      }
      final selectedItems =
          sm.checkedRows
              .map((row) => _plutoRows.indexOf(row))
              .where((i) => i >= 0 && i < widget.data.length)
              .map((i) => widget.data[i])
              .toList();
      _onSelectionChanged(selectedItems);
    } else {
      for (final row in sm.checkedRows.toList()) {
        sm.setRowChecked(row, false);
      }
      sm.setCurrentSelectingPosition(
        cellPosition: PlutoGridCellPosition(columnIdx: 0, rowIdx: rowIndex),
      );
      _onSelectionChanged([item]);
    }

    sm.notifyListeners();
  }

  void _handleLoaded(PlutoGridOnLoadedEvent event) {
    _stateManager = event.stateManager;
    _stateManager!.setConfiguration(
      _stateManager!.configuration.copyWith(
        columnFilter: PlutoGridColumnFilterConfig(filters: const []),
      ),
    );
    _stateManager!.setSelectingMode(PlutoGridSelectingMode.row);
  }

  PlutoGridConfiguration _buildConfiguration(
    FondeColorScheme cs,
    double zoomScale,
    BuildContext context,
  ) {
    final headerStyle = FondeTextStyleBuilder.buildTextStyleWithColor(
      variant: FondeTextVariant.uiCaption,
      context: context,
      color: cs.base.foreground,
      fontWeight: FontWeight.w500,
    );
    final cellStyle = FondeTextStyleBuilder.buildTextStyleWithColor(
      variant: FondeTextVariant.uiCaption,
      context: context,
      color: cs.base.foreground,
      fontWeight: FontWeight.w400,
    );

    return PlutoGridConfiguration(
      columnSize: PlutoGridColumnSizeConfig(
        autoSizeMode: PlutoAutoSizeMode.scale,
        resizeMode:
            widget.allowColumnResizing
                ? PlutoResizeMode.pushAndPull
                : PlutoResizeMode.none,
      ),
      enterKeyAction: PlutoGridEnterKeyAction.none,
      enableMoveDownAfterSelecting: false,
      enableMoveHorizontalInEditing: false,
      style: PlutoGridStyleConfig(
        enableColumnBorderVertical: false,
        enableColumnBorderHorizontal: true,
        enableCellBorderVertical: false,
        enableCellBorderHorizontal: true,
        enableRowColorAnimation: false,
        gridBackgroundColor: cs.base.background,
        rowColor: cs.base.background,
        oddRowColor: cs.base.background,
        evenRowColor: cs.interactive.list.itemBackground.hover,
        activatedColor: cs.interactive.list.selectedBackground,
        checkedColor: cs.interactive.list.selectedBackground,
        borderColor: cs.base.border,
        gridBorderColor: cs.base.border,
        activatedBorderColor: cs.interactive.input.focusBorder,
        inactivatedBorderColor: cs.base.border,
        columnTextStyle: headerStyle,
        cellTextStyle: cellStyle,
        columnHeight: 32.0,
        rowHeight: 28.0,
      ),
      scrollbar: PlutoGridScrollbarConfig(
        isAlwaysShown: true,
        scrollbarThickness: 8.0 * zoomScale,
        scrollbarThicknessWhileDragging: 10.0 * zoomScale,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.fondeColorScheme;
    final zoomScale = context.fondeZoomScale;

    return Container(
      decoration: BoxDecoration(
        color: cs.base.background,
        border: Border.all(
          color: cs.base.border,
          width: 1.0 * context.fondeBorderScale,
        ),
      ),
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: _handlePointerDown,
        child: PlutoGrid(
          columns: _plutoColumns,
          rows: _plutoRows,
          mode:
              widget.allowMultiSelect
                  ? PlutoGridMode.multiSelect
                  : PlutoGridMode.select,
          configuration: _buildConfiguration(cs, zoomScale, context),
          onLoaded: _handleLoaded,
        ),
      ),
    );
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

  const FondeTableColumn({
    required this.id,
    required this.title,
    required this.width,
    required this.cellBuilder,
    this.minWidth,
    this.maxWidth,
    this.sortable = false,
    this.resizable = true,
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
    );
  }
}
