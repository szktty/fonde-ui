import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class DialogPage extends StatelessWidget {
  const DialogPage({super.key});

  void _showDialog(BuildContext context, FondeDialogImportance importance) {
    showFondeDialog(
      context: context,
      title: switch (importance) {
        FondeDialogImportance.critical => 'Confirm deletion',
        FondeDialogImportance.standard => 'Settings',
        FondeDialogImportance.utility => 'Filter',
      },
      importance: importance,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(switch (importance) {
          FondeDialogImportance.critical =>
            'Are you sure you want to delete this item? This action cannot be undone.',
          FondeDialogImportance.standard => 'Change your settings.',
          FondeDialogImportance.utility => 'Set filter conditions.',
        }),
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FondeButton.cancel(
            label: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          if (importance == FondeDialogImportance.critical)
            FondeButton.destructive(
              label: 'Delete',
              onPressed: () => Navigator.of(context).pop(),
            )
          else
            FondeButton.primary(
              label: 'OK',
              onPressed: () => Navigator.of(context).pop(),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Dialog',
          description: 'Dialog variants (importance)',
          children: [
            CatalogDemo(
              label: 'critical',
              description: 'Errors and destructive actions',
              child: FondeButton.destructive(
                label: 'Open Critical Dialog',
                onPressed:
                    () => _showDialog(context, FondeDialogImportance.critical),
              ),
            ),
            CatalogDemo(
              label: 'standard',
              description: 'Settings and forms',
              child: FondeButton.normal(
                label: 'Open Standard Dialog',
                onPressed:
                    () => _showDialog(context, FondeDialogImportance.standard),
              ),
            ),
            CatalogDemo(
              label: 'utility',
              description: 'Filters and auxiliary actions',
              child: FondeButton.normal(
                label: 'Open Utility Dialog',
                onPressed:
                    () => _showDialog(context, FondeDialogImportance.utility),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
