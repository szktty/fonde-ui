# 01. Basic Concepts and Principles

## Design Principles

### Core Philosophy

**1. Consistency**
- Unified design language across all components
- Centralized management through design tokens
- Predictable user experience

**2. Accessibility**
- WCAG 2.1 AA compliant
- Full keyboard navigation support
- Screen reader support
- Zoom functionality (100%–200%)

**3. Platform Integration**
- Harmony with macOS native UI
- Automatic reflection of system settings (dark mode, etc.)
- Integration with native accessibility APIs

**4. Customizability**
- Flexible styling through the theme system
- Extensible component architecture

**5. Performance**
- Efficient widget tree
- Minimal rebuilds
- Immediate feedback (zero-latency response to user input is the principle)

**6. No Animation**
- **All animations are disabled** (except progress bars, popovers, and dialogs)
- Improved usability and performance optimization
- Reduced visual noise

### Desktop-First Design

**Target**: Desktop applications (macOS, Windows, Linux)

- **Input method**: Optimized for mouse and keyboard
- **Size standard**: 32px base optimized for desktop, not 44px for mobile
- **Information density**: Efficient use of vertical space
- **Precise operation**: Supports precise cursor-based interaction

### Component Design Priority Order

When two design options conflict, resolve in this order:

1. **Accessibility first** — State must be perceivable across environments: small sizes, low contrast, high-contrast mode, and zoom scales. Designs that convey state through surface area (fill, border color change) are preferred over designs that rely solely on thin strokes or icon presence.
2. **Desktop platform conventions second** — Primary targets are macOS, Windows, and Linux. When no accessibility concern exists, follow the convention that feels native on those platforms (e.g. filled checkbox matches macOS behavior).
3. **Figma-style aesthetics third** — Figma-inspired styles (squircle corners, outline-only indicators) are available as opt-in options but are not the default when they conflict with the two priorities above.

#### Example: FondeCheckbox fill style

`FondeCheckboxFillStyle.filled` is the default because:
- A filled background makes checked state perceivable at a glance in high-density desktop UIs (tables, lists).
- Surface fill satisfies `highContrastMode` and `zoomScale` more robustly than stroke weight alone.
- macOS native checkboxes use filled style, aligning with the desktop-first target.

`FondeCheckboxFillStyle.outline` and `.iconOnly` are available for lighter design contexts.

## Design System Architecture

### Package Structure

```
packages/
├── fonde_ui_core/        # Theme, color system, and accessibility foundation
│   └── lib/src/
│       ├── models/       # Data models (FondeThemeData, FondeColorScheme, etc.)
│       ├── providers/    # Riverpod providers (theme_providers, theme_color_providers)
│       ├── color_scope.dart   # ColorScope: area-based color management
│       └── presets.dart       # Theme presets
├── fonde_ui_widgets/     # UI component library
│   └── lib/src/
│       ├── layout/       # FondeScaffold, ResizableSidebarArea, LaunchBarWrapper, etc.
│       ├── launch_bar/   # FondeLaunchBar (launch_bar.dart)
│       ├── toolbar/      # Toolbar, TitleBar variants
│       ├── navigation/   # NavigationItem, Sidebar
│       ├── tab_view/     # FondeTabView, FondeTabBar
│       ├── outline/      # FondeOutlineView
│       ├── master_detail/ # MasterDetailLayout
│       ├── widgets/      # FondePanel, FondeButton, FondeDialog, etc.
│       ├── dialogs/      # FondeConfirmationDialog
│       ├── typography/   # FondeText, TextStyleBuilder
│       ├── spacing/      # FondeSpacing, FondePadding
│       └── styling/      # FondeBorderRadius, FondeBorder
└── fonde_ui/             # Unified package (re-exports fonde_ui_core + fonde_ui_widgets)
```

### Data Flow

```
FondeThemeData → FondeColorScheme → Components
              ↘ FondeAccessibilityConfig → Zoom/Scale Control
```

### State Management

- **Riverpod**: Provider-based state management
- **Theme switching**: Reactive theme changes
- **Providers**:
  - `fondeEffectiveColorScheme` — Retrieves the current color scheme
  - `fondeEffectiveThemeData` — Retrieves the current theme data
  - `FondeAccessibilityConfigNotifier` — Manages accessibility settings

## Design Token Overview

### What Are Design Tokens?

Design tokens are a mechanism for defining and centrally managing the **atomic values** (colors, sizes, spacing, etc.) of a design system. This achieves:

- **Consistency**: Use of unified values across all components
- **Maintainability**: Minimizing the scope of impact when changes are made
- **Extensibility**: Providing a basis for creating new components

### 3-Layer Architecture

```
┌─ Primitive Tokens ─────────────────────┐
│ Definition of basic values             │
│ (gray-500, spacing-16, font-medium)    │
└──────────────↓──────────────────────────┘
┌─ Semantic Tokens ───────────────────────┐
│ Role-based semantic definitions        │
│ (primary, surface, content-padding)    │
└──────────────↓──────────────────────────┘
┌─ Component Tokens ──────────────────────┐
│ Adjustment values for specific         │
│ components (button-padding,            │
│ card-border-radius)                    │
└─────────────────────────────────────────┘
```

### Relationship with Implementation

The following implementations form the basis of design tokens in Fonde UI:

- **`FondeColorScheme`**: Semantic color system (base / uiAreas / interactive / status)
- **`FondeThemeColorScheme`**: Theme colors (primaryColor, etc.)
- **`FondeTextVariant`**: Text style variants (30+)
- **`FondeAccessibilityConfig`**: Zoom/scaling settings
- **`FondeSpacingValues`**: Spacing constants (xs–xxxl)

## 4px Grid System

Fonde UI adopts a **4-pixel based grid system** where all margins and sizes are multiples of this unit.

### Desktop Optimization

- **Efficient space usage**: 32px base instead of 44px for mobile
- **Mouse operation support**: Sizes suitable for precise cursor operations
- **High information density**: Efficient use of vertical space

### Benefits

- Visual unity
- Consistency across different resolutions
- Improved communication efficiency between designers and developers
- Affinity with zoom functionality

---

**Navigation**: [← Back](./README.md) | [Next: Design Tokens →](./02-design-tokens.md)
