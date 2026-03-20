# 12. Theme Colors

## Purpose

This document defines the guidelines for the color palette used throughout Fonde UI applications. The purposes are as follows:

- **Ensure Accessibility**: Meet WCAG (Web Content Accessibility Guidelines) standards and provide a UI that all users can comfortably use.
- **Design Consistency**: Apply a unified color scheme throughout the application to achieve a consistent user experience.
- **Support Light and Dark Modes**: Define a color scheme that maintains visibility and design quality in both display modes.

## Basic Principles

The application's color scheme consists of colors with the following three roles:

1. **Background Color**: The basic background color that occupies the widest area of the UI.
2. **Text Color**: The color of text that ensures content readability.
3. **Theme Color**: An accent color used to encourage user interaction, such as for buttons, icons, and active elements.

When using these colors, the principle is to **not adjust transparency** and to use the defined hex code values directly.

## Color Palette

### Background Color and Text Color

To avoid the impression of standard Flutter Material Design and aim for a more neutral, web-like design, the Bootstrap color scheme was used as a reference for selection.

- **Light Mode Background**: `#F8F9FA` (off-white)
- **Dark Mode Background**: `#212529` (dark gray)

By using inverse colors for the text colors against their respective mode's background colors, a very high contrast ratio of **15.5:1** is ensured, achieving optimal readability.

| Mode | Role | Hex Code |
| :--- | :--- | :--- |
| **Light Mode** | Background Color | `#F8F9FA` |
| | Text Color | `#212529` |
| **Dark Mode** | Background Color | `#212529` |
| | Text Color | `#F8F9FA` |

### Theme Color Palette (`FondeThemeColorType`)

Nine selectable palettes are provided. Each color is adjusted to the optimal hue, saturation, and lightness for both light and dark modes, giving a bright and attractive impression in either mode.

#### Selection Criteria

- **UI Component Accessibility**: Each theme color is adjusted to meet the WCAG contrast ratio standard of **3:1** for UI components (icons, buttons, indicators, etc.) against the background color of its respective mode.
- **Optimization for Each Mode**:
    - **Light Mode**: Ensures a `3:1` contrast ratio against the background color (`#F8F9FA`) while adopting deeper, more vibrant colors.
    - **Dark Mode**: Ensures a `3:1` contrast ratio against the background color (`#212529`) while adopting brighter, more vibrant colors.

#### Theme Color Table

| Color | Light Mode Hex | Dark Mode Hex | `FondeThemeColorType` |
| :--- | :--- | :--- | :--- |
| **Red** | `#E55353` (3.50:1) | `#FF6B6B` (5.56:1) | `.red` |
| **Orange** | `#D97422` (3.01:1) | `#FFA96B` (8.18:1) | `.orange` |
| **Yellow** | `#B58D09` (3.01:1) | `#FFD46B` (10.93:1) | `.yellow` |
| **Green** | `#36A369` (3.02:1) | `#53D18B` (7.98:1) | `.green` |
| **Blue** | `#3B8AD1` (3.47:1) | `#5CA5E6` (5.86:1) | `.blue` |
| **Indigo** | `#6360CF` (4.85:1) | `#8B88FF` (5.19:1) | `.indigo` |
| **Violet** | `#9655AB` (4.76:1) | `#C079D9` (5.13:1) | `.violet` |
| **Pink** | `#E553A0` (3.28:1) | `#FF6BAA` (5.83:1) | `.pink` |
| **Graphite** | `#868E96` (3.15:1) | `#BCC2C8` (8.59:1) | `.graphite` |

## Usage Guidelines

- Theme colors should primarily be used for **interactive elements** such as buttons, icons, and active UI elements.
- When using theme colors as text color or placing text on a theme color background, it is necessary to check the contrast ratio separately. A contrast ratio of **4.5:1 or higher** is recommended for normal text, so the colors in this palette may not always be suitable.
- The basic structure of the application should be composed of "background color" and "text color", and "theme colors" should be effectively used as accent colors to guide user actions.

### Retrieving Theme Colors

```dart
// ✅ Recommended: Get theme colors via provider
final colorScheme = ref.watch(fondeEffectiveColorScheme);
final primaryColor = colorScheme.theme.primaryColor;

// ✅ Recommended: Change theme color
ref.read(fondeThemeColorType.notifier).state = FondeThemeColorType.green;
```

### Theme Color Variations

`FondeThemeColorScheme` provides the following properties:

```dart
// Base color
colorScheme.theme.primaryColor  // The theme's base color

// Interaction colors (predefined as dedicated colors)
colorScheme.interactive.button.primaryBackground        // Primary button background
colorScheme.interactive.button.primaryPressedBackground // Pressed state background
colorScheme.base.selection                              // Selection state background
```

---

**Navigation**: [← Back](./09-color-design-guidelines.md) | [Next: Panel Layout Design Guidelines →](./13-panel-layout-guidelines.md)
