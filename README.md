# Fonde UI

**Desktop-first Flutter UI utility components optimized for native-like interaction, with zoom scaling support.**

* **Fonde** (pronounced *fond*) — named after *fond de veau*.

![Screenshot](doc/images/screenshot.png)

**[Live Demo](https://szktty.github.io/fonde-ui/)**

## Overview

`fonde_ui` is a Flutter UI utility component library for desktop applications, developed for [RinneGraph](https://github.com/szktty/rinne-graph). It provides improved multi-pane layouts, instant feedback interaction, and zoom scaling support out-of-the-box.

## Platform Support

- Flutter: `>=3.41.2`
- Dart: `^3.7.0`
- Platforms: macOS, Windows, Linux, iOS, Android

## Goals

Fonde UI's goal is to provide **operational and visual comfort** in desktop apps — achieving the same feel as native applications using Flutter. In Fonde UI, comfort takes priority over visual richness.

## Features

- 🖥️ **Desktop-first** — Optimized for desktop applications over mobile, with interactions and layouts tailored for keyboard, mouse, and large screens
- ⚡ **Native-like interaction** — Instant feedback and restrained animations for smooth operation
- 🎨 **Flat design** — Clean, simple visuals inspired by Figma, with smooth-curve corners throughout
- 🪟 **Multi-pane layout** — Built-in support for a three-pane window with a vertical Launch Bar
- 🔍 **Zoom scaling support** — All components scale uniformly with zoom, ensuring a consistent look at any size
- 🔋 **Batteries included** — Handy widgets tuned for desktop applications, ready to use out of the box
- 🏠️ **Customizable appearance** — Supports dark mode, color themes, and custom fonts
- 🌐 **Cross-platform** — Runs on macOS, Windows, Linux, iOS, and Android


## UI Utility Components

### Layout

- Scaffold — integrated three-pane layout with Launch Bar, primary/secondary sidebar, and main content
- Master Detail Layout — master/detail split layout
- Tab View — tab bar and tab view
- Split Pane — resizable split pane
- Panel — container with themed background and border
- Section
- Scroll View

### Navigation

- Toolbar — main, primary/secondary sidebar
- Launch Bar — vertical icon navigation bar with top/bottom sections
- Sidebar — resizable primary and secondary sidebar areas; standard and floating panel (macOS) styles
- Sidebar List — with `filled`, `subtle`, and `inset` item styles

### Data View

- Table View
- Outline View — tree-style outline view
- List Tile

### Buttons

- Button — general purpose button, smooth curve corner
- Icon Button
- Icon Label Button
- Segmented Button
- Split Button — button with dropdown for secondary actions
- Button Group
- Overflow Menu Button — collapses excess items into a popup menu

### Menus

- Context Menu
- Overflow Menu
- Dropdown Menu
- Popup Menu

### Input

- Text Field
- Search Field
- Tags Field
- Number Field — numeric input with − / + buttons, min/max/step
- Checkbox — rectangle/circle shape; filled/outline/iconOnly fill style
- Radio Button
- Switch — toggle switch; compact and wide styles
- Dropdown Menu
- Expansion Tile
- Date Picker — monthly calendar, single and range selection
- Slider
- Color Picker — HSV canvas, hue/alpha sliders, palette swatches, eyedropper

### Feedback

- Dialog — modal dialog
- Confirmation Dialog
- Toast
- Snack Bar
- Popover
- Notification Overlay
- Tooltip
- Linear Progress Indicator
- Circular Progress Indicator

### Typography

- Text — with semantic variants (page title, body, caption, code, table, etc.)

### Visual

- Divider
- Tag
- Container
- Selection Decorator
- Rectangle Border — Figma-style squircle border container
- Eye Dropper — in-window color sampling with zoom loupe

### Interaction

- Gesture Detector — single/double tap without delay, hover and cursor support
- Draggable
- Shortcut Scope

### Platform

- Platform Menus — macOS native menu bar

### Design Tokens

- Spacing — zoomable spacing (4px grid)
- Padding — zoomable padding
- Border Radius — smooth squircle curve
- Border

## State Management

The current version uses **Riverpod 3.x** for theme, accessibility config, and sidebar state management.

Riverpod integration is optional — import `fonde_ui_riverpod.dart` separately when needed.

## Setup

Add to your `pubspec.yaml`:

```yaml
dependencies:
  fonde_ui: ^0.5.0-dev
```

### Minimal Example

```dart
import 'package:fonde_ui/fonde_ui.dart';               // Core + all widgets
import 'package:fonde_ui/fonde_ui_riverpod.dart';      // Riverpod providers (optional)

void main() {
  runApp(
    FondeApp(
      title: 'My App',
      home: FondeScaffold(
        toolbar: MyToolbar(),
        content: MyContent(),
      ),
    ),
  );
}
```

`FondeApp` wraps Riverpod's `ProviderScope` and Material's `MaterialApp` internally.

## Documentation

Full documentation is under preparation. In the meantime, refer to the `example` app for usage demonstrations.

For LLM context, load `llms.txt`.

## License

Apache License 2.0

## Apps Created with Fonde UI

- [RinneGraph](https://github.com/szktty/rinne-graph) — graph-based database app
