import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class TypographyPage extends StatelessWidget {
  const TypographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        const CatalogSection(
          title: 'UI Structure',
          description:
              'Text used in UI structures such as layouts, pages, and dialogs',
          children: [
            _TextRow(FondeTextVariant.pageTitle, 'pageTitle', 'Page title'),
            _TextRow(
              FondeTextVariant.sectionTitlePrimary,
              'sectionTitlePrimary',
              'Section heading for the main area',
            ),
            _TextRow(
              FondeTextVariant.sectionTitleSecondary,
              'sectionTitleSecondary',
              'Section heading for sidebar and panels',
            ),
            _TextRow(
              FondeTextVariant.sectionTitleUtility,
              'sectionTitleUtility',
              'Lightweight section heading for filters etc.',
            ),
            _TextRow(
              FondeTextVariant.itemTitle,
              'itemTitle',
              'List / grid item name',
            ),
            _TextRow(
              FondeTextVariant.dialogTitleCritical,
              'dialogTitleCritical',
              'Critical dialog title (errors, destructive actions)',
            ),
            _TextRow(
              FondeTextVariant.dialogTitleStandard,
              'dialogTitleStandard',
              'Standard dialog title (settings, forms)',
            ),
            _TextRow(
              FondeTextVariant.dialogTitleUtility,
              'dialogTitleUtility',
              'Utility dialog title (filters, auxiliary)',
            ),
          ],
        ),
        const CatalogSection(
          title: 'Interaction',
          description:
              'Text related to interactions such as buttons and form elements',
          children: [
            _TextRow(
              FondeTextVariant.buttonLabel,
              'buttonLabel',
              'Button label',
            ),
            _TextRow(FondeTextVariant.labelText, 'labelText', 'Form label'),
            _TextRow(
              FondeTextVariant.inputText,
              'inputText',
              'Text field input value',
            ),
          ],
        ),
        const CatalogSection(
          title: 'Information',
          description: 'Body text, descriptions, and supplementary information',
          children: [
            _TextRow(
              FondeTextVariant.bodyText,
              'bodyText',
              'Body / description text',
            ),
            _TextRow(
              FondeTextVariant.captionText,
              'captionText',
              'Supplementary info / small description',
            ),
            _TextRow(
              FondeTextVariant.smallText,
              'smallText',
              'Small label / badge',
            ),
          ],
        ),
        const CatalogSection(
          title: 'Content Headings',
          description: 'For user-generated content and documents',
          children: [
            _TextRow(
              FondeTextVariant.textHeading1,
              'textHeading1',
              'Top-level heading',
            ),
            _TextRow(
              FondeTextVariant.textHeading2,
              'textHeading2',
              'Chapter title',
            ),
            _TextRow(
              FondeTextVariant.textHeading3,
              'textHeading3',
              'Section heading',
            ),
            _TextRow(FondeTextVariant.textHeading4, 'textHeading4', 'Subtitle'),
            _TextRow(FondeTextVariant.textBody, 'textBody', 'Body text'),
            _TextRow(FondeTextVariant.textCaption, 'textCaption', 'Caption'),
            _TextRow(
              FondeTextVariant.textSmall,
              'textSmall',
              'Supplementary text',
            ),
          ],
        ),
        const CatalogSection(
          title: 'Code',
          children: [
            _TextRow(
              FondeTextVariant.codeBlock,
              'codeBlock',
              'Code block body',
            ),
            _TextRow(FondeTextVariant.codeInline, 'codeInline', 'Inline code'),
          ],
        ),
        const CatalogSection(
          title: 'Table',
          children: [
            _TextRow(FondeTextVariant.tableTitle, 'tableTitle', 'Table title'),
            _TextRow(
              FondeTextVariant.tableHeader,
              'tableHeader',
              'Table header',
            ),
            _TextRow(FondeTextVariant.tableBody, 'tableBody', 'Table body'),
            _TextRow(FondeTextVariant.tableCell, 'tableCell', 'Regular cell'),
            _TextRow(
              FondeTextVariant.tableRowHeader,
              'tableRowHeader',
              'Row header',
            ),
            _TextRow(
              FondeTextVariant.tableCellSmall,
              'tableCellSmall',
              'Small cell content',
            ),
            _TextRow(
              FondeTextVariant.tableFooter,
              'tableFooter',
              'Table footer',
            ),
          ],
        ),
        const CatalogSection(
          title: 'Entity Labels',
          children: [
            _TextRow(
              FondeTextVariant.entityLabelPrimary,
              'entityLabelPrimary',
              'Primary label',
            ),
            _TextRow(
              FondeTextVariant.entityLabelSecondary,
              'entityLabelSecondary',
              'Secondary label',
            ),
            _TextRow(
              FondeTextVariant.entityLabelMeta,
              'entityLabelMeta',
              'Meta label',
            ),
          ],
        ),
      ],
    );
  }
}

class _TextRow extends StatelessWidget {
  const _TextRow(this.variant, this.variantName, this.description);

  final FondeTextVariant variant;
  final String variantName;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.fondeColorScheme;
    return FondePadding(
      padding: const EdgeInsets.only(bottom: FondeSpacingValues.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FondeText(
                  variantName,
                  variant: FondeTextVariant.codeInline,
                  color: colorScheme.theme.primaryColor,
                ),
                FondeText(
                  description,
                  variant: FondeTextVariant.smallText,
                  color: colorScheme.base.foreground.withValues(alpha: 0.55),
                ),
              ],
            ),
          ),
          const FondeSpacing.xxl(),
          Expanded(child: FondeText('Sample text', variant: variant)),
        ],
      ),
    );
  }
}
