# 06. Development Tools

## Catalog App

The `example/` directory contains a catalog app for previewing and testing components.

```bash
cd example
flutter run
```

**Features:**
- Preview all components
- Interaction testing
- Accessibility verification
- Color palette display
- Spacing token verification

## Running Tests

### Basic Test Commands

```bash
# Run all tests
melos run test

# Test a specific package
cd packages/fonde_ui_core
flutter test

# Tests with coverage
flutter test --coverage
```

### Test Categories

```bash
# Unit tests
flutter test test/unit/

# Widget tests
flutter test test/widgets/
```

## Quality Checks

### Static Analysis

```bash
# Run static analysis
flutter analyze

# Detailed analysis results
flutter analyze --verbose
```

### Code Formatting

```bash
# Format code
dart format .

# Format check (for CI)
dart format --set-exit-if-changed .
```

### Code Generation

Generate Riverpod providers and Freezed models:

```bash
# Code generation via melos
melos run gen

# Generation in a specific package
cd packages/fonde_ui_core
dart run build_runner build --delete-conflicting-outputs
```

## Development Support

### Performance Optimization

```dart
// ✅ Recommended: Utilizing const constructors
class OptimizedWidget extends StatelessWidget {
  const OptimizedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // Use const to avoid rebuilds
        FondeText('Fixed Text', variant: FondeTextVariant.bodyText),
        SizedBox(height: 16),
      ],
    );
  }
}

// ✅ Recommended: Optimizing providers with select
Consumer(
  builder: (context, ref, child) {
    // Watch only the necessary part
    final backgroundColor = ref.watch(
      fondeEffectiveColorScheme.select((scheme) => scheme.base.background),
    );

    return Container(color: backgroundColor, child: child);
  },
)
```

## Development Environment Setup

### Required Tools

```bash
# Check Flutter SDK version
flutter --version  # 3.41.2 or higher

# Check Dart SDK version
dart --version  # 3.7.0 or higher

# Melos (monorepo management)
dart pub global activate melos

# Install dependencies
melos bootstrap
```

### Recommended VS Code Extensions

- Flutter
- Dart
- Flutter Widget Snippets

### Configuration Files

**.vscode/settings.json**
```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  },
  "dart.lineLength": 100
}
```

## API Documentation Generation

```bash
# Generate API documentation
dart doc

# Documentation for a specific package
cd packages/fonde_ui_core
dart doc
```

### Component Documentation Style

```dart
/// Standard button component for Fonde UI.
///
/// Optimized for desktop applications,
/// providing 32px height and accessibility support.
///
/// Example:
/// ```dart
/// FondeButton.primary(
///   label: 'Save',
///   onPressed: () => save(),
/// )
/// ```
class FondeButton extends ConsumerWidget {
  // ...
}
```

---

**Navigation**: [← Back](./05-accessibility.md) | [Top](./README.md)
