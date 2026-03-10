import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../widgets/catalog_page.dart';

class LaunchBarPage extends StatelessWidget {
  const LaunchBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CatalogPage(
      children: [
        CatalogSection(
          title: 'Launch Bar',
          description:
              'Launcher for the main app features. Placed vertically on the left edge of the screen.',
          children: [
            CatalogDemo(
              label: 'Basic',
              child: SizedBox(width: 48, height: 200, child: _BasicDemo()),
            ),
            CatalogDemo(
              label: 'With badge',
              child: SizedBox(width: 48, height: 200, child: _BadgeDemo()),
            ),
            CatalogDemo(
              label: 'With bottom items',
              child: SizedBox(
                width: 48,
                height: 220,
                child: _BottomItemsDemo(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BasicDemo extends ConsumerStatefulWidget {
  const _BasicDemo();

  @override
  ConsumerState<_BasicDemo> createState() => _BasicDemoState();
}

class _BasicDemoState extends ConsumerState<_BasicDemo> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return FondeLaunchBar(
      selectedIndex: _selected,
      topItems: [
        FondeLaunchBarItem(
          icon: LucideIcons.layoutGrid,
          label: 'Components',
          logicalIndex: 0,
          onTap: () => setState(() => _selected = 0),
        ),
        FondeLaunchBarItem(
          icon: LucideIcons.search,
          label: 'Search',
          logicalIndex: 1,
          onTap: () => setState(() => _selected = 1),
        ),
        FondeLaunchBarItem(
          icon: LucideIcons.gitBranch,
          label: 'Source Control',
          logicalIndex: 2,
          onTap: () => setState(() => _selected = 2),
        ),
      ],
      bottomItems: const [],
    );
  }
}

class _BadgeDemo extends ConsumerStatefulWidget {
  const _BadgeDemo();

  @override
  ConsumerState<_BadgeDemo> createState() => _BadgeDemoState();
}

class _BadgeDemoState extends ConsumerState<_BadgeDemo> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return FondeLaunchBar(
      selectedIndex: _selected,
      topItems: [
        FondeLaunchBarItem(
          icon: LucideIcons.layoutGrid,
          label: 'Components',
          logicalIndex: 0,
          onTap: () => setState(() => _selected = 0),
        ),
        FondeLaunchBarItem(
          icon: LucideIcons.bell,
          label: 'Notifications',
          logicalIndex: 1,
          badge: '3',
          onTap: () => setState(() => _selected = 1),
        ),
        FondeLaunchBarItem(
          icon: LucideIcons.messageSquare,
          label: 'Messages',
          logicalIndex: 2,
          badge: '12',
          onTap: () => setState(() => _selected = 2),
        ),
      ],
      bottomItems: const [],
    );
  }
}

class _BottomItemsDemo extends ConsumerStatefulWidget {
  const _BottomItemsDemo();

  @override
  ConsumerState<_BottomItemsDemo> createState() => _BottomItemsDemoState();
}

class _BottomItemsDemoState extends ConsumerState<_BottomItemsDemo> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return FondeLaunchBar(
      selectedIndex: _selected,
      topItems: [
        FondeLaunchBarItem(
          icon: LucideIcons.layoutGrid,
          label: 'Components',
          logicalIndex: 0,
          onTap: () => setState(() => _selected = 0),
        ),
        FondeLaunchBarItem(
          icon: LucideIcons.search,
          label: 'Search',
          logicalIndex: 1,
          onTap: () => setState(() => _selected = 1),
        ),
      ],
      bottomItems: [
        FondeLaunchBarItem(
          icon: LucideIcons.settings,
          label: 'Settings',
          logicalIndex: 10,
          onTap: () => setState(() => _selected = 10),
        ),
        FondeLaunchBarItem(
          icon: LucideIcons.circleUserRound,
          label: 'Account',
          logicalIndex: 11,
          onTap: () => setState(() => _selected = 11),
        ),
      ],
    );
  }
}
