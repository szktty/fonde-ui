import 'package:flutter/widgets.dart';

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

  /// When true, this column cannot be dragged or receive drops from other
  /// columns. Fixed columns always stay in their current position.
  final bool fixed;

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
    this.fixed = false,
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
    bool? fixed,
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
      fixed: fixed ?? this.fixed,
      sortKeyBuilder: sortKeyBuilder ?? this.sortKeyBuilder,
    );
  }
}
