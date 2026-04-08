# Changelog

- CHANGE
  - Breaking changes
- UPDATE
  - Backward-compatible changes
- ADD
  - Backward-compatible additions
- FIX
  - Bug fixes

## develop

## 0.10.0

**Release date**: 2026-04-08

- [CHANGE] Remove `multi_split_view` dependency — `FondeSplitPane` and `FondeScaffold` now use self-contained split implementations with transparent hit buffers for easier divider grabbing
- [CHANGE] Remove `textfield_tags` dependency — `FondeTagsField` now supports desktop-native keyboard navigation (`←`/`→` tag selection, 2-step `Backspace` delete, `Delete`, `Escape`)
- [CHANGE] Remove `figma_squircle` dependency — squircle algorithm is now implemented in-house in `SquircleBorder` / `SquircleBorderRadius`; default corner radius changed from 12px to 8px

## 0.9.0

**Release date**: 2026-04-08

- [UPDATE] Raise `multi_split_view` constraint to `^3.3.0` to fix downgrade analysis failure (`dividerHandleBuffer` not available in 3.2.x)
- [UPDATE] Raise `popover` constraint to `^0.4.0` to support latest stable version
- [UPDATE] Remove `example/` from `.pubignore` so pub.dev can detect the example app
- [FIX] Remove leftover `intl` import from `fonde_ui_localizations_en.dart` and `fonde_ui_localizations_ja.dart`
- [FIX] Remove unnecessary `flutter/services.dart` import from `FondeSearchField`
- [ADD] Declare supported platforms in `pubspec.yaml` (android, ios, linux, macos, windows)
- [CHANGE] `FondeTextField`: rewrite with `EditableText` instead of `TextField`/`InputDecoration` — eliminates zoom-scale vertical centering bug; `errorText` is now rendered below the field via a `Column`
- [CHANGE] Remove `lucide_icons_flutter` dependency — Lucide font (1.7.0, ISC License) is now bundled directly; `LucideIcons` class is provided by fonde_ui with only the icons in use; stroke weight variants removed (all icons use single weight)
- [CHANGE] Remove `freezed_annotation`, `json_annotation`, `freezed`, `json_serializable`, `build_runner` dependencies — none were in use
- [CHANGE] Remove `dots_indicator` dependency — `FondePageIndicator` is now self-contained
- [UPDATE] `FondeTextField`: use `FondeBorderRadius` for border shape construction
- [UPDATE] `FondeSearchField`: apply `rendererIgnoresPointer` and `TextFieldTapRegion` for correct gesture handling
- [UPDATE] `FondeNumberField`: use `FondeTextField` internally instead of raw `TextField`
- [UPDATE] `lucide_icons_flutter`: upgrade to 3.1.12; update renamed icons (`share2Weight200`, `settings2Weight200`)
- [FIX] `FondeTextField`: fix text vertical centering at non-1.0 zoom scales
- [FIX] `FondeTextField`: fix text selection highlight and double-tap word selection on desktop
- [FIX] `FondeTextField`: fix cursor placement on click and keyboard shortcut handling (Cmd+A, Cmd+C/V)

## 0.8.0

**Release date**: 2026-04-06

- [CHANGE] `FondeSearchField`: remove `suggestions` and `onSuggestionTap` parameters; replace with `suggestionOverlayBuilder` — a builder that receives the `TextEditingController` and a `close` callback, giving full control over the suggestion UI
- [CHANGE] Remove `searchfield` package dependency — `FondeSearchField` is now fully implemented with Flutter built-ins
- [CHANGE] Remove `uuid` package dependency
- [UPDATE] `FondeSearchField`: use `FondeRectangleBorder` (squircle) for consistent rounded-corner styling
- [FIX] `FondeSearchField`: fix cursor not appearing on single click on desktop
- [FIX] `FondeRectangleBorder`: fix focus border rendering using outer border overlay

## 0.7.1

**Release date**: 2026-03-29

- [FIX] `FondeDropdownMenu`: fix item hover background to use theme-appropriate gray instead of accent color
- [FIX] `FondeSidebarList`: remove unused imports

## 0.7.0

**Release date**: 2026-03-28

- [UPDATE] `FondeDropdownColors`: add button-specific color properties (`buttonBackground`, `buttonHoverBackground`, `buttonBorder`, `buttonText`) and item hover colors (`itemHoverBackground`, `itemHoverText`)
- [UPDATE] `FondeSidebar`: show border on floating panel style
- [UPDATE] `FondeGestureDetector`: fire single tap immediately even when `onDoubleTap` is also set; add `onTapDown` and `onTapCancel` support
- [ADD] `FondeListTile`: add `onDoubleTap`, `onTapDown`, and `onTapCancel` callbacks
- [FIX] `FondeDropdownMenu`: overhaul interaction to match macOS native behavior
  - Open on pointer down (tap-down)
  - press-drag-release selection
  - Hover highlight with accent color; button hover highlight when closed
  - Keyboard navigation (↑↓ / Enter / Esc)
  - macOS-style selection flash effect and fade-out on close
- [FIX] `FondeSidebarList`: apply sidebar color scope so selected item text is no longer invisible
- [FIX] `FondeTextField`: fix text vertical alignment to stay centered at any zoom scale
- [FIX] `FondeScaffold`, `FondeSplitPane`: shorten divider hover animation from 250ms to 100ms

## 0.6.1

**Release date**: 2026-03-24

- [FIX] Remove undefined hidden names from `fonde_ui.dart` export
- [FIX] Remove obsolete Riverpod-based tests and rewrite test helpers with `FondeApp`

## 0.6.0

**Release date**: 2026-03-24

- [CHANGE] Remove `flutter_riverpod` dependency — all state management is now plain Flutter (`ChangeNotifier`, `InheritedWidget`)
  - `fonde_ui_riverpod.dart` is deprecated and no longer exports any symbols
  - Replace `ref.watch(fondeEffectiveColorSchemeProvider)` → `context.fondeColorScheme`
  - Replace `ref.watch(fondeAccessibilityConfigProvider)` → `context.fondeAccessibility`
  - Replace `ref.read(fondeActiveThemeProvider.notifier).setTheme(x)` → `context.fondeThemeController?.setTheme(x)`
  - Replace `ref.read(fondeAccessibilityConfigProvider.notifier).updateConfig(x)` → `context.fondeAccessibilityController?.updateConfig(x)`
  - Replace sidebar/navigation/toolbar/search Riverpod providers with `FondeSidebarControllerScope`, `FondeNavigationControllerScope`, `FondeToolbarControllerScope`, `FondeSearchControllerScope`
- [ADD] `FondeThemeController`, `FondeThemeColorController`, `FondeAccessibilityController`, `FondeIconThemeController` — `ChangeNotifier`-based theme management
- [ADD] `FondePrimarySidebarController`, `FondeSecondarySidebarController`, `FondeSidebarWidthController`, `FondeSecondarySidebarWidthController` — sidebar state controllers
- [ADD] `FondeNavigationController`, `FondeToolbarController`, `FondeSearchController`, `FondeNotificationController`, `FondeMasterDetailController`
- [ADD] `context.fondeColorScheme`, `context.fondeAccessibility`, `context.fondeIconTheme`, `context.fondeColorScope`, `context.fondeZoomScale`, `context.fondeBorderScale` and related `BuildContext` extensions
- [ADD] `FondeThemeScope`, `FondeColorScopeWidget` — `InheritedWidget`-based theme and color propagation
- [ADD] `FondeNotificationControllerScope` — replaces `fondeNotificationProvider`

## 0.5.0

**Release date**: 2026-03-23

- [ADD] `FondeSwitch` — toggle switch widget with `compact` (32×20px) and `wide` (38×18px, pill knob) styles; 300ms easeInOut animation always enabled
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
