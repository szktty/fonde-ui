# Release Procedure

## Branch Strategy

- All changes go to `develop` first — never commit directly to `main`
- Merge `develop` into `main` when UI component changes or fixes should be reflected in the demo
  - Timing is decided by the user, not automatically

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

During development, add entries under a `## develop` section at the top of the changelog. When releasing, replace the `## develop` section with the new version header (e.g. `## 0.9.0`) and add the release date.

## Release Steps

```bash
git flow release start <version>       # e.g. 1.2.0
# Update version in pubspec.yaml, example/pubspec.yaml, llms.txt
# Update CHANGELOG.md (remove -dev suffix, confirm release date)
# Update llms.txt to reflect API changes (added/removed/modified APIs, removed dependencies)
fvm dart format .
cd example && fvm flutter build macos  # verify build
git add -p && git commit -m "Release version <version>"
git flow release finish <version>      # merges to main + develop, creates tag v<version>
git push origin main develop --tags
fvm dart pub publish --dry-run         # verify published files before publishing
fvm dart pub publish                   # publish to pub.dev
```

- The `-dev` suffix is removed from the version on release
- After release, bump version to next `-dev` on `develop` and add a `## develop` section to `CHANGELOG.md`

## pub.dev Publishing

- Run `fvm dart pub publish --dry-run` first to verify the list of files to be published
- `CLAUDE.md` is intentionally included in the published package — do **not** add it to `.pubignore`
- Stash untracked/uncommitted files before starting the release if needed
