# Localization (l10n)

The l10n files in `lib/src/core/l10n/` are managed **manually** — do not run `flutter gen-l10n` or enable `generate: true` in `pubspec.yaml`. The `intl` package is not used.

When adding or changing localized strings:

1. Edit the `.arb` files in `lib/l10n/` (`fonde_ui_en.arb`, `fonde_ui_ja.arb`)
2. Update the abstract class in `lib/src/core/l10n/fonde_ui_localizations.dart` — add a getter declaration with a doc comment
3. Implement the getter in `lib/src/core/l10n/fonde_ui_localizations_en.dart` and `fonde_ui_localizations_ja.dart`
