# fonde_ui Catalog App

An interactive catalog app for exploring and testing `fonde_ui` components.

---

## Overview

This app showcases all components provided by `fonde_ui`. It serves as a live reference during development, design review, and when adding new components.

---

## Requirements

- Flutter: `>=3.41.2`
- Dart: `^3.7.0`
- Platforms: macOS, Windows, Web

---

## Setup

Resolve dependencies from the repository root, then run the app:

```bash
# From repository root
dart pub get

# From example directory
cd example
fvm flutter run -d macos     # macOS
fvm flutter run -d windows   # Windows
fvm flutter run -d chrome    # Web
```

---

## Catalog Structure

| Category | Components |
|---|---|
| **Buttons** | `FondeButton`, `FondeIconButton`, `FondeSegmentedButton`, `FondeSplitButton` |
| **Input** | `FondeTextField`, `FondeSearchField`, `FondeTagsField`, `FondeCheckbox`, `FondeDropdownMenu` |
| **Typography** | `FondeText` (all semantic variants) |
| **Layout** | `FondeScaffold`, `FondeTabView`, `FondeOutlineView`, `FondeMasterDetailLayout` |
| **Feedback** | `FondeDialog`, `FondeToast`, `FondePopover`, `FondeSnackBar` |
| **Decoration** | `FondeSelectionDecorator`, `FondePanel`, `FondeListTile` |

---

## UI Structure

```
┌──────────────────────────────────────────────┐
│ LaunchBar  │ Sidebar          │ Main area      │
│            │                  │                │
│ [category] │ [component list] │ Demo view      │
│ icons      │                  │                │
│            │                  │ Light/dark     │
│            │                  │ theme toggle   │
└──────────────────────────────────────────────┘
```

- **Launch Bar** — switches between categories
- **Sidebar** — lists components in the selected category
- **Main area** — interactive demo of the selected component
- **Theme toggle** — switch between light, dark, and system themes

---

## Adding a New Catalog Page

Add a page file under `example/lib/pages/` and register it in the navigation definition in `example/lib/shell/catalog_sidebar.dart`.
