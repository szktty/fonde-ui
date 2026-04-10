# Design Policy & Implementation Guidelines

## Design Policy

Component design decisions follow this priority order (defined in `doc/design/01-foundations.md`):

1. Accessibility
2. Desktop platform conventions
3. Figma-style aesthetics

## Implementation Guidelines

- Use `FondeGestureDetector` instead of `GestureDetector`. Supports tap, double tap, tap down/up/cancel, hover, and cursor — with no single-tap delay when double tap is also set.
- Use `FondeRectangleBorder` for all rounded corner elements. Do not use `BorderRadius.circular` or `OutlineInputBorder` with plain `BorderRadius` — use the Figma squircle shape consistently.
