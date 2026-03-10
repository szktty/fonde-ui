import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:fonde_ui/fonde_ui_riverpod.dart';

import '../widgets/catalog_page.dart';

class GestureDetectorPage extends StatelessWidget {
  const GestureDetectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Gesture Detector',
          description:
              'Gesture detector that detects single/double taps without delay',
          children: [
            CatalogDemo(
              label: 'Basic',
              child: _TapDemoBox(label: 'Try tapping', onTap: () {}),
            ),
            CatalogDemo(
              label: 'Double tap',
              child: _TapDemoBox(
                label: 'Try double tapping',
                onDoubleTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TapDemoBox extends ConsumerWidget {
  const _TapDemoBox({required this.label, this.onTap, this.onDoubleTap});

  final String label;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    return FondeGestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.base.divider),
          borderRadius: FondeBorderRadiusValues.mediumRadius,
        ),
        child: FondePadding.symmetric(
          horizontal: FondeSpacingValues.lg,
          vertical: FondeSpacingValues.sm,
          child: FondeText(label, variant: FondeTextVariant.bodyText),
        ),
      ),
    );
  }
}
