import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:fonde_ui/fonde_ui_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Placeholder for catalog pages that are not yet implemented
class PlaceholderPage extends ConsumerWidget {
  const PlaceholderPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
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
