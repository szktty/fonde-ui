# CLAUDE.md

## Project Overview

Desktop-first Flutter UI optimized for native-quality instant feedback, with accessibility built in.

## Directory Structure

- `example`: Sample app. Component catalog
- `lib/src`: Source code
  - `lib/src/core`: Core functionality
  - `lib/src/widgets`: Widgets
  - `lib/src/riverpod`: Riverpod-related code
- `doc`: Documentation

## Design Policy

- Use Riverpod for state management
  - APIs that depend on Riverpod must be exported via `fonde_ui_riverpod.dart`
- Component design decisions follow the priority order defined in `@doc/design/01-foundations.md`:
  1. Accessibility
  2. Desktop platform conventions
  3. Figma-style aesthetics

## Specific Tooling

- Use `fvm flutter` instead of global `flutter` for all commands
- Use `flutter build` to verify builds. `flutter analyze` is not a substitute for a build check

## Before Committing

- Always run `fvm dart format .` before creating a commit

## Documentation

- Design guidelines: @doc/design/
- LLM documentation: @llms.txt

## Branch Strategy

- All changes go to `develop` first — never commit directly to `main`
- Merge `develop` into `main` when UI component changes or fixes should be reflected in the demo
  - Timing is decided by the user, not automatically

## Release Procedure

Use git flow for releases:

```bash
git flow release start <version>       # e.g. 1.2.0
# Update version in pubspec.yaml, example/pubspec.yaml, llms.txt
# Update CHANGELOG.md (remove -dev suffix, confirm release date)
fvm dart format .
cd example && fvm flutter build macos  # verify build
git add -p && git commit -m "Release version <version>"
git flow release finish <version>      # merges to main + develop, creates tag v<version>
git push origin main develop --tags
```

- The `-dev` suffix is removed from the version on release
- After release, bump version to next `-dev` on `develop`

## Versioning

- **Patch** (x.y.Z): bug fixes only
- **Minor** (x.Y.0): any breaking changes or additions
- **Major** (X.0.0): significant development milestones, decided by the user

Use `-dev` suffix for in-progress versions (e.g. `0.5.0-dev`).

When bumping the version, update **both** `pubspec.yaml` and `example/pubspec.yaml` to the same value.
The example app displays its own version at runtime via `package_info_plus`, which reads `example/pubspec.yaml`.

## CHANGELOG

Entries within each version must follow this category order:

1. CHANGE — breaking changes
2. UPDATE — backward-compatible changes
3. ADD — backward-compatible additions
4. FIX — bug fixes
