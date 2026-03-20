# Component Roadmap

## Priority: High

### ~~FondeStatusBar~~ ✓ Done
Status bar at the bottom of the screen. Added `statusBar` parameter to `FondeScaffold`.
Also provides `FondeStatusBarItem` and `FondeStatusBarDivider`.

### ~~Keyboard Shortcut Management (FondeShortcutScope)~~ ✓ Done
Scope-aware keyboard shortcut management. `FondeShortcutScope` wraps `Shortcuts`+`Actions`
with desktop-first defaults and a `FondeShortcutRegistry` for command-palette integration.

### ~~FondeDraggable / FondeDragTarget~~ ✓ Done
Desktop-appropriate drag-and-drop. `FondeDraggable<T>` uses left-button drag, grab/grabbing
cursor, ghost/badge/custom feedback. `FondeDragTarget<T>` exposes `isOver` to builders.

### ~~FondeTooltip (enhanced)~~ ✓ Done
Rich-content tooltip supporting keybinding display (`shortcut` param), multi-line `description`,
and themed styling via `_FondeTooltipDecoration`.

---

## Priority: Medium

### ~~FondeSplitPane~~ ✓ Done
Horizontal/vertical split pane for use inside content areas, built on `multi_split_view`.
Accepts `initialSizes`, `minSizes`, `maxSizes`, and `onSizesChanged`.

### ~~FondeNumberField~~ ✓ Done (WIP — design polish pending)
Numeric input with increment/decrement buttons. Common in settings UIs.

### ~~FondeSlider~~ ✓ Done
Theme-aware slider. `FondeSlider` and `FondeRangeSlider` apply primary color, consistent
track/thumb sizing, and accessibility zoom scaling.

### ~~Notification Stack (FondeNotificationOverlay)~~ ✓ Done
`FondeNotificationOverlay` wraps a widget tree and shows stacked notifications from
`fondeNotificationProvider`. Supports info/success/warning/error, auto-dismiss, and max-visible cap.

### ~~FondeColorPicker~~ ✓ Done
HSV color picker with saturation-value canvas, hue slider, optional alpha slider, and hex input.
`showFondeColorPickerDialog` shows it in a themed popup.

### ~~FondeDatePicker~~ ✓ Done (WIP — design polish pending) / FondeTimePicker
Desktop-style popup date and time pickers.

---

## Priority: Low (high app-specificity or high implementation cost)

- `FondeTreeView` — may overlap with `FondeOutlineView`; needs clarification
- `FondeCalendar` — general-purpose but high implementation cost
- `FondeKanban` — too app-specific
- `FondeFloatingActionButton` — FAB is a mobile-first pattern; desktop apps typically use toolbar
  buttons or fixed-position action buttons instead. Implement only if a clear desktop use case emerges
  (e.g., floating "Create" button above a canvas). `Stack` + `FondeButton.primary` is a viable substitute.

---

## Note on Command Palette

The UI primitives (overlay, search field + result list) can live in the library,
but command registration and execution logic is app-specific.
The recommended approach is to implement it in RinneGraph first,
then extract the reusable UI layer into fonde-ui afterward.
