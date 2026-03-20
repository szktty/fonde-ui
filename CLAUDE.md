# CLAUDE.md

## Project Overview

Desktop-first Flutter UI optimized for native-grade instant feedback, with accessibility built in.

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
