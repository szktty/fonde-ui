# 03. Component Specifications

## Interactive Components

### FondeButton

**Dimensions / Spacing**
- Minimum height: 32px (desktop optimized)
- Horizontal padding: 16px (lg) — Normal only
- Vertical padding: 4px
- Icon spacing: 4px (xs)

**Visual Style**
- Border: 1.5px
- Rounded corners: 12px (medium)
- Font: `FondeTextVariant.buttonLabel`

**Role Specifications**

| Role | Width | Background | Key Support |
|---|---|---|---|
| `FondeButton.normal()` | auto | `colorScope.background` | — |
| `FondeButton.primary()` | 120px | Theme color | Enter key |
| `FondeButton.cancel()` | 100px | `colorScope.background` | Escape key |
| `FondeButton.destructive()` | 120px | `interactive.button.destructiveBackground` | — |

**State Management**
- **Normal**: `background`, `border`, `text`
- **Hover**: `hover`
- **Press**: `active`
- **Focus**: `interactive.input.focusBorder`
- **Disabled**: `disabled`

### FondeDropdownMenu

**Dimensions / Spacing (Compliant with FondeButton)**
- Minimum height: 32px
- Horizontal padding: 16px (lg)
- Vertical padding: 6px
- Rounded corners: 12px

**Visual Characteristics**
- **Overlay menu**: Design that completely covers the button when open
- **Checkmark**: Displays a check icon for the selected item
- **Hover effect**: Background color change on menu item hover

**Technical Specifications**
- Border width: 1.5px
- Chevron icon size: 16px
- Check icon size: 12px

### FondeSegmentedButton

**Dimensions / Spacing**
- Border: 1.5px
- Animation: Disabled (`animationDuration: Duration.zero`)

**Colors**
- Background: `uiAreas.sideBar.background`
- Selected background: `interactive.list.selectedBackground`
- Border: Theme color

## Input Components

### FondeTextField

**Dimensions / Spacing**
- Height: 32px (desktop standard)
- Horizontal padding: 16px (lg)
- Vertical padding: 6px
- Rounded corners: 12px (medium)

**Visual Style**
- Normal border: 1.5px
- Focus border: 2px

**State Management**
- **Normal**: `interactive.input.border`
- **Focus**: `interactive.input.focusBorder`
- **Error**: `status.error`
- **Disabled**: `interactive.input.border` (reduced opacity)

**Implementation Restrictions**
- `InputDecoration` is not supported; use dedicated properties instead
- Available properties: `hintText`, `errorText`, `prefixIcon`, `suffixIcon`

### FondeCheckbox

**Dimensions**
- Size: 20px (5×4px units)
- Rounded corners: 4px (xs)
- Border: 1px

**Visual**
- Color: Theme color (`colorScheme.theme.primaryColor`)

## Container Components

### FondePanel

A container widget that defines a panel area.

**Visual Style**
- Background: `uiAreas.panel.background`
- Border: `uiAreas.panel.border`

**Use Cases**
- Inspector panels
- Side panels
- Content groups

### FondeContainer

**Layout**
- Horizontal padding: 16px (lg)
- Vertical padding: 8px (sm)
- `leadingWidget` width: 16px (lg) (default)

**Background Color**
- Default background: Sidebar background (theme auto-applied)
- Custom background: Can be overridden with the `color` property

**Recommended Use**
- Prefer `FondeContainer` over `Container` in design-guideline-compliant areas
- Provides unified padding and automatic theme-responsive background

### FondeRectangleBorder

A rounded corner container using Figma Squircle shape.

**Key Properties**

| Property | Type | Default | Description |
|---|---|---|---|
| `cornerRadius` | `double?` | `12.0` | Corner radius |
| `cornerSmoothing` | `double?` | `0.6` | Corner smoothness (fixed) |
| `side` | `BorderSide?` | standard (1.5px) | Border style |
| `color` | `Color?` | `null` | Background color |
| `padding` | `EdgeInsetsGeometry?` | `null` | Inner padding |

## Form Components

### FondeFormList

A component for organizing section lists in settings screens and forms.

**Dimensions / Spacing**
- Header padding: 8px (sm) bottom (default)
- Item spacing: 8px (sm)
- Bottom padding: 8px (sm)
- Label width: 200px (default, customizable)

**Structure**
- **Header row**: Title (left) + right widget (right, optional)
- **Children**: List of `FondeFormItemRow`/`FondeFormItemColumn`, or a single child

**Visual Style**
- Title font: `FondeTextVariant.sectionTitlePrimary`
- Title font weight: **Bold**

```dart
// ✅ Recommended: List of FormItemRows
FondeFormList(
  title: 'Account Settings',
  labelWidth: 200,
  children: [
    FondeFormItemRow(label: 'Username', child: TextField()),
    FondeFormItemRow(label: 'Email Address', child: TextField()),
  ],
)

// ✅ Recommended: Single child
FondeFormList(
  title: 'Other Settings',
  rightWidget: IconButton(icon: Icon(Icons.add)),
  child: CustomSettingsWidget(),
)
```

### FondeFormItemRow

A form item that places a label and control side by side.

**Dimensions / Spacing**
- Label width: 200px (default, customizable)
- Spacing between label and control: 16px (lg)
- Description text top space: 4px (xs)

**Visual Style**
- Label font: `FondeTextVariant.bodyText`
- Description font: `FondeTextVariant.captionText`
- Vertical alignment: Center

**Usage Guidelines**
- **Generally avoid using `description`**: Ensure the label sufficiently explains the content
- If a description is needed, consider changing to a clearer label name

```dart
// ✅ Recommended: Basic usage (without description)
FondeFormItemRow(
  label: 'Theme Color',
  child: DropdownButton<ThemeColor>(...),
)

// ❌ Avoid: Unnecessary description
FondeFormItemRow(
  label: 'Dark Mode',
  description: 'Automatically switches according to system settings', // Should be expressed in label
  child: Switch(value: isDarkMode, onChanged: onChanged),
)
```

### FondeFormItemColumn

A form item that places a label and control vertically.

**Structure**
- Label → Control (vertical)
- Spacing: Customizable

## Display Components

### FondeTag

A tag display component.

**Dimensions / Spacing**
- Horizontal padding: 12px (md)
- Vertical padding: 4px (xs)
- Rounded corners: 16px (large)
- Border: 1px

**Visual Style**
- Background: Light version of the specified color (avoid alpha; define dedicated colors)
- Text: Specified color

### FondeDivider / FondeVerticalDivider

Separator line components.

**Dimensions**
- Thickness: Customizable (default 1px)
- Standard horizontal divider: `FondeDivider`
- Standard vertical divider: `FondeVerticalDivider` (2px)

**Responsibility for Spacing**

`FondeDivider` is solely responsible for "drawing a line"; surrounding spacing is managed by the caller.

```dart
// ✅ Recommended: Manual layout with proper spacing
Column(
  children: [
    widget1,
    FondeSpacing.verticalLg,  // 16px
    FondeDivider(),
    FondeSpacing.verticalLg,  // 16px
    widget2,
  ],
)

// ❌ Avoid: Direct placement without spacing (visually too dense)
Column(children: [widget1, FondeDivider(), widget2])
```

## Layout Components

### FondeScaffold / FondeWorkspaceLayout

The application-wide shell layout.

**Components**
- Launch bar (`FondeLaunchBar`)
- Resizable sidebar area (`ResizableSidebarArea`)
- Main content area
- Status bar

### FondeLaunchBar

The navigation bar on the left side of the application.

**Structure**
- `topItems`: Top navigation items
- `bottomItems`: Bottom navigation items
- `selectedIndex`: Index of the currently selected item

**FondeLaunchBarItem Properties**
- `icon`: Icon
- `label`: Label text
- `logicalIndex`: Logical index
- `badge`: Badge (optional)

### ResizableSidebarArea

A resizable sidebar area.

**Features**
- Drag to resize
- Min/max width constraints
- Collapsible

### FondeDialog / showFondeDialog

A modal dialog component.

**Structure (3 layers)**
1. Header area — Title, subtitle
2. Content area — Main content (scrollable)
3. Action area — Buttons (right-aligned)

**Padding Specifications**
- Header: 32px left/right, 32px top, 8px bottom
- Content: 32px all directions
- Action: 16px all directions

See [13. Panel Layout Design Guidelines](./13-panel-layout-guidelines.md) for details.

### FondeConfirmationDialog

A warning/confirmation dialog.

**Properties**
- `message`: Message body
- `warningItems`: List of warning items
- `onConfirm`: Confirm callback
- `onCancel`: Cancel callback
- `confirmLabel`: Confirm button label
- `cancelLabel`: Cancel button label
- `isDestructive`: Whether it is a destructive operation (uses destructive style when true)

```dart
showFondeConfirmationDialog(
  context: context,
  message: 'Archiving this stack will:',
  warningItems: [
    'It will no longer appear in the stack collection.',
    'It will become deletable.',
  ],
  confirmLabel: 'Archive',
  isDestructive: false,
  onConfirm: () => archiveStack(),
);
```

## Component-Specific Spacing Specifications

### Button Components

| Component | Horizontal | Vertical | Height |
|---|---|---|---|
| `FondeButton` (Normal) | 16px (lg) | 4px | 32px |
| `FondeButton` (Primary/Cancel/Destructive) | — | 4px | 32px |
| `FondeIconButton` | 8px (sm) | 8px (sm) | 32px |

### Container Components

| Component | Horizontal | Vertical | Notes |
|---|---|---|---|
| `FondeContainer` | 16px (lg) | 8px (sm) | leadingWidget support |
| `FondeDialog` | 32px (xxxl) | 32px (xxxl) | Rounded corners: 16px |

### Input Components

| Component | Horizontal | Vertical | Height | Rounded Corners |
|---|---|---|---|---|
| `FondeTextField` | 16px (lg) | 6px | 32px | 12px |
| `FondeDropdownMenu` | 16px (lg) | 6px | 32px | 12px |
| `FondeCheckbox` | — | — | 20px | 4px |

---

**Navigation**: [← Back](./02-design-tokens.md) | [Next: Implementation Guide →](./04-implementation.md)
