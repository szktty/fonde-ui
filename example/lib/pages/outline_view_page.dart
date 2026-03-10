import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../widgets/catalog_page.dart';

class OutlineViewPage extends StatefulWidget {
  const OutlineViewPage({super.key});

  @override
  State<OutlineViewPage> createState() => _OutlineViewPageState();
}

class _OutlineViewPageState extends State<OutlineViewPage> {
  String? _outlineSelected;
  Set<String> _outlineExpanded = {'root'};

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Outline View',
          description: 'Nested tree view',
          children: [
            CatalogDemo(
              label: 'Basic tree',
              child: SizedBox(
                height: 300,
                child: FondeOutlineView<_OutlineNode>(
                  items: _rootNodes,
                  selectedItem:
                      _outlineSelected != null
                          ? _findNode(_outlineSelected!)
                          : null,
                  expandedItems: Set.of(
                    _allNodes.where((n) => _outlineExpanded.contains(n.id)),
                  ),
                  onItemTap:
                      (node) => setState(() => _outlineSelected = node.id),
                  onExpansionChanged:
                      (node) => setState(() {
                        if (_outlineExpanded.contains(node.id)) {
                          _outlineExpanded =
                              _outlineExpanded
                                  .where((id) => id != node.id)
                                  .toSet();
                        } else {
                          _outlineExpanded = {..._outlineExpanded, node.id};
                        }
                      }),
                  itemBuilder:
                      (node, isSelected, isExpanded, hasChildren, depth) =>
                          FondeOutlineItem(
                            title: Text(node.label),
                            isSelected: isSelected,
                            isExpanded: isExpanded,
                            hasChildren: hasChildren,
                            depth: depth,
                            leading: Icon(
                              hasChildren
                                  ? LucideIcons.folder
                                  : LucideIcons.file,
                              size: 16,
                            ),
                          ),
                  childrenBuilder: (node) => node.children,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _OutlineNode? _findNode(String id) {
    for (final node in _allNodes) {
      if (node.id == id) return node;
    }
    return null;
  }
}

class _OutlineNode {
  const _OutlineNode(this.id, this.label, [this.children = const []]);
  final String id;
  final String label;
  final List<_OutlineNode> children;
}

const _rootNodes = [
  _OutlineNode('root', 'my_project', [
    _OutlineNode('lib', 'lib', [
      _OutlineNode('main', 'main.dart'),
      _OutlineNode('app', 'app.dart'),
      _OutlineNode('pages', 'pages', [
        _OutlineNode('home', 'home_page.dart'),
        _OutlineNode('settings', 'settings_page.dart'),
      ]),
    ]),
    _OutlineNode('test', 'test', [
      _OutlineNode('widget_test', 'widget_test.dart'),
    ]),
    _OutlineNode('pubspec', 'pubspec.yaml'),
  ]),
];

List<_OutlineNode> get _allNodes {
  final result = <_OutlineNode>[];
  void collect(_OutlineNode node) {
    result.add(node);
    for (final child in node.children) {
      collect(child);
    }
  }

  for (final node in _rootNodes) {
    collect(node);
  }
  return result;
}
