import 'package:flutter/material.dart';
import 'package:fonde_ui/fonde_ui.dart';

import 'catalog_welcome.dart' show kCardSampleHeight;

class ButtonsSample extends StatelessWidget {
  const ButtonsSample();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: FondeSpacingValues.sm,
      runSpacing: FondeSpacingValues.sm,
      children: [
        FondeButton.primary(label: 'Primary', onPressed: () {}),
        FondeButton.normal(label: 'Normal', onPressed: () {}),
        FondeButton.destructive(label: 'Delete', onPressed: () {}),
        FondeButtonGroup(
          children: [
            FondeButtonGroupItem(
              icon: LucideIcons.bold,
              onPressed: () {},
              isSelected: true,
            ),
            FondeButtonGroupItem(icon: LucideIcons.italic, onPressed: () {}),
            FondeButtonGroupItem(icon: LucideIcons.underline, onPressed: () {}),
          ],
        ),
      ],
    );
  }
}

class InputSample extends StatelessWidget {
  const InputSample();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const FondeTextField(hintText: 'Text field'),
        const FondeSpacing.sm(),
        const FondeSearchField(hint: 'Search...'),
        const FondeSpacing.sm(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FondeCheckbox(value: true, onChanged: null),
            const SizedBox(width: FondeSpacingValues.sm),
            const FondeText('Option A', variant: FondeTextVariant.captionText),
            const SizedBox(width: FondeSpacingValues.md),
            const FondeCheckbox(value: false, onChanged: null),
            const SizedBox(width: FondeSpacingValues.sm),
            const FondeText('Option B', variant: FondeTextVariant.captionText),
          ],
        ),
      ],
    );
  }
}

class MenusSample extends StatelessWidget {
  const MenusSample();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.fondeColorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.base.border),
        borderRadius: FondeBorderRadiusValues.smallRadius,
        color: colorScheme.uiAreas.dialog.background,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (icon, label, selected) in [
            (LucideIcons.filePlus, 'New File', false),
            (LucideIcons.pencil, 'Rename', true),
            (LucideIcons.trash2, 'Delete', false),
          ])
            Container(
              color:
                  selected
                      ? colorScheme.interactive.list.selectedBackground
                      : null,
              padding: const EdgeInsets.symmetric(
                horizontal: FondeSpacingValues.md,
                vertical: 6,
              ),
              child: Row(
                children: [
                  Icon(icon, size: 14),
                  const SizedBox(width: FondeSpacingValues.sm),
                  FondeText(label, variant: FondeTextVariant.bodyText),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class NavigationSample extends StatelessWidget {
  const NavigationSample();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.fondeColorScheme;
    return ClipRRect(
      borderRadius: FondeBorderRadiusValues.smallRadius,
      child: SizedBox(
        height: kCardSampleHeight - FondeSpacingValues.md * 2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Launch Bar
            Container(
              width: 28,
              color: colorScheme.uiAreas.launchBar.background,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      for (final (icon, active) in [
                        (LucideIcons.layoutGrid, true),
                        (LucideIcons.search, false),
                        (LucideIcons.gitBranch, false),
                      ])
                        Container(
                          width: 28,
                          height: 28,
                          color:
                              active
                                  ? colorScheme
                                      .uiAreas
                                      .launchBar
                                      .activeItemBackground
                                  : null,
                          child: Icon(
                            icon,
                            size: 13,
                            color:
                                active
                                    ? colorScheme.uiAreas.launchBar.activeItem
                                    : colorScheme
                                        .uiAreas
                                        .launchBar
                                        .inactiveItem,
                          ),
                        ),
                    ],
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    child: Icon(
                      LucideIcons.settings2,
                      size: 13,
                      color: colorScheme.uiAreas.launchBar.inactiveItem,
                    ),
                  ),
                ],
              ),
            ),
            // Vertical divider
            Container(width: 1, color: colorScheme.uiAreas.sideBar.divider),
            // Sidebar list
            Expanded(
              child: Container(
                color: colorScheme.uiAreas.sideBar.background,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final (icon, label, selected) in [
                      (LucideIcons.inbox, 'Inbox', true),
                      (LucideIcons.send, 'Sent', false),
                      (LucideIcons.archive, 'Archive', false),
                      (LucideIcons.trash2, 'Trash', false),
                    ])
                      Container(
                        color:
                            selected
                                ? colorScheme
                                    .uiAreas
                                    .sideBar
                                    .activeItemBackground
                                : null,
                        padding: const EdgeInsets.symmetric(
                          horizontal: FondeSpacingValues.sm,
                          vertical: 5,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              icon,
                              size: 12,
                              color:
                                  selected
                                      ? colorScheme
                                          .uiAreas
                                          .sideBar
                                          .activeItemText
                                      : colorScheme
                                          .uiAreas
                                          .sideBar
                                          .inactiveItemText,
                            ),
                            const SizedBox(width: FondeSpacingValues.xs),
                            FondeText(
                              label,
                              variant: FondeTextVariant.captionText,
                              color:
                                  selected
                                      ? colorScheme
                                          .uiAreas
                                          .sideBar
                                          .activeItemText
                                      : colorScheme
                                          .uiAreas
                                          .sideBar
                                          .inactiveItemText,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LayoutSample extends StatelessWidget {
  const LayoutSample();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.fondeColorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tab bar mockup
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: colorScheme.base.border)),
          ),
          child: Row(
            children: [
              for (final (label, selected) in [
                ('Files', true),
                ('Search', false),
                ('Git', false),
              ])
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FondeSpacingValues.sm,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color:
                            selected
                                ? colorScheme.theme.primaryColor
                                : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: FondeText(
                    label,
                    variant: FondeTextVariant.captionText,
                    color:
                        selected
                            ? colorScheme.base.foreground
                            : colorScheme.base.foreground.withValues(
                              alpha: 0.5,
                            ),
                  ),
                ),
            ],
          ),
        ),
        const FondeSpacing.sm(),
        // Panel mockup
        FondePanel(
          header: FondePadding.symmetric(
            horizontal: FondeSpacingValues.md,
            vertical: FondeSpacingValues.xs,
            child: const FondeText(
              'Details',
              variant: FondeTextVariant.sectionTitleSecondary,
            ),
          ),
          content: FondePadding.symmetric(
            horizontal: FondeSpacingValues.md,
            vertical: FondeSpacingValues.xs,
            child: FondeText(
              'Resizable panels',
              variant: FondeTextVariant.captionText,
              color: colorScheme.base.foreground.withValues(alpha: 0.55),
            ),
          ),
        ),
      ],
    );
  }
}

class DataViewSample extends StatelessWidget {
  const DataViewSample();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.fondeColorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Table header
        Container(
          color: colorScheme.base.background,
          padding: const EdgeInsets.symmetric(
            horizontal: FondeSpacingValues.sm,
            vertical: 5,
          ),
          child: Row(
            children: [
              for (final label in ['Name', 'Type', 'Size'])
                Expanded(
                  child: FondeText(
                    label,
                    variant: FondeTextVariant.captionText,
                    color: colorScheme.base.foreground.withValues(alpha: 0.55),
                  ),
                ),
            ],
          ),
        ),
        Container(height: 1, color: colorScheme.base.border),
        for (final (name, type, size, selected) in [
          ('main.dart', 'Dart', '4 KB', true),
          ('pubspec.yaml', 'YAML', '1 KB', false),
        ])
          Container(
            color:
                selected
                    ? colorScheme.interactive.list.selectedBackground
                    : null,
            padding: const EdgeInsets.symmetric(
              horizontal: FondeSpacingValues.sm,
              vertical: 5,
            ),
            child: Row(
              children: [
                Expanded(
                  child: FondeText(name, variant: FondeTextVariant.captionText),
                ),
                Expanded(
                  child: FondeText(
                    type,
                    variant: FondeTextVariant.captionText,
                    color: colorScheme.base.foreground.withValues(alpha: 0.6),
                  ),
                ),
                Expanded(
                  child: FondeText(
                    size,
                    variant: FondeTextVariant.captionText,
                    color: colorScheme.base.foreground.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class FeedbackSample extends StatelessWidget {
  const FeedbackSample();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.fondeColorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dialog mockup
        Container(
          decoration: BoxDecoration(
            color: colorScheme.uiAreas.dialog.background,
            border: Border.all(color: colorScheme.base.border),
            borderRadius: FondeBorderRadiusValues.mediumRadius,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: FondeSpacingValues.md,
            vertical: FondeSpacingValues.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const FondeText('Confirm', variant: FondeTextVariant.itemTitle),
              const FondeSpacing.xs(),
              FondeText(
                'Are you sure?',
                variant: FondeTextVariant.captionText,
                color: colorScheme.base.foreground.withValues(alpha: 0.6),
              ),
              const FondeSpacing.xs(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FondeButton.cancel(label: 'Cancel', onPressed: () {}),
                  const SizedBox(width: FondeSpacingValues.xs),
                  FondeButton.primary(label: 'OK', onPressed: () {}),
                ],
              ),
            ],
          ),
        ),
        const FondeSpacing.sm(),
        // Progress bar
        const FondeLinearProgressIndicator(value: 0.65),
      ],
    );
  }
}

class TypographySample extends StatelessWidget {
  const TypographySample();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.fondeColorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const FondeText('Page Title', variant: FondeTextVariant.pageTitle),
        const FondeText(
          'Section Title',
          variant: FondeTextVariant.sectionTitleSecondary,
        ),
        const FondeText('Body text', variant: FondeTextVariant.bodyText),
        FondeText(
          'Caption text',
          variant: FondeTextVariant.captionText,
          color: colorScheme.base.foreground.withValues(alpha: 0.55),
        ),
        FondeText(
          'Small text',
          variant: FondeTextVariant.smallText,
          color: colorScheme.base.foreground.withValues(alpha: 0.45),
        ),
      ],
    );
  }
}
