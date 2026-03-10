/// Riverpod integration for fonde_ui.
///
/// Import this library in addition to [fonde_ui.dart] to access
/// Riverpod-based state providers for themes, navigation, layout, and more.
library;

// ─── Core: Theme ──────────────────────────────────────────────────────────────
export 'src/riverpod/core/theme_providers.dart';
export 'src/riverpod/core/theme_color_providers.dart'
    hide FondeThemeColorNotifier;

// ─── Core: Accessibility ──────────────────────────────────────────────────────
export 'src/riverpod/core/accessibility_utils.dart';

// ─── Widgets: Navigation ──────────────────────────────────────────────────────
export 'src/riverpod/widgets/navigation_providers.dart';
export 'src/riverpod/widgets/search_providers.dart';

// ─── Widgets: Toolbar ─────────────────────────────────────────────────────────
export 'src/riverpod/widgets/toolbar_providers.dart';
export 'src/riverpod/widgets/toolbar_state.dart';

// ─── Widgets: Layout ──────────────────────────────────────────────────────────
export 'src/riverpod/widgets/sidebar_state_providers.dart';
export 'src/riverpod/widgets/sidebar_width_provider.dart';

// ─── Widgets: Icons ───────────────────────────────────────────────────────────
export 'src/riverpod/widgets/icon_theme_providers.dart';

// ─── Widgets: Typography ──────────────────────────────────────────────────────
export 'src/riverpod/widgets/text_style_builder_ext.dart';
