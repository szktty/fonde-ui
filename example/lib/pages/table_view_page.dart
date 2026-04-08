import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class TableViewPage extends StatefulWidget {
  const TableViewPage({super.key});

  @override
  State<TableViewPage> createState() => _TableViewPageState();
}

class _TableViewPageState extends State<TableViewPage> {
  List<_Person> _selectedSingle = [];
  List<_Person> _selectedMulti = [];

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'FondeTableView',
          description: 'Desktop-oriented table view based on pluto_grid',
          children: [
            CatalogDemo(
              label: 'Single selection',
              description: 'Default. Click a row to select.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 240,
                    child: FondeTableView<_Person>(
                      data: _people,
                      columns: _buildColumns(),
                      keyExtractor: (p) => p.id,

                      onRowsSelected:
                          (rows) => setState(() => _selectedSingle = rows),
                    ),
                  ),
                  if (_selectedSingle.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    FondeText(
                      'Selected: ${_selectedSingle.map((p) => p.name).join(', ')}',
                      variant: FondeTextVariant.captionText,
                    ),
                  ],
                ],
              ),
            ),
            CatalogDemo(
              label: 'Multi selection',
              description: 'allowMultiSelect: true',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 240,
                    child: FondeTableView<_Person>(
                      data: _people,
                      columns: _buildColumns(),
                      keyExtractor: (p) => p.id,
                      allowMultiSelect: true,

                      onRowsSelected:
                          (rows) => setState(() => _selectedMulti = rows),
                    ),
                  ),
                  if (_selectedMulti.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    FondeText(
                      'Selected (${_selectedMulti.length}): ${_selectedMulti.map((p) => p.name).join(', ')}',
                      variant: FondeTextVariant.captionText,
                    ),
                  ],
                ],
              ),
            ),
            CatalogDemo(
              label: 'Sortable columns',
              description:
                  'Click a header to sort. Active sort column is highlighted.',
              child: SizedBox(
                height: 240,
                child: FondeTableView<_Person>(
                  data: _people,
                  columns: _buildSortableColumns(),
                  keyExtractor: (p) => p.id,

                  initialSortColumnId: 'name',
                ),
              ),
            ),
            CatalogDemo(
              label: 'No resize / No reorder',
              description:
                  'allowColumnResizing: false, allowColumnReordering: false',
              child: SizedBox(
                height: 240,
                child: FondeTableView<_Person>(
                  data: _people,
                  columns: _buildColumns(),
                  keyExtractor: (p) => p.id,
                  allowColumnResizing: false,
                  allowColumnReordering: false,
                ),
              ),
            ),
            CatalogDemo(
              label: 'Large data (virtualized)',
              description:
                  'Smooth scrolling with virtualization even for 100 rows',
              child: SizedBox(
                height: 300,
                child: FondeTableView<_Person>(
                  data: _generatePeople(100),
                  columns: _buildColumns(),
                  keyExtractor: (p) => p.id,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<FondeTableColumn<_Person>> _buildColumns() {
    return [
      FondeTableColumn(
        id: 'name',
        title: 'Name',
        width: 160,
        fixed: true,
        cellBuilder:
            (p, isSelected) => _Cell(text: p.name, isSelected: isSelected),
      ),
      FondeTableColumn(
        id: 'role',
        title: 'Role',
        width: 140,
        cellBuilder:
            (p, isSelected) => _Cell(text: p.role, isSelected: isSelected),
      ),
      FondeTableColumn(
        id: 'department',
        title: 'Department',
        width: 160,
        cellBuilder:
            (p, isSelected) =>
                _Cell(text: p.department, isSelected: isSelected),
      ),
      FondeTableColumn(
        id: 'status',
        title: 'Status',
        width: 100,
        cellBuilder:
            (p, isSelected) =>
                _StatusCell(status: p.status, isSelected: isSelected),
      ),
    ];
  }

  List<FondeTableColumn<_Person>> _buildSortableColumns() {
    return [
      FondeTableColumn(
        id: 'name',
        title: 'Name',
        width: 160,
        sortable: true,
        sortKeyBuilder: (p) => p.name,
        cellBuilder:
            (p, isSelected) => _Cell(text: p.name, isSelected: isSelected),
      ),
      FondeTableColumn(
        id: 'role',
        title: 'Role',
        width: 140,
        sortable: true,
        sortKeyBuilder: (p) => p.role,
        cellBuilder:
            (p, isSelected) => _Cell(text: p.role, isSelected: isSelected),
      ),
      FondeTableColumn(
        id: 'department',
        title: 'Department',
        width: 160,
        sortable: true,
        sortKeyBuilder: (p) => p.department,
        cellBuilder:
            (p, isSelected) =>
                _Cell(text: p.department, isSelected: isSelected),
      ),
      FondeTableColumn(
        id: 'status',
        title: 'Status',
        width: 100,
        sortable: true,
        sortKeyBuilder: (p) => p.status,
        cellBuilder:
            (p, isSelected) =>
                _StatusCell(status: p.status, isSelected: isSelected),
      ),
    ];
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.text, required this.isSelected});
  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FondeText(text, variant: FondeTextVariant.uiCaption),
    );
  }
}

class _StatusCell extends StatelessWidget {
  const _StatusCell({required this.status, required this.isSelected});
  final String status;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FondeText(status, variant: FondeTextVariant.uiCaption),
    );
  }
}

class _Person {
  const _Person({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
    required this.status,
  });
  final String id;
  final String name;
  final String role;
  final String department;
  final String status;
}

const _people = [
  _Person(
    id: '1',
    name: 'Alice Johnson',
    role: 'Engineer',
    department: 'Platform',
    status: 'Active',
  ),
  _Person(
    id: '2',
    name: 'Bob Smith',
    role: 'Designer',
    department: 'Product',
    status: 'Active',
  ),
  _Person(
    id: '3',
    name: 'Carol White',
    role: 'Manager',
    department: 'Platform',
    status: 'Away',
  ),
  _Person(
    id: '4',
    name: 'David Lee',
    role: 'Engineer',
    department: 'Data',
    status: 'Active',
  ),
  _Person(
    id: '5',
    name: 'Eve Davis',
    role: 'Analyst',
    department: 'Data',
    status: 'Inactive',
  ),
  _Person(
    id: '6',
    name: 'Frank Miller',
    role: 'Engineer',
    department: 'Platform',
    status: 'Active',
  ),
  _Person(
    id: '7',
    name: 'Grace Wilson',
    role: 'Designer',
    department: 'Product',
    status: 'Active',
  ),
  _Person(
    id: '8',
    name: 'Henry Brown',
    role: 'Manager',
    department: 'Data',
    status: 'Away',
  ),
];

List<_Person> _generatePeople(int count) {
  const roles = ['Engineer', 'Designer', 'Manager', 'Analyst'];
  const departments = ['Platform', 'Product', 'Data', 'Infrastructure'];
  const statuses = ['Active', 'Away', 'Inactive'];
  return List.generate(
    count,
    (i) => _Person(
      id: '${i + 1}',
      name: 'Person ${i + 1}',
      role: roles[i % roles.length],
      department: departments[i % departments.length],
      status: statuses[i % statuses.length],
    ),
  );
}
