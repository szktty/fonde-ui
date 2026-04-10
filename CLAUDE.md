# CLAUDE.md

## Project Overview

Desktop-first Flutter UI optimized for native-quality instant feedback, with accessibility built in.

## Directory Structure

- `example`: Sample app. Component catalog
- `lib/src`: Source code
  - `lib/src/core`: Core functionality
  - `lib/src/widgets`: Widgets
- `doc`: Documentation

## Design Policy

- Component design decisions follow the priority order defined in `@doc/design/01-foundations.md`:
  1. Accessibility
  2. Desktop platform conventions
  3. Figma-style aesthetics

## Implementation Guidelines

- Use `FondeGestureDetector` instead of `GestureDetector`. Supports tap, double tap, tap down/up/cancel, hover, and cursor — with no single-tap delay when double tap is also set.
- Use `FondeRectangleBorder` for all rounded corner elements. Do not use `BorderRadius.circular` or `OutlineInputBorder` with plain `BorderRadius` — use the Figma squircle shape consistently.

## Specific Tooling

- Use `fvm flutter` instead of global `flutter` for all commands
- Use `flutter build` to verify builds. `flutter analyze` is not a substitute for a build check

## Before Committing

- Always verify that the current branch is the correct branch for the work before staging or committing
- Always run `fvm dart format .` before creating a commit
- Always ask the user for permission before running any destructive git operations, especially commits
- If a task cannot be completed after 3 attempts, ask the user for alternative approaches or options. Do not change the task requirements just to achieve completion.

## Localization (l10n)

The l10n files in `lib/src/core/l10n/` are managed **manually** — do not run `flutter gen-l10n` or enable `generate: true` in `pubspec.yaml`. The `intl` package is not used.

When adding or changing localized strings:

1. Edit the `.arb` files in `lib/l10n/` (`fonde_ui_en.arb`, `fonde_ui_ja.arb`)
2. Update the abstract class in `lib/src/core/l10n/fonde_ui_localizations.dart` — add a getter declaration with a doc comment
3. Implement the getter in `lib/src/core/l10n/fonde_ui_localizations_en.dart` and `fonde_ui_localizations_ja.dart`

## Documentation

- Design guidelines: `doc/design/`
- LLM documentation: `llms.txt`

## Branch Strategy

- All changes go to `develop` first — never commit directly to `main`
- Merge `develop` into `main` when UI component changes or fixes should be reflected in the demo

## Release

See `doc/release.md` for versioning rules, CHANGELOG format, release steps, and pub.dev publishing procedure.
