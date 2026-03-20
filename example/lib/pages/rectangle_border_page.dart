import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class RectangleBorderPage extends StatelessWidget {
  const RectangleBorderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'FondeRectangleBorder',
          description:
              'Figma-style squircle border container. '
              'cornerSmoothing 0.6 gives a natural curve between circle and rectangle.',
          children: [
            CatalogDemo(
              label: 'Default',
              description: 'radius=12, smoothing=0.6',
              child: const FondeRectangleBorder(
                width: 200,
                height: 80,
                child: FondeText('Default', variant: FondeTextVariant.bodyText),
              ),
            ),
            CatalogDemo(
              label: 'With background',
              child: FondeRectangleBorder(
                width: 200,
                height: 80,
                side: BorderSide.none,
                color: const Color(0xFF3B82F6),
                child: const FondeText(
                  'Filled',
                  variant: FondeTextVariant.bodyText,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
            CatalogDemo(
              label: 'Small radius',
              description: 'radius=4',
              child: const FondeRectangleBorder(
                cornerRadius: 4,
                width: 200,
                height: 80,
                child: FondeText(
                  'radius=4',
                  variant: FondeTextVariant.bodyText,
                ),
              ),
            ),
            CatalogDemo(
              label: 'Large radius',
              description: 'radius=24',
              child: const FondeRectangleBorder(
                cornerRadius: 24,
                width: 200,
                height: 80,
                child: FondeText(
                  'radius=24',
                  variant: FondeTextVariant.bodyText,
                ),
              ),
            ),
            CatalogDemo(
              label: 'High smoothing',
              description: 'smoothing=1.0 (fully circular)',
              child: const FondeRectangleBorder(
                cornerRadius: 20,
                cornerSmoothing: 1.0,
                width: 200,
                height: 80,
                child: FondeText(
                  'smoothing=1.0',
                  variant: FondeTextVariant.bodyText,
                ),
              ),
            ),
            CatalogDemo(
              label: 'With padding',
              child: const FondeRectangleBorder(
                padding: EdgeInsets.all(FondeSpacingValues.lg),
                child: FondeText(
                  'Padded content inside squircle border',
                  variant: FondeTextVariant.bodyText,
                ),
              ),
            ),
          ],
        ),
        CatalogSection(
          title: 'FondeBorderRadius',
          description: 'Preset corner radius values for squircle borders.',
          children: [
            CatalogDemo(
              label: 'small()',
              description: 'radius=8, smoothing=0.6',
              child: _BorderRadiusDemo(
                borderRadius: const FondeBorderRadius.small(),
                label: 'FondeBorderRadius.small()',
              ),
            ),
            CatalogDemo(
              label: 'medium()',
              description: 'radius=12, smoothing=0.6',
              child: _BorderRadiusDemo(
                borderRadius: const FondeBorderRadius.medium(),
                label: 'FondeBorderRadius.medium()',
              ),
            ),
            CatalogDemo(
              label: 'large()',
              description: 'radius=16, smoothing=0.6',
              child: _BorderRadiusDemo(
                borderRadius: const FondeBorderRadius.large(),
                label: 'FondeBorderRadius.large()',
              ),
            ),
            CatalogDemo(
              label: 'circular()',
              description: 'smoothing=1.0',
              child: _BorderRadiusDemo(
                borderRadius: const FondeBorderRadius.circular(24),
                label: 'FondeBorderRadius.circular(24)',
              ),
            ),
          ],
        ),
        CatalogSection(
          title: 'FondeBorderSide',
          description: 'Preset border widths.',
          children: [
            CatalogDemo(
              label: 'thin()',
              description: 'width=1.0',
              child: _BorderSideDemo(
                side: const FondeBorderSide.thin(),
                label: 'FondeBorderSide.thin()',
              ),
            ),
            CatalogDemo(
              label: 'standard()',
              description: 'width=1.5',
              child: _BorderSideDemo(
                side: const FondeBorderSide.standard(),
                label: 'FondeBorderSide.standard()',
              ),
            ),
            CatalogDemo(
              label: 'thick()',
              description: 'width=2.0',
              child: _BorderSideDemo(
                side: const FondeBorderSide.thick(),
                label: 'FondeBorderSide.thick()',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BorderRadiusDemo extends StatelessWidget {
  const _BorderRadiusDemo({required this.borderRadius, required this.label});

  final FondeBorderRadius borderRadius;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FondeRectangleBorder(
      cornerRadius: borderRadius.cornerRadius,
      cornerSmoothing: borderRadius.cornerSmoothing,
      width: 240,
      height: 72,
      child: FondeText(label, variant: FondeTextVariant.captionText),
    );
  }
}

class _BorderSideDemo extends StatelessWidget {
  const _BorderSideDemo({required this.side, required this.label});

  final FondeBorderSide side;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FondeRectangleBorder(
      side: side,
      width: 240,
      height: 72,
      child: FondeText(label, variant: FondeTextVariant.captionText),
    );
  }
}
