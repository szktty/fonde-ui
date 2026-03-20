# 07. Button Roles and Sizing

## Button Role System (Apple HIG Compliant)

Fonde UI adopts a button role system compliant with **Apple Human Interface Guidelines**. Each role has specific uses and visual characteristics, promoting intuitive user understanding.

### Available Button Roles

#### Normal Button
```dart
FondeButton.normal(
  label: 'Edit',
  onPressed: () {},
)
```

**Characteristics:**
- **Purpose**: General operations without special meaning
- **Width**: auto (automatically adjusted according to content)
- **Color**: Default color (`colorScope.background`)
- **Padding**: 16px horizontal, 4px vertical

**Example uses:** Edit, View, Details, Settings, etc.

#### Primary Button
```dart
FondeButton.primary(
  label: 'Save',
  onPressed: () {},
)
```

**Characteristics:**
- **Purpose**: The default button most likely to be selected by the user
- **Width**: 120px (fixed)
- **Color**: Theme color (`colorScheme.theme.primaryColor`)
- **Padding**: 4px vertical (no horizontal padding)
- **Enter key support**: Automatically responds to Enter key in dialogs

**Example uses:** Save, Send, Confirm, Next, Complete, Create

#### Cancel Button
```dart
FondeButton.cancel(
  label: 'Cancel',
  onPressed: () {},
)
```

**Characteristics:**
- **Purpose**: Cancel the current action
- **Width**: 100px (fixed)
- **Color**: Default color (`colorScope.background`)
- **Padding**: 4px vertical (no horizontal padding)
- **Escape key support**: Automatically responds to Escape key in dialogs

**Example uses:** Cancel, Close, Back

#### Destructive Button
```dart
FondeButton.destructive(
  label: 'Delete',
  onPressed: () {},
)
```

**Characteristics:**
- **Purpose**: Operations that may lead to data destruction
- **Width**: 120px (fixed)
- **Color**: Error color (`interactive.button.destructiveBackground`)
- **Padding**: 4px vertical (no horizontal padding)
- **Warning color**: Red-based to visually express danger

**Example uses:** Delete, Discard, Reset, Clear

## Sizing Specifications

### Size List by Role

| Role | Width | Height | Horizontal Padding | Vertical Padding |
|---|---|---|---|---|
| **Normal** | auto | 32px | 16px | 4px |
| **Primary** | 120px | 32px | 0px | 4px |
| **Cancel** | 100px | 32px | 0px | 4px |
| **Destructive** | 120px | 32px | 0px | 4px |

### Principles of Size Design

#### 1. Desktop Optimization
- **Minimum height**: 32px (smaller than 44px for touch devices, optimized for desktop)
- **Mouse operation**: Compact size adopted for precise operations

#### 2. Fixed Width Advantages
- **Visual importance**: Wider buttons are perceived as more important
- **Layout stability**: Stable placement in dialogs and forms
- **Consistency**: Buttons of the same role always have the same size

## Color System

### Color Specifications by Role

#### Normal & Cancel
```dart
// Background color (from ColorScope)
backgroundColor: colorScope.background
borderColor: colorScope.border
textColor: colorScope.text

// Interaction
hoverColor: colorScope.hover
pressedColor: colorScope.active
```

#### Primary
```dart
// Background color (using theme color)
backgroundColor: colorScheme.theme.primaryColor
borderColor: colorScheme.theme.primaryColor
textColor: Colors.white

// Interaction (use predefined dedicated colors)
hoverColor: colorScheme.interactive.button.primaryPressedBackground
pressedColor: colorScheme.interactive.button.primaryPressedBackground
```

#### Destructive
```dart
// Background color (using dedicated destructive operation color)
backgroundColor: colorScheme.interactive.button.destructiveBackground
borderColor: colorScheme.interactive.button.destructiveBackground
textColor: colorScheme.interactive.button.destructiveText

// Interaction
pressedColor: colorScheme.interactive.button.destructivePressedBackground
```

### Light / Dark Mode Support

All button roles automatically support light and dark modes:

**Light Mode:**
- Normal/Cancel: Light background, dark text
- Primary: Theme color background, white text
- Destructive: Red background, white text

**Dark Mode:**
- Normal/Cancel: Dark background, light text
- Primary: Theme color background, white text
- Destructive: Red background, white text

## Usage Guidelines

### Recommended Usage Patterns

#### Use in Dialogs
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    FondeButton.cancel(
      label: 'Cancel',
      onPressed: () => Navigator.pop(context),
    ),
    const SizedBox(width: 12),
    FondeButton.primary(
      label: 'Save',
      onPressed: _save,
    ),
  ],
)
```

#### Delete Confirmation Dialog
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    FondeButton.cancel(
      label: 'Cancel',
      onPressed: () => Navigator.pop(context),
    ),
    const SizedBox(width: 12),
    FondeButton.destructive(
      label: 'Delete',
      onPressed: _delete,
    ),
  ],
)
```

### Patterns to Avoid

#### 1. Misuse of Primary Role
```dart
// ❌ Bad example: Using Primary for destructive operations
FondeButton.primary(
  label: 'Delete', // Should use Destructive for destructive operations
  onPressed: _delete,
)

// ✅ Good example
FondeButton.destructive(
  label: 'Delete',
  onPressed: _delete,
)
```

#### 2. Multiple Primary Buttons
```dart
// ❌ Bad example: Multiple Primary buttons
Row(
  children: [
    FondeButton.primary(label: 'Save', onPressed: _save),
    FondeButton.primary(label: 'Send', onPressed: _submit), // Confusing
  ],
)

// ✅ Good example: One Primary + Normal
Row(
  children: [
    FondeButton.normal(label: 'Save Draft', onPressed: _save),
    FondeButton.primary(label: 'Send', onPressed: _submit),
  ],
)
```

### Role Selection Flowchart

```
What is the nature of the operation?
├─ Destroys data → Destructive
├─ Most important/recommended → Primary
├─ Cancel/Close → Cancel
└─ Other general operations → Normal
```

## Implementation Best Practices

### 1. Maintaining Accessibility
```dart
// ✅ Do not disable zoom functionality
FondeButton.primary(
  label: 'Save',
  onPressed: _save,
  // disableZoom: false is automatically applied
)
```

### 2. Appropriate Spacing
```dart
// ✅ Standard spacing between buttons
Row(
  children: [
    FondeButton.cancel(label: 'Cancel', onPressed: onCancel),
    const SizedBox(width: 12), // FondeSpacingValues.md
    FondeButton.primary(label: 'Confirm', onPressed: onConfirm),
  ],
)
```

### 3. Consistent Layout
```dart
// ✅ Right-aligned with Cancel → Primary order
Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    FondeButton.cancel(...),
    const SizedBox(width: 12),
    FondeButton.primary(...),
  ],
)
```

---

**Navigation**: [← Back](./06-development.md) | [Next: MasterDetailLayout Design Specification →](./08-master-detail-layout.md)
