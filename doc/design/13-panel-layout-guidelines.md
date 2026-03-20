# 13. Panel Layout Design Guidelines

## Overview

This document provides layout design guidelines for container-type UI components such as dialogs and panels. It defines basic layout structures and padding specifications to ensure a unified user experience.

## Basic Layout Structure

### Standard 3-Layer Structure

All panel-type components are fundamentally based on the following 3-layer structure:

```
┌─────────────────────────────────────┐
│ Header Area                         │
├─────────────────────────────────────┤
│                                     │
│ Content Area                        │
│                                     │
├─────────────────────────────────────┤
│ Action Area                         │
└─────────────────────────────────────┘
```

### Role of Each Area

#### 1. Header Area
- **Purpose**: Display title, subtitle, and summary information
- **Required element**: Title (`FondeTextVariant.dialogTitleStandard`)
- **Optional element**: Subtitle (`FondeTextVariant.bodyText`)

#### 2. Content Area
- **Purpose**: Display main content, forms, lists, etc.
- **Characteristics**: Scrollable, variable height
- **Constraints**: Uses remaining space after the header and action areas

#### 3. Action Area
- **Purpose**: Primary actions (OK, Cancel, Apply, etc.)
- **Placement**: Right-aligned (macOS style)
- **Button order**: Cancel → Apply → OK (left to right)

## Padding Specifications

### Standard Padding for FondeDialog

| Area | Left/Right Padding | Top/Bottom Padding | Notes |
|---|---|---|---|
| **Header** | 32px (xxxl) | Top: 32px, Bottom: 8px | Title display area |
| **Divider** | 32px (xxxl) | 0px | Between header and content |
| **Content** | 32px (xxxl) | 32px (xxxl) | Main content area |
| **Action** | 16px (lg) | 16px (lg) | Button area |

### Definition of Padding Values

```dart
// Using FondeSpacingValues
static const double xs = 4.0;    // Extra Small
static const double sm = 8.0;    // Small
static const double md = 12.0;   // Medium
static const double lg = 16.0;   // Large
static const double xl = 20.0;   // Extra Large
static const double xxl = 24.0;  // XXL
static const double xxxl = 32.0; // XXXL
```

## Implementation Patterns

### Basic Dialog Implementation

```dart
showFondeDialog<bool>(
  context: context,
  title: 'Dialog Title',
  width: 600,
  height: 400,
  // Uses default padding (32px)
  child: Column(
    children: [
      // Content Area
      Expanded(
        child: SingleChildScrollView(
          child: YourContentWidget(),
        ),
      ),

      // Action Area (with divider)
      Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: colorScheme.base.border,
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(FondeSpacingValues.lg), // 16px
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FondeButton.cancel(
                label: 'Cancel',
                onPressed: () => Navigator.of(context).pop(false),
              ),
              const SizedBox(width: FondeSpacingValues.md), // 12px
              FondeButton.primary(
                label: 'OK',
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
);
```

### Using Custom Padding

```dart
showFondeDialog<bool>(
  context: context,
  title: 'Custom Dialog',
  padding: const EdgeInsets.all(FondeSpacingValues.lg), // 16px
  child: YourCustomContent(),
);
```

## Component-Specific Specifications

### Settings Dialog

```dart
// Recommended implementation pattern
class SettingsDialogContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorScheme);
    return Column(
      children: [
        // Content area (using MasterDetailLayout)
        const Expanded(
          child: SettingsPanel(),
        ),

        // Action area
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: colorScheme.base.border,
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(FondeSpacingValues.lg),
            child: _buildActionButtons(),
          ),
        ),
      ],
    );
  }
}
```

### Form Dialog

```dart
// Padding adjustment specifically for forms
showFondeDialog<bool>(
  context: context,
  title: 'Form Input',
  child: Column(
    children: [
      Expanded(
        child: SingleChildScrollView(
          child: FondeFormList(
            children: [
              // Form elements
            ],
          ),
        ),
      ),
      _buildFormActions(),
    ],
  ),
);
```

## Accessibility Support

### Zoom Support

All padding values are automatically applied with the zoom magnification:

```dart
// FondeDialog automatically supports zoom
final zoomScale = accessibilityConfig.zoomScale;
final scaledPadding = padding * zoomScale;
```

### Keyboard Navigation

- **Tab order**: Header → Content → Action buttons
- **Escape key**: Cancel action
- **Enter key**: Default action (usually OK button)

## Checklist

### Design Review Items

- [ ] Adopted a 3-layer structure (Header, Content, Action)
- [ ] Used appropriate padding values (4px grid compliant)
- [ ] Has a divider line between header and content
- [ ] Action buttons are right-aligned
- [ ] Button spacing is 12px (md)

### Implementation Review Items

- [ ] Used `FondeDialog` or `showFondeDialog`
- [ ] Specified `padding` parameter only when custom padding is required
- [ ] Used `FondeSpacingValues` constants
- [ ] Placed appropriate divider in the action area
- [ ] Supports zoom functionality

## Common Mistakes

### Patterns to Avoid

```dart
// Using magic numbers
padding: const EdgeInsets.all(15), // 4px grid violation

// Inappropriate padding placement
Container(
  padding: const EdgeInsets.all(10), // Duplicate padding within dialog
  child: FondeDialog(...),
)

// Insufficient padding in action area
Row(
  children: [...], // Buttons placed without padding
)
```

### Recommended Patterns

```dart
// Using standard padding
showFondeDialog(
  // Uses default padding (32px)
  child: YourContent(),
)

// Proper action area implementation
Padding(
  padding: const EdgeInsets.all(FondeSpacingValues.lg),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      // Button placement
    ],
  ),
)
```

---

**Navigation**: [← Back](./12-theme-color.md) | [Next: Container-Content Separation →](./14-container-content-separation.md)
