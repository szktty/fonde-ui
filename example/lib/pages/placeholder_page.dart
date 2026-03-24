import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Placeholder for catalog pages that are not yet implemented
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.fondeColorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.construction,
            size: 48,
            color: colorScheme.base.foreground.withValues(alpha: 0.55),
          ),
          const FondeSpacing.lg(),
          FondeText(title, variant: FondeTextVariant.sectionTitlePrimary),
          const FondeSpacing.sm(),
          FondeText(
            'This page is under construction',
            variant: FondeTextVariant.bodyText,
            color: colorScheme.base.foreground.withValues(alpha: 0.55),
          ),
        ],
      ),
    );
  }
}
