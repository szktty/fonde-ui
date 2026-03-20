# 05. Accessibility

## Accessibility Strategy

Fonde UI targets **WCAG 2.1 AA compliance**, striving to be a UI library that all users can comfortably use.

**Compliance Level:**
- ✅ **Level A**: Basic Accessibility
- ✅ **Level AA**: Advanced Accessibility (in progress)
- 🔄 **Level AAA**: Highest Level (planned for future)

## Zoom / Magnification Functionality

### FondeAccessibilityConfig

```dart
class FondeAccessibilityConfig {
  final double zoomScale;      // 1.0–2.0 (100%–200%)
  final double borderScale;    // 1.0–1.5 (border magnification)
  final double fontScale;      // 1.0–2.0 (font magnification)
  final bool highContrastMode; // High contrast mode
}
```

### Implementation Pattern

```dart
// Applied uniformly across all components
class FondeButton extends ConsumerWidget {
  final bool disableZoom; // Individual disable

  const FondeButton({super.key, required this.label, this.onPressed, this.disableZoom = false});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(fondeAccessibilityConfig);
    final scale = disableZoom ? 1.0 : config.zoomScale;

    return Container(
      height: 32.0 * scale, // Desktop optimized
      padding: EdgeInsets.symmetric(
        horizontal: FondeSpacingValues.lg * scale,
        vertical: 4.0 * scale,
      ),
      // ...
    );
  }
}
```

### Providers

```dart
// ✅ Retrieve accessibility settings
final config = ref.watch(fondeAccessibilityConfig);

// ✅ Update accessibility settings
ref.read(fondeAccessibilityConfig.notifier).updateConfig(
  config.copyWith(zoomScale: 1.5),
);
```

## Keyboard Navigation

### Basic Operations

| Key | Action | Status |
|---|---|---|
| **Tab** | Focus to next element | ✅ Implemented |
| **Shift+Tab** | Focus to previous element | ✅ Implemented |
| **Enter/Space** | Execute action | ✅ Implemented |
| **Escape** | Close dialog/menu | ✅ Implemented |
| **Arrow Keys** | Navigate within list | 🔄 In progress |

### Shortcut Keys

```dart
// Example global shortcut implementation
Shortcuts(
  shortcuts: {
    LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyB):
        const ToggleSidebarIntent(),
  },
  child: Actions(
    actions: {
      ToggleSidebarIntent: ToggleSidebarAction(ref),
    },
    child: child,
  ),
)
```

### Focus Management

```dart
// Focus trap in dialogs
FocusScope(
  autofocus: true,
  child: FondeDialog(
    child: Column(
      children: [
        FondeTextField(...), // Auto-focused
        FondeButton.primary(...),
      ],
    ),
  ),
)
```

## Screen Reader Support

### Semantics Widget

```dart
// ✅ Recommended: Appropriate semantic information
Semantics(
  button: true,
  label: 'Save File',
  hint: 'You can also save with Cmd+S',
  enabled: true,
  child: FondeButton.primary(
    label: 'Save',
    onPressed: _save,
  ),
)

// ✅ Recommended: Semantics for list items
Semantics(
  customSemanticsActions: {
    CustomSemanticsAction(label: 'Edit'): _edit,
    CustomSemanticsAction(label: 'Delete'): _delete,
  },
  child: ListTile(...),
)
```

### Live Regions

```dart
// ✅ Recommended: Notification of dynamic content
Semantics(
  liveRegion: true,
  child: Text(statusMessage),
)

// ✅ Recommended: Notification of error messages
Semantics(
  liveRegion: true,
  child: FondeText(
    errorMessage,
    variant: FondeTextVariant.captionText,
    color: colorScheme.status.error,
  ),
)
```

## High Contrast Support

### Color Contrast Ratio

**WCAG AA Compliant:**
- **Normal Text**: 4.5:1 or higher
- **Large Text**: 3:1 or higher
- **UI Elements**: 3:1 or higher

```dart
// ✅ Recommended: Color selection considering contrast ratio
final textColor = colorScheme.base.foreground;        // 4.5:1
final backgroundColor = colorScheme.base.background;  // Appropriate contrast
final accentColor = colorScheme.theme.primaryColor;   // 3:1 or higher
```

## Accessibility Testing

### Automated Tests

```dart
// Semantic test
testWidgets('Button accessibility test', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());

  // Verify semantic information
  expect(
    tester.getSemantics(find.byType(FondeButton)),
    matchesSemantics(
      label: 'Test Button',
      isButton: true,
      isEnabled: true,
      hasTapAction: true,
    ),
  );
});

// Zoom functionality test
testWidgets('Zoom functionality test', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());

  final container = ProviderContainer();
  container.read(fondeAccessibilityConfig.notifier).updateConfig(
    FondeAccessibilityConfig(zoomScale: 1.5),
  );

  await tester.pumpAndSettle();
});
```

### Manual Test Items

- [ ] Operate all functions with keyboard only
- [ ] Get information with screen reader
- [ ] Check display at 200% zoom
- [ ] Verify visibility in high contrast mode
- [ ] Check with color blind simulation

## Animation Prohibition Policy

### Basic Policy

Fonde UI **prohibits all animations**. This achieves the following:

- **Performance improvement**: Reduced CPU/GPU load
- **Improved usability**: Reduced visual noise
- **Accessibility support**: Consideration for users sensitive to motion
- **Increased focus**: Prevents distraction from unnecessary visual movement

### Permitted Exceptions

The following animations are permitted for **important status display and UI operability**:

- **Progress bar**: Visual display of loading progress (`LinearProgressIndicator`, `CircularProgressIndicator`)
- **Loading spinner**: Animation indicating processing
- **Popovers**: Display/hide animations (`FondePopover`, `Tooltip`, etc.)
- **Dialogs**: Display/hide animations (`FondeDialog`, `showDialog`, etc.)

### Mandatory Disabled Animations

```dart
// ✅ Required: Disable SegmentedButton animation
SegmentedButton.styleFrom(
  animationDuration: Duration.zero,       // Disable selection animation
  splashFactory: NoSplash.splashFactory,  // Disable ripple animation
)

// ✅ Required: Disable ExpansionTile animation
ExpansionTile(
  tilePadding: EdgeInsets.zero,
  childrenPadding: EdgeInsets.zero,
)
```

## Accessibility Checklist

### Implementation Check Items

- [ ] **Zoom support**: Displays correctly at 100%–200%
- [ ] **Keyboard operation**: Navigable with Tab/Shift+Tab
- [ ] **Semantic information**: Appropriate label, hint, and role set
- [ ] **Focus management**: Visual focus indicator present
- [ ] **Contrast ratio**: WCAG AA compliant (4.5:1 or higher)
- [ ] **Tap target**: 32px or more on desktop
- [ ] **Error handling**: Clear error messages
- [ ] **Animation**: Unnecessary animations disabled

### Test Items

- [ ] **Automated tests**: Verification of semantic information
- [ ] **Manual tests**: Keyboard-only operation
- [ ] **Screen reader**: VoiceOver verification
- [ ] **Zoom test**: Display check at 200% magnification
- [ ] **Color vision test**: Color blind simulation check

---

**Navigation**: [← Back](./04-implementation.md) | [Next: Development Tools →](./06-development.md)
