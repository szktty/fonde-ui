# CLAUDE.md

## Project Overview

Desktop-first Flutter UI optimized for native-quality instant feedback, with accessibility built in.

## Directory Structure

- `example`: Sample app. Component catalog
- `lib/src`: Source code
  - `lib/src/core`: Core functionality
  - `lib/src/widgets`: Widgets
- `doc`: Documentation

## Specific Tooling

- Use `fvm flutter` instead of global `flutter` for all commands
- Use `flutter build` to verify builds. `flutter analyze` is not a substitute for a build check

## Before Committing

- Always verify that the current branch is the correct branch for the work before staging or committing
- Always run `fvm dart format .` before creating a commit
- Always ask the user for permission before running any destructive git operations, especially commits
- If a task cannot be completed after 3 attempts, ask the user for alternative approaches or options. Do not change the task requirements just to achieve completion.

## References

- Design policy and implementation guidelines: `doc/design-policy.md`
- Localization: `doc/localization.md`
- Release procedure (versioning, CHANGELOG, branch strategy, pub.dev): `doc/release.md`
- Design guidelines: `doc/design/`
- LLM documentation: `llms.txt`
