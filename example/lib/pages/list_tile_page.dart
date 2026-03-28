import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../widgets/catalog_page.dart';

class ListTilePage extends StatelessWidget {
  const ListTilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'List Tile',
          description: 'List item',
          children: [
            CatalogDemo(
              label: 'Basic',
              child: SizedBox(
                width: 400,
                child: Column(
                  children: [
                    FondeListTile(
                      title: const FondeText(
                        'Title only',
                        variant: FondeTextVariant.bodyText,
                      ),
                      isSelected: false,
                      onTap: () {},
                    ),
                    FondeListTile(
                      title: const FondeText(
                        'With subtitle',
                        variant: FondeTextVariant.bodyText,
                      ),
                      isSelected: false,
                      subtitle: const FondeText(
                        'Subtitle text',
                        variant: FondeTextVariant.captionText,
                      ),
                      onTap: () {},
                    ),
                    FondeListTile(
                      title: const FondeText(
                        'With leading',
                        variant: FondeTextVariant.bodyText,
                      ),
                      isSelected: false,
                      leading: const Icon(LucideIcons.folder, size: 16),
                      onTap: () {},
                    ),
                    FondeListTile(
                      title: const FondeText(
                        'Selected',
                        variant: FondeTextVariant.bodyText,
                      ),
                      isSelected: true,
                      leading: const Icon(LucideIcons.check, size: 16),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            const CatalogDemo(
              label: 'Tap / Double tap',
              child: SizedBox(width: 400, child: _TapDemo()),
            ),
          ],
        ),
      ],
    );
  }
}

class _TapDemo extends StatefulWidget {
  const _TapDemo();

  @override
  State<_TapDemo> createState() => _TapDemoState();
}

class _TapDemoState extends State<_TapDemo> {
  String _log = 'Tap or double-tap an item';

  void _updateLog(String message) {
    setState(() => _log = message);
  }

  void _clearLog() {
    setState(() => _log = '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FondeListTile(
          title: const FondeText('Item A', variant: FondeTextVariant.bodyText),
          isSelected: false,
          onTapDown: (_) => _clearLog(),
          onTap: () => _updateLog('Item A: single tap'),
          onDoubleTap: () => _updateLog('Item A: double tap'),
        ),
        FondeListTile(
          title: const FondeText('Item B', variant: FondeTextVariant.bodyText),
          isSelected: false,
          onTapDown: (_) => _clearLog(),
          onTap: () => _updateLog('Item B: single tap'),
          onDoubleTap: () => _updateLog('Item B: double tap'),
        ),
        const SizedBox(height: 8),
        FondeText(_log, variant: FondeTextVariant.captionText),
      ],
    );
  }
}
