# 09. Color Design Guidelines

## Overview

These guidelines define the rules and recommendations for ensuring consistency and uniformity in color design during the **preset theme design** of Fonde UI. The aim is to achieve a sense of unity with a small number of colors and reduce user discomfort, especially in the design of preset colors for light and dark modes.

## Important Notes

**The scope of these guidelines is very limited:**

- **Target**: Only for **designing** preset themes
- **Not target**: For **using** color schemes during implementation
- **When to refer**: When defining colors inside `FondeColorScheme.fromColorScheme()`
- **When not to refer**: During widget implementation or component development

**When implementing, always use color scheme properties (e.g., `colorScheme.uiAreas.*`).**

## Basic Principles of Preset Theme Design

### 1. Minimize Number of Colors
- **Elite few**: Achieve maximum expressiveness with the minimum necessary number of colors
- **Unity**: Use the same color for elements with the same purpose
- **Hierarchy**: Express visual hierarchy through color lightness and saturation

### 2. Restriction on Transparency
- **Basically prohibited**: Do not apply multiple transparencies to primary colors
- **Exception**: Only `Colors.transparent` is allowed
- **Alternative**: Create dedicated color definitions

### 3. Semantic Color Usage
- **Consistency of meaning**: Use the same color for elements with the same meaning
- **Contextual consideration**: Select appropriate colors according to the usage scenario
- **Accessibility**: Ensure WCAG 2.1 AA compliant contrast ratio

## Color Integration Rules

### Background Color Optimization

#### Background Color Restrictions from an Accessibility Perspective

**Analysis of macOS Standard Apps:**
- **General apps**: Sidebar + content area (**2 types**)
- **Development tools**: Toolbar + sidebar + content area (**3 types**)
- **Recommended upper limit**: **Maximum 3 types**

#### Recommended Background Color Composition (3 types)

| Level | Purpose | Color Token | Integrated Targets |
|---|---|---|---|
| **Level 1: Main Background** | Basic content area | `base.background` | Base, panels, dialogs |
| **Level 2: Navigation Background** | Sidebar area | `uiAreas.sideBar.background` | Primary sidebar, launch bar |
| **Level 3: System Background** | Window control area | `uiAreas.titleBar.background` | Title bar, status bar |

#### Concept of the 3-Level Background Color System

- Level 1 (Main Background): Dialogs, panels, content
- Level 2 (Navigation Background): Primary sidebar, launch bar
- Level 3 (System Background): Title bar, status bar

#### Effects of Integration

**Improved Accessibility:**
- Reduced cognitive load (fewer color types)
- Clearer visual hierarchy
- Consideration for color vision deficiency

**Improved Design Quality:**
- Consistency with macOS standard apps
- Unified appearance
- Improved maintainability

#### Integration Policy during Preset Theme Design

**Background color integration pattern:**
- **Level 1 (Main Background)**: Integrate 3 uses → `base.background`, `uiAreas.panel.background`, `uiAreas.dialog.background`
- **Level 2 (Navigation Background)**: Integrate 2 uses → `uiAreas.sideBar.background`, `uiAreas.launchBar.background`
- **Level 3 (System Background)**: 1 use → `uiAreas.titleBar.background`

**Optimized color values through integration:**

| Level | Dark Mode | Light Mode |
|---|---|---|
| **Level 1** | `#1C1C1E` | `#FFFFFF` |
| **Level 2** | `#2C2C2E` | `#F2F2F7` |
| **Level 3** | `#2D2D30` | `#F3F3F3` |

### Button Color Integration

#### Primary Button
The background color of the primary button will be **the same as the primary color (the theme color)**.

#### Secondary Button
The secondary button will primarily have a **transparent background**, with color displayed only on hover.

### Border Color Integration

#### Basic Border Group
The following borders will use **the same color**:

| Purpose | Color Token | Reason for Integration |
|---|---|---|
| **Basic border** | `base.border` | Standard separator line |
| **Divider** | `base.divider` | Separator between sections |
| **Panel border** | `uiAreas.panel.border` | Outline of panels |
| **Dialog border** | `uiAreas.dialog.border` | Outline of dialogs |

#### Dedicated Border Group
The following borders will use **dedicated colors**:

| Purpose | Color Token | Reason for Dedication |
|---|---|---|
| **Focus border** | `interactive.input.focusBorder` | Clear identification of focus state |
| **Title bar border** | `uiAreas.titleBar.border` | Separation of window area |

### Icon Color Integration

#### Basic Principle
Icon colors are used in two patterns depending on the **UI context**:

#### Icon Color When Not Selected
Uses **the same color as the basic text**.

#### Icon Color When Selected (2 Patterns)

**Pattern 1: Make icon color the primary color**
- Background remains transparent or normal color
- Only the icon is highlighted with the primary color

**Pattern 2: Make background color the primary color**
- Background set to primary color
- Icon color is white (ensures high contrast)

#### Usage Guidelines

**When to use Pattern 1:**
- Tab navigation
- Toolbar icon buttons
- List item icons
- Display of minor selected states

**When to use Pattern 2:**
- Selected items in the launch bar
- Important action states
- When strong visual emphasis is needed
- Expression of brand identity

### Text Color Integration

#### Basic Text Group
The following text colors will use **the same color**:

| Purpose | Color Token | Reason for Integration |
|---|---|---|
| **Basic text** | `base.foreground` | Standard text color |
| **Panel text** | `uiAreas.panel.foreground` | Text within panels |
| **Dialog text** | `uiAreas.dialog.foreground` | Text within dialogs |
| **Button text** | `interactive.button.text` | Text of secondary buttons |

#### Dedicated Text Group
The following text colors will use **dedicated colors**:

| Purpose | Color Token | Reason for Dedication |
|---|---|---|
| **Primary button text** | `interactive.button.primaryText` | Ensures high contrast |
| **Selected item text** | `interactive.list.selectedText` | Clear identification of selected state |
| **Error text** | `status.error` | Clear identification of status |

## Theme Color Application Rules in Preset Themes

### Concept of Primary Color

**Preset theme design philosophy:**
- **Preset themes**: Use theme color as the primary color
- **User experience**: The primary color is not just aesthetics—it is an important color that carries meaning in the user experience

### Primary Color Usage Locations

The primary color (`colorScheme.theme.primaryColor`) is **uniformly used** in the following locations:

#### Mandatory Application Locations
1. **Primary button background** — `interactive.button.primaryBackground`
2. **Selection state display** — `base.selection`
3. **Focus border** — `interactive.input.focusBorder`
4. **Launch bar active item** — `uiAreas.launchBar.activeItem`
5. **Info display** — `status.info`

### Prohibition of Primary Color Processing

**Reasons:**
- The primary color holds special meaning in the user experience
- To provide a consistent brand experience
- To ensure design integrity when supporting custom themes in the future

**Processing to avoid:**
- Applying transparency (`withAlpha`, `withOpacity`)
- Changing lightness (`lighten`, `darken`)
- Changing saturation (`saturate`, `desaturate`)

**Alternatives:** For hover effects, selection states, and disabled states, predefine dedicated colors.

### Immutability of Primary Color

**Important principle**: The primary color is used **without any processing**.

## Preset Theme Design Checklist

### Check Items Before Adding New Colors

1. **Reusability of existing colors**
   - [ ] Check if there are existing colors for the same purpose
   - [ ] Check if similar semantic colors are defined
   - [ ] Check if there are color groups that can be integrated
   - [ ] Check if background colors fit within 3 types

2. **Necessity of transparency**
   - [ ] Consider if it can be achieved without transparency
   - [ ] Consider if it can be replaced with a dedicated color definition
   - [ ] Check impact on accessibility

3. **Primary color processing**
   - [ ] Check that primary colors are not processed
   - [ ] If derived colors are needed, consider dedicated color definitions

4. **Semantic meaning**
   - [ ] Is the meaning of the color clearly defined?
   - [ ] Are the relationships with other colors organized?
   - [ ] Is it appropriate for both light and dark modes?

### Code Review Check Items

1. **Color usage during implementation**
   - [ ] Are `FondeColorScheme` properties used?
   - [ ] Are there no hardcoded color values?
   - [ ] Is this guideline not referenced during implementation (should only be referenced during preset theme design)?

2. **Color usage during preset theme design**
   - [ ] Is transparency (`withAlpha`, `withOpacity`) not used?
   - [ ] Is the primary color not processed (`lighten`, `darken`, etc.)?

3. **Compliance with integration rules during preset theme design**
   - [ ] Does the background color follow the 3-level structure?
   - [ ] Do button colors follow the integration rules?
   - [ ] Do border colors follow the integration rules?
   - [ ] Is icon color usage appropriate (basic text color for unselected, 2 patterns for selected)?
   - [ ] Is it consistent with macOS standard apps?

4. **Primary color application during preset theme design**
   - [ ] Is the primary color used for primary actions?
   - [ ] Is the primary color used for selection states?
   - [ ] Is the primary color used for focus states?
   - [ ] Is the primary color used without any processing?

## References

**Refer only during preset theme design:**
- [02. Design Tokens](./02-design-tokens.md) — Detailed color system specifications
- [05. Accessibility](./05-accessibility.md) — Contrast ratio and accessibility requirements

**Refer during implementation:**
- [03. Component Specifications](./03-components.md) — Implementation guidelines for each component
- `FondeColorScheme` class documentation — How to use color scheme properties

### Rationale for Background Color Optimization

**macOS Human Interface Guidelines:**
- Background colors are used to express functional hierarchy
- Excessive number of colors increases cognitive load
- Consistency with system standard apps is important

**Accessibility Research:**
- Approximately 8% of colorblind individuals (men) have difficulty distinguishing multiple colors
- When the number of background colors is 3 or fewer, cognitive load is significantly reduced
- Hierarchy expression through lightness difference is most effective

---

**Navigation**: [← Back](./08-master-detail-layout.md) | [Next: Theme Colors →](./12-theme-color.md)
