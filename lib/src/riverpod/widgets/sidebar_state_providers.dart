import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sidebar_state_providers.g.dart';

/// A map that manages the secondary sidebar state for each screen.
/// Key: index of the activity bar, Value: visibility state of the sidebar.
@riverpod
class FondePerScreenSecondarySidebarState
    extends _$FondePerScreenSecondarySidebarState {
  @override
  Map<int, bool> build() => {};

  /// Get the secondary sidebar state for the specified screen.
  bool getStateForScreen(int screenIndex) {
    return state[screenIndex] ?? false; // Default is hidden
  }

  /// Set the secondary sidebar state for the specified screen.
  void setStateForScreen(int screenIndex, bool visible) {
    state = {...state, screenIndex: visible};
  }

  /// Toggle the secondary sidebar state for the specified screen.
  void toggleStateForScreen(int screenIndex) {
    final currentState = getStateForScreen(screenIndex);
    setStateForScreen(screenIndex, !currentState);
  }
}

/// Provider that manages the visibility state of the primary sidebar (left side).
@riverpod
class FondePrimarySidebarState extends _$FondePrimarySidebarState {
  @override
  bool build() => true; // Default is visible

  void toggle() {
    state = !state;
  }

  void setVisible(bool visible) {
    state = visible;
  }

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }
}

/// Provider that manages the visibility state of the secondary sidebar (right side).
/// Manages the state for each screen based on the current activity bar index.
@riverpod
class FondeSecondarySidebarState extends _$FondeSecondarySidebarState {
  @override
  bool build() {
    return false; // Default is hidden
  }

  void toggle() {
    state = !state;
  }

  void setVisible(bool visible) {
    state = visible;
  }

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }
}

/// Secondary sidebar state provider based on the current activity bar index.
/// This provider automatically manages the state for each screen.
@riverpod
bool fondeContextualSecondarySidebarState(Ref ref) {
  return ref.watch(fondeSecondarySidebarStateProvider);
}
