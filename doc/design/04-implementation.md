# 04. Implementation Guide

## Implementation Guidelines

### Basic Implementation Patterns

#### Using Riverpod Providers

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Recommended: Get theme information from providers
    final colorScheme = ref.watch(fondeEffectiveColorScheme);
    final themeData = ref.watch(fondeEffectiveThemeData);
    final accessibilityConfig = ref.watch(fondeAccessibilityConfig);

    return FondeContainer(
      color: colorScheme.base.background,
      child: FondeText(
        'Text',
        variant: FondeTextVariant.bodyText,
      ),
    );
  }
}
```

#### Implementing Accessibility Support

```dart
// ✅ Recommended: Implementing zoom support
class AccessibleWidget extends ConsumerWidget {
  final bool disableZoom;

  const AccessibleWidget({required this.child, this.disableZoom = false});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(fondeAccessibilityConfig);
    final zoomScale = disableZoom ? 1.0 : config.zoomScale;
    final borderScale = disableZoom ? 1.0 : config.borderScale;
    final colorScheme = ref.watch(fondeEffectiveColorScheme);

    return Container(
      padding: EdgeInsets.all(FondeSpacingValues.lg * zoomScale),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5 * borderScale,
          color: colorScheme.base.border,
        ),
      ),
      child: child,
    );
  }
}
```

### Best Practices for Color Usage

```dart
// ❌ Avoid: Hardcoding
Container(
  color: Colors.blue,
  child: Text(
    'Text',
    style: TextStyle(color: Colors.white),
  ),
)

// ❌ Avoid: Direct Flutter ColorScheme reference
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text('Text'),
)

// ✅ Recommended: FondeColorScheme + FondeText
FondeContainer(
  color: colorScheme.base.background,
  child: FondeText(
    'Text',
    variant: FondeTextVariant.bodyText,
  ),
)

// ✅ Recommended: Semantic color usage
Container(
  color: colorScheme.status.success,
  child: FondeText(
    'Saved',
    variant: FondeTextVariant.captionText,
  ),
)
```

### Best Practices for Text Usage

```dart
// ❌ Avoid: Direct use of Flutter's standard Text
Text(
  'Button Label',
  style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
)

// ✅ Recommended: Using FondeTextVariant
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

### Best Practices for Rounded Corner Implementation

**All rounded corner elements should use `FondeRectangleBorder`:**

```dart
// ❌ Avoid: Direct BorderRadius usage
Container(
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.grey),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Image.network(imageUrl),
  ),
)

// ✅ Recommended: Using FondeRectangleBorder
FondeRectangleBorder(
  cornerRadius: FondeBorderRadiusValues.medium, // 12px
  color: colorScheme.base.background,
  side: FondeBorderSide.standard,
  child: Image.network(imageUrl),
)
```

#### Available Rounded Corner Values

| Constant | Value | Purpose |
|---|---|---|
| `FondeBorderRadiusValues.small` | 6px | Small elements |
| `FondeBorderRadiusValues.medium` | 12px | Standard elements |
| `FondeBorderRadiusValues.large` | 16px | Large elements |

### Best Practices for Layout Implementation

```dart
// ❌ Avoid: Direct use of Flutter's standard widgets
Column(
  children: [
    Text('Title', style: TextStyle(fontSize: 24)),
    SizedBox(height: 16), // Hardcoding
    Padding(
      padding: EdgeInsets.all(15), // 4px grid violation
      child: Container(child: content),
    ),
    SizedBox(height: 25), // 4px grid violation
  ],
)

// ✅ Recommended: Using token-based spacing
Column(
  children: [
    FondeText('Title', variant: FondeTextVariant.sectionTitlePrimary),
    FondeSpacing.verticalLg,         // 16px
    Container(
      padding: EdgeInsets.all(FondeSpacingValues.lg), // 16px
      child: content,
    ),
    FondeSpacing.verticalXxl,        // 24px
  ],
)
```

### Proper Implementation of Separator Lines

```dart
// ❌ Avoid: Direct placement without spacing
Column(
  children: [
    Widget1(),
    FondeDivider(), // No spacing is visually too dense
    Widget2(),
  ],
)

// ✅ Recommended: Manual layout with proper spacing
Column(
  children: [
    Widget1(),
    FondeSpacing.verticalLg,  // 16px
    FondeDivider(),
    FondeSpacing.verticalLg,  // 16px
    Widget2(),
  ],
)
```

## Best Practices

### Leveraging the Design System

1. **Maintaining Consistency**
   - Prioritize existing components
   - Use values based on design tokens
   - Obtain theme information via providers

2. **Accessibility First**
   - Implement zoom support for all components
   - Provide appropriate Semantics information
   - Support keyboard navigation

3. **Performance Optimization**
   - Avoid unnecessary rebuilds
   - Efficient provider usage
   - Utilize `const` constructors

### Component Development

```dart
// ✅ Recommended: Basic structure of a new component
class MyNewComponent extends ConsumerWidget {
  final String label;
  final VoidCallback? onTap;
  final bool disableZoom;

  const MyNewComponent({
    super.key,
    required this.label,
    this.onTap,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorScheme);
    final accessibilityConfig = ref.watch(fondeAccessibilityConfig);

    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    return Semantics(
      button: true,
      label: label,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: FondeRectangleBorder(
          cornerRadius: FondeBorderRadiusValues.medium * zoomScale,
          color: colorScheme.base.background,
          child: Padding(
            padding: EdgeInsets.all(FondeSpacingValues.md * zoomScale),
            child: FondeText(
              label,
              variant: FondeTextVariant.buttonLabel,
            ),
          ),
        ),
      ),
    );
  }
}
```

### State Management

```dart
// ✅ Recommended: Using Riverpod StateProvider
final selectedItemProvider = StateProvider<String?>((ref) => null);

class SelectableItem extends ConsumerWidget {
  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedItemProvider);
    final isSelected = selectedId == itemId;
    final colorScheme = ref.watch(fondeEffectiveColorScheme);

    return FondeGestureDetector(
      onTap: () => ref.read(selectedItemProvider.notifier).state = itemId,
      child: Container(
        color: isSelected
            ? colorScheme.base.selection
            : colorScheme.base.background,
        child: ItemContent(),
      ),
    );
  }
}
```

## Common Mistakes

### Anti-Patterns

#### 1. Bypassing the Theme System

```dart
// ❌ Bad example: Hardcoding
Container(
  color: Color(0xFF1976D2),
  padding: EdgeInsets.all(15),
  child: Text(
    'Button',
    style: TextStyle(color: Colors.white, fontSize: 16),
  ),
)

// ✅ Good example: Leveraging the design system
FondeButton.primary(
  label: 'Button',
  onPressed: () {},
)
```

#### 2. Neglecting Accessibility

```dart
// ❌ Bad example: No zoom support, grid violation
Container(
  width: 200,
  height: 50,
  padding: EdgeInsets.all(8), // 4px grid violation
  child: Text('Fixed Size'),   // Typography violation
)

// ✅ Good example: Accessibility compliant
class AccessibleWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(fondeAccessibilityConfig);
    return Container(
      padding: EdgeInsets.all(FondeSpacingValues.md * config.zoomScale),
      child: FondeText(
        'Responsive Text',
        variant: FondeTextVariant.bodyText,
      ),
    );
  }
}
```

#### 3. Ignoring the Grid System

```dart
// ❌ Bad example: 4px grid violation
Column(
  children: [
    SizedBox(height: 15),        // 4px violation
    Padding(
      padding: EdgeInsets.all(10), // 4px violation
      child: Text('Content'),
    ),
    SizedBox(height: 25),        // 4px violation
  ],
)

// ✅ Good example: Using predefined tokens
Column(
  children: [
    FondeSpacing.verticalLg,   // 16px
    Container(
      padding: EdgeInsets.all(FondeSpacingValues.md), // 12px
      child: FondeText('Content', variant: FondeTextVariant.bodyText),
    ),
    FondeSpacing.verticalXxl,  // 24px
  ],
)
```

#### 4. Using Alpha Values

```dart
// ❌ Bad example: Alpha value usage
Container(
  color: colorScheme.theme.primaryColor.withOpacity(0.3),
)

// ✅ Good example: Using semantic color properties
Container(
  color: colorScheme.base.selection,
)
```

---

**Navigation**: [← Back](./03-components.md) | [Next: Accessibility →](./05-accessibility.md)
