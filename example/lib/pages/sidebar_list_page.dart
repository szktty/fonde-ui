import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../widgets/catalog_page.dart';

class SidebarListPage extends StatelessWidget {
  const SidebarListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CatalogPage(
      children: [
        CatalogSection(
          title: 'Sidebar List',
          description: 'List widget for sidebar navigation',
          children: [
            CatalogDemo(
              label: 'Basic (items only)',
              child: SizedBox(width: 220, child: _BasicDemo()),
            ),
            CatalogDemo(
              label: 'With groups',
              child: SizedBox(width: 220, child: _GroupDemo()),
            ),
            CatalogDemo(
              label: 'With icons',
              child: SizedBox(width: 220, child: _IconDemo()),
            ),
            CatalogDemo(
              label: 'Subtle style',
              child: SizedBox(width: 220, child: _SubtleDemo()),
            ),
            CatalogDemo(
              label: 'Inset style (macOS)',
              child: SizedBox(width: 220, child: _InsetDemo()),
            ),
            CatalogDemo(
              label: 'With header',
              child: SizedBox(width: 220, child: _HeaderDemo()),
            ),
          ],
        ),
      ],
    );
  }
}

// Basic demo
class _BasicDemo extends StatefulWidget {
  const _BasicDemo();

  @override
  State<_BasicDemo> createState() => _BasicDemoState();
}

class _BasicDemoState extends State<_BasicDemo> {
  String? _selected = 'inbox';
  final List<String> _expanded = [];

  @override
  Widget build(BuildContext context) {
    return FondeSidebarList(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      selectedItemId: _selected,
      expandedGroupIds: _expanded,
      onItemSelected: (id) => setState(() => _selected = id),
      onGroupToggled: (_) {},
      children: [
        FondeSidebarListItem(id: 'inbox', title: 'Inbox'),
        FondeSidebarListItem(id: 'drafts', title: 'Drafts'),
        FondeSidebarListItem(id: 'sent', title: 'Sent'),
        FondeSidebarListItem(id: 'archive', title: 'Archive'),
        FondeSidebarListItem(id: 'trash', title: 'Trash'),
      ],
    );
  }
}

// Group demo
class _GroupDemo extends StatefulWidget {
  const _GroupDemo();

  @override
  State<_GroupDemo> createState() => _GroupDemoState();
}

class _GroupDemoState extends State<_GroupDemo> {
  String? _selected = 'home_page';
  List<String> _expanded = ['pages'];

  @override
  Widget build(BuildContext context) {
    return FondeSidebarList(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      selectedItemId: _selected,
      expandedGroupIds: _expanded,
      onItemSelected: (id) => setState(() => _selected = id),
      onGroupToggled:
          (id) => setState(() {
            if (_expanded.contains(id)) {
              _expanded = List.of(_expanded)..remove(id);
            } else {
              _expanded = List.of(_expanded)..add(id);
            }
          }),
      children: [
        FondeSidebarListItem(id: 'pubspec', title: 'pubspec.yaml'),
        FondeSidebarListGroup(
          id: 'lib',
          title: 'lib',
          isExpanded: _expanded.contains('lib'),
          children: [FondeSidebarListItem(id: 'main', title: 'main.dart')],
        ),
        FondeSidebarListGroup(
          id: 'pages',
          title: 'pages',
          isExpanded: _expanded.contains('pages'),
          children: [
            FondeSidebarListItem(id: 'home_page', title: 'home_page.dart'),
            FondeSidebarListItem(
              id: 'settings_page',
              title: 'settings_page.dart',
            ),
          ],
        ),
      ],
    );
  }
}

// Icon demo
class _IconDemo extends StatefulWidget {
  const _IconDemo();

  @override
  State<_IconDemo> createState() => _IconDemoState();
}

class _IconDemoState extends State<_IconDemo> {
  String? _selected = 'home';
  List<String> _expanded = ['workspace'];

  @override
  Widget build(BuildContext context) {
    return FondeSidebarList(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      selectedItemId: _selected,
      expandedGroupIds: _expanded,
      onItemSelected: (id) => setState(() => _selected = id),
      onGroupToggled:
          (id) => setState(() {
            if (_expanded.contains(id)) {
              _expanded = List.of(_expanded)..remove(id);
            } else {
              _expanded = List.of(_expanded)..add(id);
            }
          }),
      children: [
        FondeSidebarListItem(
          id: 'home',
          title: 'Home',
          leading: const Icon(LucideIcons.house, size: 16),
        ),
        FondeSidebarListItem(
          id: 'search',
          title: 'Search',
          leading: const Icon(LucideIcons.search, size: 16),
        ),
        FondeSidebarListItem(
          id: 'notifications',
          title: 'Notifications',
          leading: const Icon(LucideIcons.bell, size: 16),
        ),
        FondeSidebarListGroup(
          id: 'workspace',
          title: 'Workspace',
          icon: const Icon(LucideIcons.folder, size: 16),
          isExpanded: _expanded.contains('workspace'),
          children: [
            FondeSidebarListItem(
              id: 'docs',
              title: 'Documents',
              leading: const Icon(LucideIcons.fileText, size: 16),
            ),
            FondeSidebarListItem(
              id: 'images',
              title: 'Images',
              leading: const Icon(LucideIcons.image, size: 16),
            ),
          ],
        ),
        FondeSidebarListItem(
          id: 'settings',
          title: 'Settings',
          leading: const Icon(LucideIcons.settings, size: 16),
        ),
      ],
    );
  }
}

// Subtle style demo
class _SubtleDemo extends StatefulWidget {
  const _SubtleDemo();

  @override
  State<_SubtleDemo> createState() => _SubtleDemoState();
}

class _SubtleDemoState extends State<_SubtleDemo> {
  String? _selected = 'all';
  final List<String> _expanded = [];

  @override
  Widget build(BuildContext context) {
    return FondeSidebarList(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      selectedItemId: _selected,
      expandedGroupIds: _expanded,
      onItemSelected: (id) => setState(() => _selected = id),
      onGroupToggled: (_) {},
      style: FondeSidebarListItemStyle.subtle,
      children: [
        FondeSidebarListItem(
          id: 'all',
          title: 'All Items',
          leading: const Icon(LucideIcons.layoutList, size: 16),
        ),
        FondeSidebarListItem(
          id: 'starred',
          title: 'Starred',
          leading: const Icon(LucideIcons.star, size: 16),
        ),
        FondeSidebarListItem(
          id: 'recent',
          title: 'Recent',
          leading: const Icon(LucideIcons.clock, size: 16),
        ),
        FondeSidebarListItem(
          id: 'shared',
          title: 'Shared with me',
          leading: const Icon(LucideIcons.users, size: 16),
        ),
      ],
    );
  }
}

// Inset style demo
class _InsetDemo extends StatefulWidget {
  const _InsetDemo();

  @override
  State<_InsetDemo> createState() => _InsetDemoState();
}

class _InsetDemoState extends State<_InsetDemo> {
  String? _selected = 'home';
  List<String> _expanded = ['workspace'];

  @override
  Widget build(BuildContext context) {
    return FondeSidebarList(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      selectedItemId: _selected,
      expandedGroupIds: _expanded,
      onItemSelected: (id) => setState(() => _selected = id),
      onGroupToggled:
          (id) => setState(() {
            if (_expanded.contains(id)) {
              _expanded = List.of(_expanded)..remove(id);
            } else {
              _expanded = List.of(_expanded)..add(id);
            }
          }),
      style: FondeSidebarListItemStyle.inset,
      children: [
        FondeSidebarListItem(
          id: 'home',
          title: 'Home',
          leading: const Icon(LucideIcons.house, size: 16),
        ),
        FondeSidebarListItem(
          id: 'search',
          title: 'Search',
          leading: const Icon(LucideIcons.search, size: 16),
        ),
        FondeSidebarListItem(
          id: 'notifications',
          title: 'Notifications',
          leading: const Icon(LucideIcons.bell, size: 16),
        ),
        FondeSidebarListGroup(
          id: 'workspace',
          title: 'Workspace',
          icon: const Icon(LucideIcons.folder, size: 16),
          isExpanded: _expanded.contains('workspace'),
          children: [
            FondeSidebarListItem(
              id: 'docs',
              title: 'Documents',
              leading: const Icon(LucideIcons.fileText, size: 16),
            ),
            FondeSidebarListItem(
              id: 'images',
              title: 'Images',
              leading: const Icon(LucideIcons.image, size: 16),
            ),
          ],
        ),
        FondeSidebarListItem(
          id: 'settings',
          title: 'Settings',
          leading: const Icon(LucideIcons.settings, size: 16),
        ),
      ],
    );
  }
}

// Header demo
class _HeaderDemo extends StatefulWidget {
  const _HeaderDemo();

  @override
  State<_HeaderDemo> createState() => _HeaderDemoState();
}

class _HeaderDemoState extends State<_HeaderDemo> {
  String? _selected = 'inbox';
  final List<String> _expanded = [];

  @override
  Widget build(BuildContext context) {
    return FondeSidebarList(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      selectedItemId: _selected,
      expandedGroupIds: _expanded,
      onItemSelected: (id) => setState(() => _selected = id),
      onGroupToggled: (_) {},
      children: [
        const FondeSidebarListHeader(id: 'header_mail', title: 'Mail'),
        FondeSidebarListItem(
          id: 'inbox',
          title: 'Inbox',
          leading: const Icon(LucideIcons.inbox, size: 16),
        ),
        FondeSidebarListItem(
          id: 'drafts',
          title: 'Drafts',
          leading: const Icon(LucideIcons.pencil, size: 16),
        ),
        FondeSidebarListItem(
          id: 'sent',
          title: 'Sent',
          leading: const Icon(LucideIcons.send, size: 16),
        ),
        const FondeSidebarListHeader(id: 'header_storage', title: 'Storage'),
        FondeSidebarListItem(
          id: 'archive',
          title: 'Archive',
          leading: const Icon(LucideIcons.archive, size: 16),
        ),
        FondeSidebarListItem(
          id: 'trash',
          title: 'Trash',
          leading: const Icon(LucideIcons.trash2, size: 16),
        ),
      ],
    );
  }
}
