# fonde_ui Test Implementation Plan

## Approach: AI-First

Tests in this project are designed to be implemented and maintained autonomously by AI.
The following principles apply:

- **Self-contained**: Each test file must be independently readable and understandable.
- **Explicit intent**: Test names and comments must clearly state *what* and *why* is being verified.
- **Reproducible**: No randomness, clock dependence, or external network calls.
- **Incremental**: Each Phase is independently CI-ready and builds on the previous one.

Additional AI conventions are recorded in `doc/test-conventions.md` as they emerge.

---

## Directory Structure

```
test/
├── core/
│   ├── models/
│   │   ├── accessibility_config_test.dart
│   │   ├── color_scheme_test.dart
│   │   ├── theme_data_test.dart
│   │   ├── typography_config_test.dart
│   │   └── font_config_test.dart
│   └── providers/
│       ├── theme_providers_test.dart
│       └── theme_color_providers_test.dart
├── riverpod/
│   ├── navigation_providers_test.dart
│   ├── search_providers_test.dart
│   ├── sidebar_providers_test.dart
│   ├── toolbar_providers_test.dart
│   └── accessibility_utils_test.dart
├── widgets/
│   ├── buttons/
│   │   ├── fonde_button_test.dart
│   │   └── fonde_icon_button_test.dart
│   ├── input/
│   │   ├── fonde_checkbox_test.dart
│   │   ├── fonde_text_field_test.dart
│   │   └── fonde_search_field_test.dart
│   ├── navigation/
│   │   ├── sidebar_list_item_test.dart
│   │   └── sidebar_list_group_test.dart
│   ├── tab_view/
│   │   └── fonde_tab_bar_test.dart
│   ├── dialogs/
│   │   └── fonde_dialog_test.dart
│   ├── typography/
│   │   └── fonde_text_test.dart
│   ├── progress/
│   │   └── fonde_progress_indicator_test.dart
│   └── layout/
│       └── fonde_scaffold_test.dart
└── helpers/
    ├── test_app.dart       # Minimal FondeApp wrapper for widget tests
    └── pump_helpers.dart   # Convenience extensions on WidgetTester
```

---

## Test Helpers

### `test/helpers/test_app.dart`

Shared wrapper used by all widget tests.

```dart
/// Minimal FondeApp wrapper for widget tests.
/// Internally wraps ProviderScope, MaterialApp, and FondeTheme.
/// Use [overrides] to substitute any provider for a given test.
Widget buildTestApp({
  required Widget child,
  List<Override> overrides = const [],
  FondeThemeData? theme,
});
```

### `test/helpers/pump_helpers.dart`

```dart
/// Builds and stabilizes a widget in the test environment.
/// Hides the boilerplate of tester.pump() / pumpAndSettle().
extension PumpHelpers on WidgetTester {
  Future<void> pumpTestApp(Widget child, {List<Override> overrides});
}
```

---

## Phase 1: Core Models (Priority: Critical)

**Goal**: Cover all pure-Dart classes that contain business logic.
No UI or Riverpod required — the fastest path to green CI.

### 1-1. `FondeAccessibilityConfig`

**File**: `test/core/models/accessibility_config_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| Default values | `fontScale`, `zoomScale`, `borderScale` are `1.0`; `highContrastMode` is `false` |
| `copyWith` | Only the specified field changes; others are unchanged |
| JSON round-trip | `fromJson(toJson())` produces an equal value |
| Boundary values | `scale` of `0.0`, negative, and very large values do not throw |

### 1-2. `FondeColorScheme`

**File**: `test/core/models/color_scheme_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| Brightness check | `isDarkMode` matches the given `Brightness` |
| `fromColorScheme` | Conversion from `ColorScheme` preserves primary colors |
| `getEffectiveAppColorScheme` | `ThemeMode.system` branches correctly on `Brightness` |

### 1-3. `FondeThemeData`

**File**: `test/core/models/theme_data_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| `toThemeData` | Converts to a Flutter `ThemeData` without error |
| `copyWith` | Changing `name` does not affect other fields |
| `getEffectiveAppColorScheme` | Returns correct `Brightness` for light, dark, and system modes |

### 1-4. `FondeTypographyConfig` / `FondeFontConfig`

**Files**: `test/core/models/typography_config_test.dart`, `font_config_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| Default config | `uiFont`, `textFont`, and `codeFont` are non-null |
| `copyWith` | Only the targeted font is overridden |

---

## Phase 2: Riverpod Providers (Priority: High)

**Goal**: Verify provider state transitions without mounting any UI.
Uses `ProviderContainer` directly — fast and stable.

### Common setup

```dart
late ProviderContainer container;

setUp(() => container = ProviderContainer());
tearDown(() => container.dispose());
```

### 2-1. Theme providers

**File**: `test/core/providers/theme_providers_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| Initial theme | `fondeActiveThemeProvider` starts as `FondeThemePresets.system` |
| `setTheme` | `setTheme(dark)` → provider value becomes the dark theme |
| Effective color scheme | With a light theme, `isDarkMode == false` |
| Effective theme data | Can be retrieved as a Flutter `ThemeData` |

### 2-2. Theme color providers

**File**: `test/core/providers/theme_color_providers_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| Initial accent color | `fondeThemeColorProvider` has a defined initial value |
| `setThemeColor` | `setThemeColor(indigo)` → value becomes `indigo` |
| Color scheme update | `effectiveColorSchemeWithThemeProvider` changes after accent color change |

### 2-3. Navigation providers

**File**: `test/riverpod/navigation_providers_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| Initial state | `selectedItemId` is `null`; `expandedGroupIds` is empty |
| `selectItem` | `selectItem("a")` → `isItemSelected("a") == true` |
| Selection change | `selectItem("b")` → `"a"` is no longer selected |
| `clearSelection` | After clearing, `selectedItemId` is `null` |
| `toggleGroup` | `toggleGroup("g1")` → `isGroupExpanded("g1") == true` |
| Re-toggle group | Toggling an expanded group collapses it |

### 2-4. Sidebar providers

**File**: `test/riverpod/sidebar_providers_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| Primary initial value | `fondePrimarySidebarStateProvider` is `true` |
| `toggle` | Alternates `true → false → true` on successive calls |
| `show` / `hide` | Explicitly setting visibility works in both directions |
| Width change | `sidebarWidthProvider.setWidth(400)` → value is `400` |
| Width clamping | `setWidth(9999)` → value is clamped to `maxWidth` |

### 2-5. Toolbar providers

**File**: `test/riverpod/toolbar_providers_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| Initial state | `selectedTool` is `null` |
| `selectTool` | `selectTool("zoom")` → `selectedTool == "zoom"` |
| `enableTool` / `disableTool` | After `disableTool`, the id is absent from `enabledTools` |

### 2-6. Search providers

**File**: `test/riverpod/search_providers_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| Initial query | Empty string |
| `updateQuery` | Accepts an arbitrary string |
| `clearQuery` | Resets to an empty string |

### 2-7. Accessibility utils (`WidgetRef` extensions)

**File**: `test/riverpod/accessibility_utils_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| `zoomScale` applied | After `zoomScale = 2.0`, `ref.scaleValue(10.0) == 20.0` |
| `borderScale` applied | After `borderScale = 1.5`, `ref.scaleBorderWidth(2.0) == 3.0` |

> Note: `WidgetRef` extensions require a widget test context (`ProviderScope` + mounted widget).

---

## Phase 3: Widget Interaction Tests (Priority: High)

**Goal**: Verify user interactions on the most frequently used widgets.
Focus is on *behavior* (callbacks, state changes), not visual appearance.

### Conventions

- Always use `buildTestApp()` to wrap the widget under test.
- Prefer `find.byType` over `find.byKey`; use `byKey` only as a last resort.
- Use `pumpAndSettle()` when waiting for animations; `pump()` is sufficient for `Duration.zero` transitions (which are common in fonde_ui).

### 3-1. `FondeButton`

**File**: `test/widgets/buttons/fonde_button_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| Label rendering | `find.text('Label')` exists |
| `onPressed` called | Tap invokes the callback exactly once |
| Disabled state | `enabled: false` — tap does not invoke the callback |
| `primary` constructor | Renders without crashing |
| `destructive` constructor | Renders without crashing |
| `cancel` constructor | Renders without crashing |

### 3-2. `FondeIconButton`

**File**: `test/widgets/buttons/fonde_icon_button_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| Icon rendered | `find.byIcon` exists |
| `onPressed` called | Tap invokes the callback |
| Disabled | `enabled: false` — tap does nothing |
| `compact` / `circle` constructors | Each variant renders without crashing |
| Tooltip | Tooltip string is set on the widget |

### 3-3. `FondeCheckbox`

**File**: `test/widgets/input/fonde_checkbox_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| Checked state | Renders as checked when `value: true` |
| Unchecked state | Renders as unchecked when `value: false` |
| Tap → `onChanged` | `false → true` transition triggers the callback |
| Tristate cycle | `null → false → true → null` cycle is correct |
| Disabled | `onChanged: null` — tap produces no change |

### 3-4. `FondeTextField`

**File**: `test/widgets/input/fonde_text_field_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| Hint text | Hint text is visible |
| Input → `onChanged` | Typing calls the callback |
| Controller sync | `controller.text` matches the entered value |
| `enabled: false` | Tap and keyboard input are disabled |
| `errorText` | Error message is rendered |

### 3-5. `FondeSearchField`

**File**: `test/widgets/input/fonde_search_field_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| Initial state | Search icon is present |
| Clear button appears | After typing, a clear button is shown |
| Clear button tap | Clears the text field |

### 3-6. `FondeSidebarListItem`

**File**: `test/widgets/navigation/sidebar_list_item_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| Title rendered | `find.text('Title')` exists |
| Selected state | `isSelected: true` applies selected styling without crashing |
| `onTap` called | Tap invokes the callback once |
| `leading` / `trailing` | Both widgets are rendered |

### 3-7. `FondeSidebarListGroup`

**File**: `test/widgets/navigation/sidebar_list_group_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| Initially collapsed | With `isExpanded: false`, children are not visible |
| Initially expanded | With `initiallyExpanded: true`, children are visible |
| Tap to expand | Tap causes children to become visible |
| `onExpansionChanged` | Callback fires on expand and collapse |

### 3-8. `FondeTabBar`

**File**: `test/widgets/tab_view/fonde_tab_bar_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| Tab labels rendered | Each tab's label is displayed |
| Tab selection | Tap calls `onTabSelected` with the correct tab id |
| Active tab | The tab matching `selectedTabId` appears selected |
| Close button | Shown when `closeable: true` |
| `onTabClosed` | Close button tap invokes the callback |

### 3-9. `FondeDialog` / `showFondeDialog`

**File**: `test/widgets/dialogs/fonde_dialog_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| Title rendered | `title` string is displayed |
| Child rendered | The passed `child` widget is displayed |
| Footer rendered | The `footer` widget is displayed |
| `showFondeDialog` | Opens asynchronously; `Navigator.pop` closes it |
| `barrierDismissible` | Tapping the barrier dismisses the dialog |
| `showCloseButton` | Close button is displayed when enabled |

---

## Phase 4: Widget Rendering Tests (Priority: Medium)

**Goal**: Verify structural correctness of rendered widgets.
Uses widget-tree assertions rather than golden images.

### 4-1. `FondeText`

**File**: `test/widgets/typography/fonde_text_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| All variants render | All 28 `FondeTextVariant` values render without crashing |
| `zoomScale` applied | At `zoomScale = 2.0`, font size doubles |
| Color override | The `color` parameter is reflected in the rendered text |

### 4-2. `FondeLinearProgressIndicator`

**File**: `test/widgets/progress/fonde_progress_indicator_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| Determinate mode | `value: 0.5` renders without crashing |
| Indeterminate mode | `value: null` renders a running indicator |
| Cancelled state | `isCancelled: true` freezes the animation |
| Custom color | The `color` parameter is applied |

### 4-3. `FondeScaffold` (smoke tests)

**File**: `test/widgets/layout/fonde_scaffold_test.dart`

| Test case | What is verified |
|-----------|-----------------|
| Minimal config | `toolbar` + `content` alone renders without crashing |
| With launch bar | `showLaunchBar: true` renders correctly |
| With primary sidebar | `showPrimarySidebar: true` renders correctly |
| Sidebar hidden | When `fondePrimarySidebarStateProvider` is `false`, collapsed layout is used |

---

## Phase 5: Golden Tests (Priority: Low)

**Goal**: Detect unintentional visual regressions from design changes.
Run on Linux headless CI; be aware of font and anti-aliasing differences across platforms.

### Conventions

- Store golden files under `test/golden/`.
- Update goldens with `flutter test --update-goldens` only when changes are intentional.
- Set a `tolerance` to absorb platform pixel differences (recommended: `0.5%`).
- Limit scope to foundational, low-churn components.

### Candidates

| Golden file | Contents |
|-------------|----------|
| `button_variants.png` | All four button styles side by side |
| `color_scheme_light.png` | Light theme color palette |
| `color_scheme_dark.png` | Dark theme color palette |
| `typography_variants.png` | Key `FondeTextVariant` samples |

---

## CI Configuration

### Run commands

```bash
# Unit + widget tests (Phase 1–4)
fvm flutter test

# Golden tests (Phase 5)
fvm flutter test test/golden/ --update-goldens  # intentional golden update only
fvm flutter test test/golden/                    # regression check
```

### GitHub Actions (`.github/workflows/test.yml`)

```yaml
- name: Run tests
  run: fvm flutter test --coverage

- name: Upload coverage
  uses: codecov/codecov-action@v4
  with:
    file: coverage/lcov.info
```

---

## Implementation Order (Recommended for AI)

1. Implement **`test/helpers/`** first — all widget tests depend on it.
2. Complete all of **Phase 1** before moving to Phase 2.
3. Follow the order: Phase 2 → Phase 3.
4. Each file in Phase 3 can be implemented and PR'd independently.
5. Phase 4 and Phase 5 can proceed in parallel after Phase 3 is complete.

---

## Known Constraints

### Riverpod ConsumerWidgets
- All widget tests must wrap the subject in `ProviderScope` + `MaterialApp`.
- Use `ProviderContainer` for pure-Dart provider tests; use `ProviderScope` for widget tests.

### `Duration.zero` animations
- fonde_ui deliberately avoids animations, so `pump()` is often sufficient.
- Dialogs and overlays may still require `pumpAndSettle()`.

### macOS-native widgets
- Components like `FondePlatformMenus` require mocking `defaultTargetPlatform`.
- Excluded from Phase 1–3; address in a later phase if needed.

### `pluto_grid` / `textfield_tags`
- `FondeTableView` and `FondeTagsField` have strong third-party dependencies.
- Defer to Phase 4 or later; smoke tests (no crash) are sufficient.

---

*Last updated: 2026-03-19*
