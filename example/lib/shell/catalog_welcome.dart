import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:fonde_ui/fonde_ui_riverpod.dart';

import 'catalog_samples.dart';

const kCardSampleHeight = 140.0;

class CatalogWelcomePage extends ConsumerWidget {
  const CatalogWelcomePage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: FondeSpacingValues.xxxl,
        vertical: FondeSpacingValues.xxxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const FondeText('Fonde UI', variant: FondeTextVariant.pageTitle),
          const FondeSpacing.sm(),
          FondeText(
            'Desktop-first Flutter UI optimized for native-grade instant feedback, with accessibility built in.',
            variant: FondeTextVariant.bodyText,
            color: colorScheme.base.foreground.withValues(alpha: 0.55),
          ),
          const FondeSpacing(height: FondeSpacingValues.xxxl + 8),

          // Component grid (2 columns)
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 16.0;
              final cardWidth = (constraints.maxWidth - spacing) / 2;
              final cards = [
                CatalogCard(
                  width: cardWidth,
                  category: 'Buttons',
                  description: 'Button, Icon Button, Segmented, Split, Group',
                  sample: const ButtonsSample(),
                ),
                CatalogCard(
                  width: cardWidth,
                  category: 'Input',
                  description: 'Text Field, Search, Tags, Checkbox, Dropdown',
                  sample: const InputSample(),
                ),
                CatalogCard(
                  width: cardWidth,
                  category: 'Menus',
                  description: 'Context Menu, Overflow Menu, Popup Menu',
                  sample: const MenusSample(),
                ),
                CatalogCard(
                  width: cardWidth,
                  category: 'Navigation',
                  description: 'Launch Bar, Sidebar List, Groups',
                  sample: const NavigationSample(),
                ),
                CatalogCard(
                  width: cardWidth,
                  category: 'Layout',
                  description: 'Tab View, Panel, Scaffold, Sidebar',
                  sample: const LayoutSample(),
                ),
                CatalogCard(
                  width: cardWidth,
                  category: 'Data View',
                  description: 'Table View, Outline View, List Tile',
                  sample: const DataViewSample(),
                ),
                CatalogCard(
                  width: cardWidth,
                  category: 'Feedback',
                  description: 'Dialog, Toast, Popover, Progress Indicator',
                  sample: const FeedbackSample(),
                ),
                CatalogCard(
                  width: cardWidth,
                  category: 'Typography',
                  description: 'Text variants, font scale, color scope',
                  sample: const TypographySample(),
                ),
              ];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < cards.length; i += 2)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: i + 2 < cards.length ? spacing : 0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          cards[i],
                          const SizedBox(width: spacing),
                          if (i + 1 < cards.length) cards[i + 1],
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class CatalogCard extends ConsumerWidget {
  const CatalogCard({
    required this.width,
    required this.category,
    required this.description,
    required this.sample,
  });

  final double width;
  final String category;
  final String description;
  final Widget sample;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.base.border),
        borderRadius: FondeBorderRadiusValues.mediumRadius,
        color: colorScheme.base.background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sample area
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(FondeBorderRadiusValues.medium),
            ),
            child: SizedBox(
              width: width,
              height: kCardSampleHeight,
              child: ColoredBox(
                color: colorScheme.base.divider,
                child: ClipRect(
                  child: Padding(
                    padding: const EdgeInsets.all(FondeSpacingValues.md),
                    child: OverflowBox(
                      alignment: Alignment.topLeft,
                      minHeight: 0,
                      maxHeight: double.infinity,
                      minWidth: width - FondeSpacingValues.md * 2,
                      maxWidth: width - FondeSpacingValues.md * 2,
                      child: sample,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(height: 1, color: colorScheme.base.border),
          // Category name + description
          Padding(
            padding: const EdgeInsets.all(FondeSpacingValues.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FondeText(
                  category,
                  variant: FondeTextVariant.sectionTitleSecondary,
                  color: colorScheme.theme.primaryColor,
                ),
                const FondeSpacing.xs(),
                FondeText(
                  description,
                  variant: FondeTextVariant.smallText,
                  color: colorScheme.base.foreground.withValues(alpha: 0.55),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
