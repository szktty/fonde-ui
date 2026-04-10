import 'package:flutter/material.dart';
import '../icons/lucide_icons.dart';
import 'fonde_table_view.dart';

// Sort direction for internal header cell rendering.
enum TableViewSortDirection { none, ascending, descending }

class HeaderCell<T> extends StatelessWidget {
  final FondeTableColumn<T> col;
  final TextStyle textStyle;
  final TableViewSortDirection sortDirection;
  final VoidCallback? onTap;

  const HeaderCell({
    super.key,
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
          if (sortDirection == TableViewSortDirection.ascending)
            Icon(LucideIcons.chevronUp, size: 12, color: textStyle.color),
          if (sortDirection == TableViewSortDirection.descending)
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
