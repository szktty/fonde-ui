import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:fonde_ui/fonde_ui_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../widgets/catalog_page.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CatalogPage(
      children: [
        CatalogSection(
          title: 'Navigation',
          description:
              'Sample of a full navigation layout combining Launch Bar, Sidebar List, and Scaffold.',
          children: [
            CatalogDemo(
              label: 'Basic layout',
              description: 'Launch Bar + Sidebar List + content area',
              child: SizedBox(height: 320, child: _BasicNavigationDemo()),
            ),
            CatalogDemo(
              label: 'Hidden sidebar',
              description: 'showPrimarySidebar: false',
              child: SizedBox(height: 200, child: _NoSidebarDemo()),
            ),
          ],
        ),
      ],
    );
  }
}

class _BasicNavigationDemo extends ConsumerStatefulWidget {
  const _BasicNavigationDemo();

  @override
  ConsumerState<_BasicNavigationDemo> createState() =>
      _BasicNavigationDemoState();
}

class _BasicNavigationDemoState extends ConsumerState<_BasicNavigationDemo> {
  int _launchBarIndex = 0;
  String? _selectedItemId = 'inbox';
  List<String> _expandedGroupIds = ['mail'];

  @override
  Widget build(BuildContext context) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    return ClipRect(
      child: FondeScaffold(
        disableZoom: true,
        toolbar: FondeMainToolbar(
          center: FondeText(
            _selectedLabel,
            variant: FondeTextVariant.sectionTitleSecondary,
          ),
        ),
        launchBar: FondeLaunchBar(
          disableZoom: true,
          selectedIndex: _launchBarIndex,
          topItems: [
            FondeLaunchBarItem(
              icon: LucideIcons.mail,
              label: 'Mail',
              logicalIndex: 0,
              onTap: () => setState(() => _launchBarIndex = 0),
            ),
            FondeLaunchBarItem(
              icon: LucideIcons.calendar,
              label: 'Calendar',
              logicalIndex: 1,
              onTap: () => setState(() => _launchBarIndex = 1),
            ),
            FondeLaunchBarItem(
              icon: LucideIcons.contact,
              label: 'Contacts',
              logicalIndex: 2,
              onTap: () => setState(() => _launchBarIndex = 2),
            ),
          ],
          bottomItems: [
            FondeLaunchBarItem(
              icon: LucideIcons.settings,
              label: 'Settings',
              logicalIndex: 10,
              onTap: () => setState(() => _launchBarIndex = 10),
            ),
          ],
        ),
        primarySidebar: FondeSidebarList(
          shrinkWrap: false,
          selectedItemId: _selectedItemId,
          expandedGroupIds: _expandedGroupIds,
          onItemSelected: (id) => setState(() => _selectedItemId = id),
          onGroupToggled:
              (id) => setState(() {
                if (_expandedGroupIds.contains(id)) {
                  _expandedGroupIds = List.of(_expandedGroupIds)..remove(id);
                } else {
                  _expandedGroupIds = List.of(_expandedGroupIds)..add(id);
                }
              }),
          children: [
            FondeSidebarListGroup(
              id: 'mail',
              title: 'Mail',
              icon: const Icon(LucideIcons.mail, size: 16),
              isExpanded: _expandedGroupIds.contains('mail'),
              children: [
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
              ],
            ),
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
        ),
        content: Center(
          child: FondeText(
            _selectedLabel,
            variant: FondeTextVariant.bodyText,
            color: colorScheme.base.foreground.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }

  String get _selectedLabel {
    const labels = {
      'inbox': 'Inbox',
      'drafts': 'Drafts',
      'sent': 'Sent',
      'archive': 'Archive',
      'trash': 'Trash',
    };
    return labels[_selectedItemId] ?? 'Navigation Demo';
  }
}

class _NoSidebarDemo extends ConsumerStatefulWidget {
  const _NoSidebarDemo();

  @override
  ConsumerState<_NoSidebarDemo> createState() => _NoSidebarDemoState();
}

class _NoSidebarDemoState extends ConsumerState<_NoSidebarDemo> {
  int _launchBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    return ClipRect(
      child: FondeScaffold(
        disableZoom: true,
        showPrimarySidebar: false,
        toolbar: const FondeMainToolbar(
          center: FondeText(
            'No Sidebar',
            variant: FondeTextVariant.sectionTitleSecondary,
          ),
        ),
        launchBar: FondeLaunchBar(
          disableZoom: true,
          selectedIndex: _launchBarIndex,
          topItems: [
            FondeLaunchBarItem(
              icon: LucideIcons.layoutGrid,
              label: 'Components',
              logicalIndex: 0,
              onTap: () => setState(() => _launchBarIndex = 0),
            ),
            FondeLaunchBarItem(
              icon: LucideIcons.search,
              label: 'Search',
              logicalIndex: 1,
              onTap: () => setState(() => _launchBarIndex = 1),
            ),
          ],
          bottomItems: const [],
        ),
        content: Center(
          child: FondeText(
            'Content Area',
            variant: FondeTextVariant.bodyText,
            color: colorScheme.base.foreground.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}
