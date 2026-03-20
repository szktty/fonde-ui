# 14. Container-Content Separation Design Principles

## Overview

This document defines the design philosophy of **"container" and "content" separation** in Fonde UI. This principle aims to achieve both a sophisticated macOS-like UI and high information density.

## Core Idea

### Design Philosophy

Following macOS UI design philosophy, UI elements are clearly classified into **"container"** and **"content"**, and appropriate padding strategies are applied to each.

```
"Is this element information that the user directly interacts with or views?"

→ Yes: Content (sufficient padding)
→ No:  Container (minimal padding)
```

### Core Principles
- **Container**: Structural elements that define the UI framework → **Minimal padding**
- **Content**: Information elements that the user interacts with or views → **Sufficient padding**

## Container

### Definition
A structural element that defines the UI's framework and serves to position and separate other elements.

### Characteristics
- **Padding**: Minimal in principle (often zero)
- **Purpose**: To reach the edges of windows and panels, clarifying the structure
- **Visual effects**: Boundaries and background colors are used to delineate areas

### Representative Examples

| UI Element | Description | Padding Strategy |
|---|---|---|
| **Toolbar** | Operational area at the top of the window | Padding only for internal elements |
| **Sidebar** | Navigation/list display area | List items extend to the edge |
| **Window Frame** | Outermost shell of the application | Managed by OS; app does not intervene |
| **Panel Boundary** | Outer frame of settings panels, inspectors | Internal content manages padding |
| **Divider** | Boundary between sections | The line itself has no padding |

### Implementation Pattern
```dart
// ✅ Container implementation example
Container(
  // No padding — extends to the boundary
  decoration: BoxDecoration(
    border: Border(bottom: BorderSide(...)),
  ),
  child: Row(
    children: [
      // Internal elements manage padding individually
      Padding(
        padding: EdgeInsets.symmetric(horizontal: FondeSpacingValues.lg),
        child: IconButton(...),
      ),
    ],
  ),
)
```

## Content

### Definition
Information elements that the user directly interacts with, views, or inputs.

### Characteristics
- **Padding**: Sufficient margins are ensured
- **Purpose**: To improve readability, usability, and focus
- **Visual effects**: Provides "breathing room"

### Representative Examples

| UI Element | Description | Padding Strategy |
|---|---|---|
| **Form** | Group of input fields | Appropriate spacing for each item |
| **Inspector Content** | Property editing controls | Organized with grouping and margins |
| **Dialog Content** | Text/buttons within a modal | Margins prioritized for readability |
| **List Item Content** | Icon, text, button | Appropriate placement within the item |

### Implementation Pattern
```dart
// ✅ Content implementation example
Container(
  padding: EdgeInsets.all(FondeSpacingValues.lg), // 16px
  child: Column(
    children: [
      FondeText('Text for the user to read', variant: FondeTextVariant.bodyText),
      const SizedBox(height: FondeSpacingValues.md), // 12px
      FondeTextField(...),
    ],
  ),
)
```

## Specific Padding Values

### 4px Grid System Compliant

| Usage Category | Recommended Value | Token | Example Usage |
|---|---|---|---|
| **Container internal** | 0px | — | Toolbar, sidebar outer frame |
| **Container element** | 8–12px | sm–md | Toolbar internal buttons, within list items |
| **Content basic** | 16px | lg | Forms, inspector, general content |
| **Content important** | 24–32px | xxl–xxxl | Dialogs, main editor |

### Detailed Specifications by Layout

#### Dialogs / Panels
```dart
// Header / Content area
padding: EdgeInsets.all(FondeSpacingValues.xxxl), // 32px

// Action area
padding: EdgeInsets.all(FondeSpacingValues.lg),   // 16px
```

#### Toolbar
```dart
// Toolbar itself: No padding
// Padding only for internal elements
padding: EdgeInsets.symmetric(
  horizontal: FondeSpacingValues.md, // 12px
  vertical: FondeSpacingValues.sm,   // 8px
),
```

#### Sidebar
```dart
// Sidebar itself: No padding
// Padding only for content within list items
padding: EdgeInsets.symmetric(
  horizontal: FondeSpacingValues.md, // 12px
  vertical: FondeSpacingValues.sm,   // 8px
),
```

#### Inspector / Forms
```dart
// Overall padding
padding: EdgeInsets.all(FondeSpacingValues.lg), // 16px

// Spacing between items
const SizedBox(height: FondeSpacingValues.md),  // 12px
```

## Visual Judgment Criteria

### Container Characteristics
- **Extends to boundary**: Touches the edge of the window/panel
- **Structural role**: Positions and organizes other elements
- **Background / Border**: Clearly defines area separation

### Content Characteristics
- **Surrounded by whitespace**: Has breathing room around it
- **Informational role**: Information that the user consumes or interacts with
- **Focusable**: Often directly interactable by the user

## Practical Decision Flow

### Step 1: Identify Element Role
```
What is the primary purpose of this element?
├─ To position/separate other elements → Container
└─ To display information/receive input → Content
```

### Step 2: Confirm Relationship with User
```
How does the user relate to this element?
├─ Does not directly interact (only views/passes through) → Container
└─ Directly interacts (reads/inputs/clicks) → Content
```

### Step 3: Determine Padding Strategy
```
Container → Minimal padding (often 0px)
Content → Sufficient padding (16px–32px)
```

## Implementation Checklist

### Design Review Items
- [ ] Have UI elements been categorized as container/content?
- [ ] Do container elements extend to the boundary?
- [ ] Do content elements have sufficient margins?
- [ ] Is it compliant with the 4px grid system?

### Code Implementation Review Items
- [ ] Are `FondeSpacingValues` constants used?
- [ ] Is excessive padding not set on containers?
- [ ] Is content readability and usability ensured?
- [ ] Is a consistent padding strategy applied?

## Common Mistakes

### Patterns to Avoid

```dart
// Excessive padding on a container
Container(
  padding: EdgeInsets.all(20), // Unnecessary padding on toolbar
  child: Toolbar(...),
)

// Insufficient padding for content
Container(
  padding: EdgeInsets.all(4), // Insufficient padding for text area
  child: TextContent(...),
)
```

### Recommended Patterns

```dart
// Container: Focus on structure
Container(
  decoration: BoxDecoration(border: ...),
  child: Row(
    children: [
      // Internal elements manage padding individually
      Padding(
        padding: EdgeInsets.symmetric(horizontal: FondeSpacingValues.md),
        child: FondeButton.normal(...),
      ),
    ],
  ),
)

// Content: Sufficient margins
Container(
  padding: EdgeInsets.all(FondeSpacingValues.lg), // 16px
  child: Column(
    children: [
      FondeText('Easy-to-read text', variant: FondeTextVariant.bodyText),
      FondeTextField(...),
    ],
  ),
)
```

## Expected Effects

### Improved User Experience
- **Clear structure**: UI hierarchy is intuitively understood
- **Improved usability**: Content is placed in an easy-to-operate position
- **Visual comfort**: Reduced fatigue due to appropriate margins

### Improved Development Efficiency
- **Consistent decision criteria**: Reduced ambiguity in padding settings
- **Improved maintainability**: Clear design intent makes modifications easier
- **Improved quality**: Achieves a sophisticated macOS-like UI

---

**Navigation**: [← Back](./13-panel-layout-guidelines.md) | [Next: Warning/Confirmation Dialog Guidelines →](./15-warning-error-dialog-guidelines.md)
