# Component Roadmap

## Priority: High

### FondeStatusBar
Status bar at the bottom of the screen. Can be implemented by adding a `statusBar` parameter to `FondeScaffold`.
Required to complete the typical desktop app layout.

### Keyboard Shortcut Management (FondeShortcutScope)
Scope-aware keyboard shortcut management. Required to fulfill the desktop-first design principle (mouse + keyboard assumed).
Useful standalone, and becomes more valuable paired with a command palette.

### FondeDraggable / FondeDragTarget
Drag-and-drop for files, list items, and panel reordering.
Flutter's default `Draggable` has mobile-oriented behavior; a desktop-appropriate wrapper is needed.

### FondeTooltip (enhanced)
Rich-content tooltip supporting keybinding display, multi-line content, etc.
Currently, button widgets only accept a plain string via the `tooltip` parameter.

---

## Priority: Medium

### FondeSplitPane
Horizontal/vertical split pane for use inside content areas.
`FondeScaffold` uses `multi_split_view` internally, but it is not easily reusable for splits within content.

### ~~FondeNumberField~~ ✓ Done (WIP — design polish pending)
Numeric input with increment/decrement buttons. Common in settings UIs.

### FondeSlider
Theme-aware slider. Flutter's default `Slider` does not match fonde-ui's visual style out of the box.

### Notification Stack (FondeNotificationOverlay)
Queue and stacking management for multiple simultaneous `FondeToast` notifications.
The current `FondeToast` appears to be designed for single-instance use.

### FondeColorPicker
Color picker UI in popup form.

### ~~FondeDatePicker~~ ✓ Done (WIP — design polish pending) / FondeTimePicker
Desktop-style popup date and time pickers.

---

## Priority: Low (high app-specificity or high implementation cost)

- `FondeTreeView` — may overlap with `FondeOutlineView`; needs clarification
- `FondeCalendar` — general-purpose but high implementation cost
- `FondeKanban` — too app-specific

---

## Note on Command Palette

The UI primitives (overlay, search field + result list) can live in the library,
but command registration and execution logic is app-specific.
The recommended approach is to implement it in RinneGraph first,
then extract the reusable UI layer into fonde-ui afterward.
