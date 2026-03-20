# Changelog

- CHANGE
  - Breaking changes
- UPDATE
  - Backward-compatible changes
- ADD
  - Backward-compatible additions
- FIX
  - Bug fixes

## 0.3.0

**Release date**: 2026-03-20

- [ADD] Add FondeStatusBar / FondeStatusBarItem / FondeStatusBarDivider
  - Fixed status bar at the bottom of the screen
  - Added `statusBar` parameter to `FondeScaffold`
- [ADD] Add FondeShortcutScope / FondeShortcutBinding / FondeShortcutRegistry
  - Scope-aware keyboard shortcut management for desktop apps
  - `FondeShortcutRegistry` enables command palette integration
- [ADD] Add FondeTooltip (enhanced)
  - Rich tooltip with title, optional description, and keyboard shortcut badge
- [ADD] Add FondeDraggable / FondeDragTarget
  - Desktop-first drag-and-drop with left-click drag, grab/grabbing cursor
  - Ghost, badge, and custom feedback styles
- [ADD] Add FondeSplitPane
  - Resizable horizontal/vertical split pane for use inside content areas
- [ADD] Add FondeSlider / FondeRangeSlider
  - Theme-aware slider applying the active accent color
- [ADD] Add FondeNotificationOverlay / FondeNotification / fondeNotificationProvider
  - Stacked notification system with auto-dismiss and severity levels
- [ADD] Add FondeColorPicker / showFondeColorPickerDialog
  - HSV color picker with saturation-value canvas, hue/alpha sliders, and hex input
- [ADD] Add catalog sample pages for all new components
- [FIX] Remove ripple effects from FondeTabBar and FondeSlider
  - Consistent with the zero-latency desktop-first design principle
- [NOTE] Design polish is pending for all new components added in this release

## 0.2.0

**Release date**: 2026-03-20

- [ADD] Add FondeNumberField
  - Numeric input field with increment/decrement buttons
  - Supports integer and decimal modes, with optional min/max/step
- [ADD] Add FondeDatePicker
  - Desktop-style popup date picker
  - Supports single-day and range selection
  - Provides `showFondeDatePickerDialog` helper function
- [ADD] Add FondeRadioButton to example catalog
- [ADD] Add automated tests (234 tests total)
- [ADD] Add component roadmap documentation
- [UPDATE] Improve CI
  - Add test job
  - Trigger on pushes to feature/** and release/** branches

## 0.1.0

**Release date**: 2026-03-18

- [ADD] Initial release
