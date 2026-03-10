import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:fonde_ui/fonde_ui_riverpod.dart';

/// Common container for catalog pages
class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(FondeSpacingValues.xxxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

/// Section divider
class CatalogSection extends ConsumerWidget {
  const CatalogSection({
    super.key,
    required this.title,
    required this.children,
    this.description,
  });

  final String title;
  final String? description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);

    return FondePadding(
      padding: const EdgeInsets.only(bottom: FondeSpacingValues.xxxl + 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FondeText(title, variant: FondeTextVariant.sectionTitlePrimary),
          if (description != null) ...[
            const FondeSpacing.xs(),
            FondeText(
              description!,
              variant: FondeTextVariant.captionText,
              color: colorScheme.base.foreground.withValues(alpha: 0.55),
            ),
          ],
          const FondeSpacing.lg(),
          Container(
            height: 1,
            width: double.infinity,
            color: colorScheme.base.divider,
          ),
          const FondeSpacing.lg(),
          ...children,
        ],
      ),
    );
  }
}

/// A single demo item (label + component)
class CatalogDemo extends ConsumerWidget {
  const CatalogDemo({
    super.key,
    required this.label,
    required this.child,
    this.description,
  });

  final String label;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);

    return FondePadding(
      padding: const EdgeInsets.only(bottom: FondeSpacingValues.xxl),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FondeText(label, variant: FondeTextVariant.itemTitle),
                if (description != null) ...[
                  const FondeSpacing.xs(),
                  FondeText(
                    description!,
                    variant: FondeTextVariant.smallText,
                    color: colorScheme.base.foreground.withValues(alpha: 0.55),
                  ),
                ],
              ],
            ),
          ),
          const FondeSpacing.xxl(),
          Expanded(child: child),
        ],
      ),
    );
  }
}
