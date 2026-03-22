# Changelog

- CHANGE
  - Breaking changes
- UPDATE
  - Backward-compatible changes
- ADD
  - Backward-compatible additions
- FIX
  - Bug fixes

## 0.5.0-dev

**Release date**: 2026-03-23

- [ADD] `FondeSidebarStyle` enum (`standard` / `floatingPanel`) — pass via `FondeSidebar.style`
  - `floatingPanel`: toolbar and content float together as a squircle panel over a lighter outer background (macOS-style)
  - `FondeSidebar` now accepts a `toolbar` parameter; when provided, `FondeSidebarPane` wrapping is skipped to avoid duplicate toolbars
- [ADD] `FondeSidebarListItemStyle.inset` — individual items render as squircle rounded rectangles (macOS sidebar item style)
- [ADD] `FondeFloatingPanelScope` — `InheritedWidget` that `FondeSidebarList` uses to detect floating panel context and apply transparent background
- [ADD] `FondeSideBar` color scheme entries: `floatingPanelOuterBackground` / `floatingPanelBackground`
- [UPDATE] `FondePrimarySidebarToolbar`: add `backgroundColor` / `borderColor` parameters
- [UPDATE] Example app: sidebar style toggle button in the sidebar toolbar (standard ↔ floating panel)

## 0.4.0

**Release date**: 2026-03-22

- [CHANGE] Redesign FondeCheckbox
  - Add `shape` parameter: `FondeCheckboxShape.rectangle` (default) / `.circle`
  - Add `fillStyle` parameter: `FondeCheckboxFillStyle.filled` (default) / `.outline` / `.iconOnly`
    - `filled`: background filled with primary color when checked (macOS style, default)
    - `outline`: no fill, border and icon use primary color when checked (Figma style)
    - `iconOnly`: no fill, no border color change, only icon is colored
  - Fix check icon color from hardcoded Colors.black/white to `colorScheme.interactive.button.primaryText`
  - Replace indeterminate indicator (small rect) with `FondeIconTheme.checkIndeterminate` icon
- [UPDATE] FondeColorPicker: enable alpha slider by default (`showAlpha: true`)
- [UPDATE] FondeColorPicker: reorder bottom row to preview → eyedropper → hex input → opacity %
- [UPDATE] FondeColorPicker: fix alpha slider checkerboard to respect rounded corners
- [UPDATE] FondeDatePicker: remove header/weekdays/grid border decorations
- [UPDATE] FondeDatePicker: suppress month-switch animation and selection animation
- [UPDATE] FondeToolbarGroup: add `overflowItems`, `overflowTooltip`, `availableWidth` params; items that don't fit are hidden behind an ellipsis (⋯) popup menu
- [UPDATE] FondeMainToolbar: pass a finite width to trailing so overflow detection in `FondeToolbarGroup` works correctly; trailing is right-aligned within its allocated space
- [UPDATE] Default Lucide check/indeterminate icons changed to 600-weight (strokeWidth 3.0) for better visibility
- [UPDATE] Update llms.txt documentation for FondeRectangleBorder, FondeBorderRadius, FondeBorderSide, FondeBorderRadiusValues
- [UPDATE] Clarify design principles: accessibility over aesthetics, revise animation policy (remove zero-latency framing)
- [ADD] Add FondeEyeDropper / FondeEyeDropperButton for in-window color sampling
  - `FondeApp(enableEyeDropper: true)` opts in to wrapping the tree with `FondeEyeDropper`
  - Cursor changes to crosshair; zoom loupe follows the pointer; click to pick, right-click to cancel
  - Only samples pixels within the Flutter window
- [ADD] FondeColorPicker: add `palette` parameter for swatch row
- [ADD] FondeColorPicker: add `showEyeDropper` parameter; requires `FondeEyeDropper` in the tree
- [ADD] FondeColorPicker: add opacity percentage input field next to hex input (shown when `showAlpha: true`)
- [ADD] Add `checkIndeterminate` and `minus` to `FondeIconTheme`
- [ADD] Add `checkboxIconSizeRatio` to `FondeIconTheme` — controls icon size relative to checkbox size per icon set
- [ADD] Add catalog sample page for FondeRectangleBorder / FondeBorderRadius / FondeBorderSide
- [ADD] Add design guidelines to `doc/design/` (copied from private repo)
- [ADD] Example app: show fonde_ui version dynamically in toolbar via `package_info_plus`

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
