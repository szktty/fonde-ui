import 'package:flutter/material.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class StatusBarPage extends StatelessWidget {
  const StatusBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Status Bar',
          description:
              'Fixed bar at the bottom of FondeScaffold. '
              'Use the statusBar parameter to attach it.',
          children: [
            CatalogDemo(
              label: 'Leading only',
              child: FondeStatusBar(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const FondeStatusBarItem(label: 'main'),
                    const FondeStatusBarDivider(),
                    const FondeStatusBarItem(label: 'Dart'),
                  ],
                ),
              ),
            ),
            CatalogDemo(
              label: 'Leading + trailing',
              child: FondeStatusBar(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const FondeStatusBarItem(
                      icon: LucideIcons.gitBranch,
                      label: 'main',
                    ),
                    const FondeStatusBarDivider(),
                    FondeStatusBarItem(
                      icon: LucideIcons.circleAlert,
                      label: '0 errors',
                      onTap: () {},
                    ),
                  ],
                ),
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FondeStatusBarItem(label: 'Ln 42, Col 8'),
                    FondeStatusBarDivider(),
                    FondeStatusBarItem(label: 'UTF-8'),
                  ],
                ),
              ),
            ),
            CatalogDemo(
              label: 'With center',
              child: FondeStatusBar(
                leading: const FondeStatusBarItem(label: 'Ready'),
                center: const FondeStatusBarItem(label: 'fonde-ui v0.2.0'),
                trailing: const FondeStatusBarItem(label: 'macOS'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
