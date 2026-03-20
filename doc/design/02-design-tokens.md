# 02. Design Tokens

## Color System

### Light Mode / Dark Mode Support

Fonde UI supports **automatic dark mode switching**, managed uniformly by `FondeColorScheme`.

**Features:**
- Automatic reflection of system settings
- Manual switching support
- 60+ detailed color definitions

### Using the Color Palette

> **Important**: Colors are defined as properties of `FondeColorScheme`. Use semantic property names rather than fixed values. Light/dark mode switching is handled automatically.

```dart
// ✅ Recommended
final colorScheme = ref.watch(fondeEffectiveColorScheme);
final bgColor = colorScheme.base.background;

// ❌ Avoid
final bgColor = Colors.blue; // Hardcoding
```

### Restriction on Alpha Value Usage

**From the perspective of accessibility and design consistency, the use of alpha values is restricted:**

#### Prohibitions
- Setting alpha values with `withAlpha()`, `withOpacity()`, or `Color.fromARGB()`
- Using colors with alpha values other than `Colors.transparent`
- Implementing contrast ratios dependent on background color

#### Reasons
- **Accessibility**: Potential failure to meet WCAG contrast ratio standards
- **Low-vision support**: Difficult to perceive for users with low vision
- **Consistency**: Appearance changes depending on background
- **Maintainability**: Difficult to predict impact when design changes

#### Alternatives
```dart
// ❌ Using alpha
Container(color: Colors.blue.withOpacity(0.3))

// ✅ Defining dedicated colors
Container(color: colorScheme.interactive.button.primaryBackground)
```

### Background Colors

| Level | Purpose | Color Token | Target Areas |
|---|---|---|---|
| **Level 1: Main Background** | Basic content area | `base.background` | Base, panels, dialogs |
| **Level 2: Navigation Background** | Sidebar area | `uiAreas.sideBar.background` | Primary sidebar, launch bar |
| **Level 3: System Background** | Window control area | `uiAreas.titleBar.background` | Title bar, status bar |

#### Color Values (Preset)

| Level | Dark Mode | Light Mode |
|---|---|---|
| **Level 1** | `#1C1C1E` | `#FFFFFF` |
| **Level 2** | `#2C2C2E` | `#F2F2F7` |
| **Level 3** | `#2D2D30` | `#F3F3F3` |

### Text Colors

| Purpose | Color Token |
|---|---|
| Standard text | `base.foreground` |
| Secondary button text | `interactive.button.text` |
| Primary button text | `interactive.button.primaryText` |
| Selected item text | `interactive.list.selectedText` |
| Error text | `status.error` |

### Border Colors

| Purpose | Color Token |
|---|---|
| Standard border | `base.border` |
| Divider line | `base.divider` |
| Panel border | `uiAreas.panel.border` |
| Dialog border | `uiAreas.dialog.border` |
| Focus border | `interactive.input.focusBorder` |
| Title bar border | `uiAreas.titleBar.border` |

### Interaction Colors

| Purpose | Color Token |
|---|---|
| Normal button background | `interactive.button.background` |
| Normal button hover | `interactive.button.hover` |
| Normal button active | `interactive.button.active` |
| Primary button background | `interactive.button.primaryBackground` |
| Destructive button background | `interactive.button.destructiveBackground` |
| Selection background | `base.selection` |
| List hover background | `interactive.list.hoverBackground` |

### Status Colors

| Purpose | Color Token |
|---|---|
| Info | `status.info` |
| Success | `status.success` |
| Warning | `status.warning` |
| Error | `status.error` |
| Loading | `status.loading` |

## Theme Color System

### Concept of Theme Colors

Fonde UI adopts a system similar to **macOS accent colors**, allowing users to select the primary color for the entire application.

**Features:**
- Provides **9 default theme colors** (`FondeThemeColorType`)
- Used for **primary action buttons** and **selection states**
- Color values optimized for both **light and dark modes**
- Emphasizes **consistency with system settings**

### Available Theme Colors

| Theme Color | `FondeThemeColorType` |
|---|---|
| **Blue** | `FondeThemeColorType.blue` |
| **Indigo** | `FondeThemeColorType.indigo` |
| **Violet** | `FondeThemeColorType.violet` |
| **Pink** | `FondeThemeColorType.pink` |
| **Red** | `FondeThemeColorType.red` |
| **Orange** | `FondeThemeColorType.orange` |
| **Yellow** | `FondeThemeColorType.yellow` |
| **Green** | `FondeThemeColorType.green` |
| **Graphite** | `FondeThemeColorType.graphite` |

> Theme colors are selected via `FondeThemeColorType` enum, and appropriate colors are automatically applied for light/dark modes.

### Where Theme Colors Are Used

**Mandatory locations:**
- Primary button background — `interactive.button.primaryBackground`
- Selection state — `base.selection`
- Focus border — `interactive.input.focusBorder`
- Launch bar active item — `uiAreas.launchBar.activeItem`
- Info status — `status.info`

### Retrieving Theme Colors

```dart
// ✅ Recommended: Get color scheme via provider
final colorScheme = ref.watch(fondeEffectiveColorScheme);
final primaryColor = colorScheme.theme.primaryColor;

// ✅ Recommended: Change theme color
ref.read(fondeThemeColorType.notifier).state = FondeThemeColorType.green;
```

### Usage Guidelines

**✅ Recommended uses:**
- Background color of `FondeButton.primary()`
- Primary actions (save, execute, confirm buttons)
- Displaying selection states
- Highlighting important information

**❌ Avoid:**
- Displaying errors or warnings (use `status.error`)
- Destructive operations (use `FondeButton.destructive()`)
- Decorative color usage
- Large area background colors
- Base text colors

## Spacing and Margins

### Spacing Scale

The following scale is **consistently used across all components**:

| Token Name | Value | Example Usage |
|---|---|---|
| **xs** | 4px | Icon spacing |
| **sm** | 8px | Inner element padding |
| **md** | 12px | Component inner margin |
| **lg** | 16px | Section inner margin |
| **xl** | 20px | Special purposes |
| **xxl** | 24px | Section spacing |
| **xxxl** | 32px | Large section spacing |

Constants are provided by the `FondeSpacingValues` class.

### FondeSpacing Widget

`FondeSpacing` is a spacing widget compliant with the 4px grid:

```dart
// ✅ Recommended: Using predefined tokens
Column(
  children: [
    Text('Title'),
    FondeSpacing.verticalLg,   // 16px
    Container(child: content),
    FondeSpacing.verticalXxl,  // 24px
    Text('Next Section'),
  ],
)

// ✅ Directional spacing
Row(
  children: [
    Icon(Icons.star),
    FondeSpacing.horizontalSm, // 8px
    Text('Label'),
  ],
)
```

### FondePadding

`FondePadding` provides predefined padding values:

```dart
// ✅ Recommended: Using predefined tokens
Container(
  padding: FondePadding.md,           // 12px all directions
  child: Text('Content'),
)

// ✅ Directional padding
Container(
  padding: FondePadding.horizontalLg, // 16px left/right only
  child: widget,
)
```

## Typography

### Text Variants (`FondeTextVariant`)

Fonde UI adopts a typography system optimized for specific uses:

#### For UI Elements

| Variant | Purpose |
|---|---|
| `pageTitle` | Page title |
| `dialogTitleCritical` | Critical dialog title |
| `dialogTitleStandard` | Standard dialog title (16px Bold) |
| `dialogTitleUtility` | Utility dialog title |
| `sectionTitlePrimary` | Primary section title |
| `sectionTitleSecondary` | Secondary section title |
| `itemTitle` | Item title |
| `buttonLabel` | Button label |
| `labelText` | Label text |
| `inputText` | Input field text |
| `bodyText` | Body text |
| `captionText` | Caption text |
| `smallText` | Small labels |

#### For Content

| Variant | Purpose |
|---|---|
| `textHeading1` | Document title |
| `textHeading2` | Chapter title |
| `textHeading3` | Section title |
| `textHeading4` | Subsection title |
| `textBody` | Body text |
| `textCaption` | Caption |
| `textSmall` | Supplementary text |
| `codeBlock` | Code block |
| `codeInline` | Inline code |

#### For Tables

| Variant | Purpose |
|---|---|
| `tableTitle` | Table title |
| `tableHeader` | Table header |
| `tableBody` | Table body |
| `tableCell` | Table cell |
| `tableRowHeader` | Row header |

### Implementation

```dart
// ✅ Recommended: Using FondeText component
FondeText(
  'Button Label',
  variant: FondeTextVariant.buttonLabel,
)

// ✅ Recommended: With custom color
FondeText(
  'Error Message',
  variant: FondeTextVariant.captionText,
  color: colorScheme.status.error,
)
```

## Borders, Rounded Corners, and Shadows

### Rounded Corner System

Fonde UI uses corner radii according to the **importance and size of the element**:

| Size | Value | Purpose | Constant |
|---|---|---|---|
| **Small** | 6px | Small elements | `FondeBorderRadius.small` |
| **Medium** | 12px | Standard elements | `FondeBorderRadius.medium` |
| **Large** | 16px | Large elements | `FondeBorderRadius.large` |

> Note: `FondeBorderRadius` uses Figma Squircle shape, which does not directly correspond to `BorderRadius.circular()`.

#### Restriction on Rounded Corner Implementation

**All rounded corner elements must use the `FondeRectangleBorder` component:**

```dart
// ❌ Avoid: Direct BorderRadius usage
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
  ),
)

// ✅ Recommended: Using FondeRectangleBorder
FondeRectangleBorder(
  cornerRadius: FondeBorderRadiusValues.medium, // 12px
  color: colorScheme.base.background,
  child: content,
)
```

#### Reasons
- **Consistency**: Unified design using Figma-like squircle shapes
- **Quality**: High-quality rendering via `figma_squircle`
- **Maintainability**: Centralized management of corner styles

### Border Width (`FondeBorderSide`)

| Name | Value | Purpose |
|---|---|---|
| `FondeBorderSide.thin` | 1px | Normal border |
| `FondeBorderSide.standard` | 1.5px | Accent, focus |
| `FondeBorderSide.thick` | 2px | Emphasis, error state |

### Shadow System

Shadows visually express content hierarchy:

| Level | Purpose |
|---|---|
| **Small** | Buttons, list items |
| **Medium** | Cards, panels, dialogs, popovers |
| **Large** | Modals, overlays |

## Icon System

### Icon Management Policy

Fonde UI ensures visual consistency through a unified icon system.

**Basic principles:**
- Uses `lucide_icons_flutter` as the primary source
- Centrally managed through app-specific icon classes

### Icon Colors

| State | Color |
|---|---|
| Unselected | Same as base text color (`base.foreground`) |
| Selected (Pattern 1) | Highlight icon with primary color |
| Selected (Pattern 2) | Primary color background, white icon |

---

**Navigation**: [← Back](./01-foundations.md) | [Next: Component Specifications →](./03-components.md)
