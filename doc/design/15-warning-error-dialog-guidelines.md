# 15. Warning/Confirmation Dialog Guidelines

## Overview

This document provides design guidelines for warning/confirmation dialogs and error dialogs. It defines design specifications for communicating important information to users, prompting careful judgment, and properly displaying error information.

## Characteristics of Warning Dialogs

Warning dialogs are important UI components that alert users to actions and request confirmation.

### Use Cases
- **Destructive operations**: Delete, archive, reset, etc.
- **Important changes**: Settings changes, data migration, etc.
- **Irreversible operations**: Send, publish, confirm, etc.
- **Risky operations**: Security-related, permission changes, etc.

## Characteristics of Error Dialogs

Error dialogs are UI components that notify users of unexpected errors or operational failures and provide appropriate remedies.

### Use Cases
- **Operational failures**: File read failure, network error, etc.
- **System errors**: Database connection error, insufficient memory, etc.
- **Validation errors**: Invalid input, format errors, etc.
- **Permission errors**: Access denied, authentication failure, etc.

## Design Specifications

### Title Design

Warning dialog titles use a more subdued typography (`FondeTextVariant.dialogTitleStandard`, 16px Bold) than regular dialog titles. Overly large titles (e.g., `dialogTitleCritical`, 28px) should be avoided as they create unnecessary pressure on the user.

### Layout Structure

Warning and error dialogs recommend a layout structure that separates icons and content. This improves information visibility and structural clarity.

**Recommended Layout:**

```
┌──────────────────────────────────────────┐
│                                          │
│  [Icon]   Header Area                    │
│           • Title                        │
│                                          │
│           Content Area                   │
│           • Message Body                 │
│           • Detailed Information         │
│                                          │
│           Action Area                    │
│           • Buttons                      │
│                                          │
└──────────────────────────────────────────┘
```

**Components:**

1. **Icon Area (Left Side)**:
   - Place an icon that immediately conveys the type of dialog (warning, error).

2. **Content Area (Right Side)**:
   - **Header**: Place the dialog title (`FondeTextVariant.dialogTitleStandard`).
   - **Content**: Describe detailed messages, scope of impact, error information, etc.
   - **Action**: Place buttons (`FondeButton`) for user actions.

**Key Points:**
- **Alignment**: Elements within the content area (title, body, buttons) are left-aligned.
- **Separation**: The icon area and content area are separated by appropriate spacing (16px).
- **Border**: No horizontal border is displayed between the header and content; visual separation is achieved with whitespace.

### Padding Specifications

Standard dialog padding is used:

| Area | Left/Right Padding | Top/Bottom Padding | Notes |
|---|---|---|---|
| **Header** | 32px (xxxl) | Top: 32px, Bottom: 8px | Title display area |
| **Content** | 32px (xxxl) | 32px (xxxl) | Warning/error details area |
| **Action** | 16px (lg) | 16px (lg) | Button area |

### Size Specifications

| Item | Specification | Notes |
|---|---|---|
| **Minimum height** | 200px | Auto-expands according to content |
| **Maximum height** | No limit | Auto-adjusts according to content |
| **Minimum width** | 400px | Desktop standard |
| **Maximum width** | 600px | Considering readability |

## Content Design

### Structure of Warning Messages

Warning messages consist of the following three elements:

1. **Clear identification of target**: Clearly indicate what the operation target is.
   - Example: `Archiving "my-project-stack" will:`
2. **Explanation of impact**: Explain specifically what will happen, using bullet points or similar clear formats.
   - Example:
     - It will no longer appear in the stack collection.
     - It will become deletable.
3. **Recoverability**: Clearly state whether the operation can be undone.
   - Example: `However, you can always undo it.`

### Style of Warning Items

Each item in a warning message is displayed in standard body text (`FondeTextVariant.bodyText`) to ensure readability.

## Error Dialog Specific Design

### Structure of Error Messages

Error dialogs are composed of the following elements to clearly communicate the situation to the user:

1. **Error title**: Briefly display the summary of the problem.
2. **Basic message**: Explain the error content in plain language that the user can understand.
   - Example: `An error occurred while opening "my-project-stack".`
3. **Error details (optional)**: Provide technical detailed information, collapsed by default.

### Collapsible Error Details Tile

Technical detailed information is primarily for error reporting to developers. It is unnecessary for general users, and to avoid confusion, it is **extremely important to display it collapsed by default**. Use `FondeExpansionTile` to allow only necessary users to expand the information.

The expanded area should include the following elements:

- **Error detail text**:
  - Use a monospace font to improve readability.
  - Allow users to select and copy the content.
- **Copy button**:
  - Provide functionality to copy error details and related information to the clipboard.

### Error Details Copy Function

The copy function should include not only the error message but also the following system information useful for debugging:

- **Error details**: Such as the stack trace of the displayed error.
- **System information**: OS, version, architecture.
- **Application information**: App version, build number, error timestamp.

This allows developers to quickly and accurately reproduce the situation from error reports.

## Button Design

### Button Placement and Roles

#### Button Placement in Warning Dialogs

In warning dialogs, button placement and roles are clearly defined to prevent users from performing unintended operations.

- **Cancel button**: Placed on the left, applies `FondeButton.cancel` style. Provides a clear option for the user to abort the operation.
- **Execute button**: Placed on the right. Use `FondeButton.primary` or `FondeButton.destructive` depending on the nature of the operation.
- **Spacing**: Standard spacing between buttons is `12px` (md).

#### Button Placement in Error Dialogs

Error dialogs primarily serve to notify users of information, so typically only an `OK` button is placed on the far right. The `FondeButton.primary` style is used.

### Guidelines for Selecting Button Roles

#### Warning Dialogs

| Nature of Operation | Recommended Button Role | Example |
|---|---|---|
| **General confirmation** | `FondeButton.primary` | Save, Send, Apply |
| **Destructive operation** | `FondeButton.destructive` | Delete, Reset |
| **Reversible operation** | `FondeButton.primary` | Archive, Move |

#### Error Dialogs

| Nature of Dialog | Recommended Button Role | Example |
|---|---|---|
| **General error** | `FondeButton.primary` | OK |
| **Critical error** | `FondeButton.primary` | OK (color unchanged) |
| **Information provision** | `FondeButton.primary` | OK, Got it |

## Implementation

### Using FondeConfirmationDialog

Use `FondeConfirmationDialog` for warning/confirmation dialogs:

```dart
showFondeConfirmationDialog(
  context: context,
  message: 'Archiving "my-project" will:',
  warningItems: [
    'It will no longer appear in the stack collection.',
    'It will become deletable.',
  ],
  confirmLabel: 'Archive',
  cancelLabel: 'Cancel',
  isDestructive: false, // false for reversible operations
  onConfirm: () => archiveProject(),
);
```

### Delete Confirmation Example

```dart
showFondeConfirmationDialog(
  context: context,
  message: '"my-project" will be permanently deleted. This action cannot be undone.',
  warningItems: [
    'All data will be permanently deleted.',
    'Related settings will also be deleted.',
  ],
  confirmLabel: 'Delete',
  cancelLabel: 'Cancel',
  isDestructive: true, // true for irreversible operations
  onConfirm: () => deleteProject(),
);
```

## Accessibility Support

### Keyboard Operation

To ensure keyboard-only operation, the following standard behaviors are implemented:

- **Escape key**: Closes the dialog (cancel action).
- **Enter key**: Executes the default action (usually the execute button).
- **Tab key**: Focus moves through dialog elements (title, content, buttons) in logical order.

---

**Navigation**: [← Back](./14-container-content-separation.md) | [Top: README](./README.md)
