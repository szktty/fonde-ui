# 10. Table View (FondeTableView)

## Overview

`FondeTableView` is a component for efficiently displaying and manipulating structured data. It is optimized for mouse and keyboard operations based on a desktop-first design philosophy, and is intended to be implemented in `packages/fonde_ui_widgets/lib/src/table_view/`.

### Design Principles

**1. Information Density Optimization**
- Efficient use of space in a desktop environment
- Displaying large amounts of information by utilizing vertical space
- Ensuring readability with appropriate row spacing

**2. Intuitive Operability**
- Precise column operations with mouse (resize, reorder)
- Keyboard navigation support
- Consistent interaction patterns

**3. Accessibility**
- WCAG 2.1 AA compliant
- Zoom functionality (100%–200%)
- Screen reader support

**4. Performance Optimization**
- Efficient display of large amounts of data
- Optimized rendering through virtualization
- Minimal rebuilds

## Layout Specifications

### Basic Structure

```
┌─ FondeTableView ───────────────────────────┐
│ ┌─ Header Row ──────────────────────────┐ │
│ │ Column 1 │ Column 2 │ Column 3 │ ... │ Resize Handle │ │
│ └───────────────────────────────────────┘ │
│ ┌─ Data Rows ───────────────────────────┐ │
│ │ Cell 1   │ Cell 2   │ Cell 3   │ ...  │ │
│ │ Cell 1   │ Cell 2   │ Cell 3   │ ...  │ │
│ │ ...                                   │ │
│ └───────────────────────────────────────┘ │
│ ┌─ Scrollbar ───────────────────────────┐ │
│ │ Vertical Scroll │ Horizontal Scroll   │ │
│ └───────────────────────────────────────┘ │
└───────────────────────────────────────────┘
```

### Dimensions and Spacing

**Overall Table**
- Outer border: 1px (`colorScheme.base.border`)
- Background color: `colorScheme.base.background`

**Header Row**
- Height: 32px (desktop optimized)
- Horizontal padding: 12px (`FondeSpacingValues.md`)
- Vertical padding: 8px (`FondeSpacingValues.sm`)
- Font: `FondeTextVariant.uiCaption` (14px, Medium weight)

**Data Row**
- Height: 28px (emphasizing information density)
- Horizontal padding: 12px (`FondeSpacingValues.md`)
- Vertical padding: 6px
- Font: `FondeTextVariant.uiCaption` (14px, Regular weight)

**Column Separator**
- Vertical border: 0px (no vertical separators between cells)
- Horizontal border: 1px (`colorScheme.base.border`)

## Visual Design

### Color System

Use standard `FondeColorScheme` semantic tokens. Do not use transparency (`withAlpha`, `withOpacity`); use dedicated semantic color properties.

**Background Colors**

| State | Color Token |
|---|---|
| Table background | `colorScheme.base.background` |
| Header background | `colorScheme.uiAreas.panel.background` |
| Odd row | `colorScheme.base.background` |
| Even row | `colorScheme.interactive.list.hoverBackground` (subtle alternating tint) |
| Hovered row | `colorScheme.interactive.list.hoverBackground` |
| Selected row | `colorScheme.interactive.list.selectedBackground` |

> **Note**: For alternating row backgrounds, use colors that are clearly distinguishable for accessibility. Do not use transparency; use dedicated semantic color tokens.

**Text Colors**

| State | Color Token |
|---|---|
| Header text | `colorScheme.base.foreground` |
| Cell text | `colorScheme.base.foreground` |
| Selected row text | `colorScheme.interactive.list.selectedText` |

**Border Colors**

| State | Color Token |
|---|---|
| Normal border | `colorScheme.base.border` |
| Focus border | `colorScheme.interactive.input.focusBorder` |

### State Representation

**Row States**

| State | Visual |
|---|---|
| **Normal** | Default background (alternating odd/even) |
| **Hover** | `colorScheme.interactive.list.hoverBackground` |
| **Selected** | `colorScheme.interactive.list.selectedBackground` + `selectedText` |
| **Focused** | `colorScheme.interactive.input.focusBorder` outline |

**Column Header States**

| State | Visual |
|---|---|
| **Normal** | Default header style |
| **Sorted** | Sort direction indicator displayed |
| **Resizing** | Cursor changes to `col-resize`, resize preview shown |
| **Dragging (reorder)** | Column rendered at reduced opacity, insertion point indicator shown |

## Interaction Specifications

### Selection

**Single Selection (Default)**
- Click: Select row
- Cmd+Click: Deselect
- Arrow keys: Move selection

**Multiple Selection (Optional)**
- Cmd+Click: Add/remove from selection
- Shift+Click: Range selection
- Cmd+A: Select all

### Column Operations

**Column Resize**
- Resize handle: On column boundary (8px wide tap target)
- Cursor: `col-resize`
- Minimum width: 50px (default)
- Maximum width: Unlimited (default)
- Real-time preview: Enabled

**Column Reorder**
- Start drag: Click + drag on header
- Dragging display: Semi-transparent column + insertion point indicator
- Drop target: Between other column headers
- Animation: Disabled (performance prioritized)

**Column Sort**
- Click: Toggle sort state (Ascending → Descending → None)
- Indicator: Arrow icon (▲ / ▼)
- Multi-column sort: Not supported (simplicity prioritized)

### Scroll

**Scrollbar**
- Visibility: Always shown (`isAlwaysShown: true`)
- Thickness: 8px (normal), 10px (while dragging)
- Zoom support: Thickness scales with `FondeAccessibilityConfig.zoomScale`
- Position: Right edge (vertical), bottom edge (horizontal)

**Scroll Behavior**
- Mouse wheel: Vertical scroll
- Shift + Mouse wheel: Horizontal scroll
- Keyboard: Arrow keys, Page Up/Down, Home/End
- Smooth scroll: Disabled (performance prioritized)

## Accessibility

### Zoom Support

All size-related values must respect `FondeAccessibilityConfig`:

```dart
final config = ref.watch(fondeAccessibilityConfig);

// Font size is handled automatically by FondeTextVariant
// Scale scrollbar thickness
final scrollbarThickness = 8.0 * config.zoomScale;
// Scale border width
final borderWidth = 1.0 * config.borderScale;
```

**Zoom Range**
- Minimum: 100%
- Maximum: 200%
- Increment: 25%

### Keyboard Navigation

**Basic Operations**

| Key | Action |
|---|---|
| Tab | Move to next focusable element |
| Shift+Tab | Move to previous focusable element |
| Enter | Select row / execute action |
| Space | Toggle row selection |

**Row Navigation**

| Key | Action |
|---|---|
| ↑ / ↓ | Move row focus |
| Page Up / Down | Page-by-page movement |
| Home / End | First / last row |
| Cmd+Home / End | Top / bottom of table |

**Column Operations (header focused)**

| Key | Action |
|---|---|
| ← / → | Move column focus |
| Enter | Toggle sort |

### Screen Reader Support

**Semantic Roles**
- `role="table"`: Table container
- `role="columnheader"`: Column header cell
- `role="row"`: Row element
- `role="cell"`: Data cell

**ARIA Attributes**
- `aria-label`: Table description
- `aria-sort`: Sort state (`ascending` / `descending` / `none`)
- `aria-selected`: Selected state
- `aria-rowindex`: Row number
- `aria-colindex`: Column number

## Implementation

### Basic Usage

```dart
FondeTableView<MyItem>(
  columns: [
    FondeTableColumn(
      label: 'Name',
      width: 200,
    ),
    FondeTableColumn(
      label: 'Status',
      width: 120,
    ),
  ],
  rows: items.map((item) => FondeTableRow(
    key: ValueKey(item.id),
    cells: [
      FondeTableCell(child: FondeText(item.name, variant: FondeTextVariant.uiCaption)),
      FondeTableCell(child: FondeText(item.status, variant: FondeTextVariant.uiCaption)),
    ],
    onTap: () => onSelectItem(item),
  )).toList(),
)
```

### Color Usage

```dart
// ✅ Correct: use FondeColorScheme semantic tokens
final colorScheme = ref.watch(fondeEffectiveColorScheme);

Container(
  color: colorScheme.base.background,  // table background
  child: ...,
)

// ✅ Correct: selected state
Container(
  color: isSelected
    ? colorScheme.interactive.list.selectedBackground
    : colorScheme.base.background,
  child: FondeText(
    text,
    variant: FondeTextVariant.uiCaption,
    color: isSelected
      ? colorScheme.interactive.list.selectedText
      : colorScheme.base.foreground,
  ),
)

// ❌ Incorrect: do not use app-specific or hardcoded colors
Container(color: AppColorScheme.appSpecific.table.background)
Container(color: Colors.grey.withOpacity(0.1))
```

### Accessibility Integration

```dart
final config = ref.watch(fondeAccessibilityConfig);

FondeTableView<MyItem>(
  scrollbarThickness: 8.0 * config.zoomScale,
  borderWidth: 1.0 * config.borderScale,
  // ...
)
```

## Performance Considerations

### Large Data Support

**Row Virtualization**
- Rows outside the visible area are not rendered
- Dynamic rendering during scrolling
- Optimized memory usage

**Rendering Optimization**
- Suppress unnecessary rebuilds with `const` constructors where possible
- Efficient cell content updates
- Animations disabled (consistent with Fonde UI no-animation policy)

### Implementation Recommendations

**Data Structure**
- Use immutable data objects
- Provide efficient key extraction functions for row identity
- Implement proper `==` and `hashCode`

**State Management**
- Manage selection state separately from data
- Persist column width/order settings
- Manage sort state with Riverpod providers

---

**Navigation**: [← Back](./09-color-design-guidelines.md) | [Top: README](./README.md)
