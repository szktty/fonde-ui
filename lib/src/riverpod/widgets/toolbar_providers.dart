import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'toolbar_state.dart' as toolbar_state;

part 'toolbar_providers.g.dart';

/// Provider that manages the state of the toolbar.
///
/// Manages the selected tool and the set of enabled tools.
@riverpod
class FondeToolbarStateManager extends _$FondeToolbarStateManager {
  @override
  toolbar_state.FondeToolbarState build() {
    return const toolbar_state.FondeToolbarState();
  }

  /// Selects a tool.
  void selectTool(String toolId) {
    state = state.copyWith(selectedTool: () => toolId);
  }

  /// Enables a tool.
  void enableTool(String toolId) {
    state = state.copyWith(enabledTools: () => {...state.enabledTools, toolId});
  }

  /// Disables a tool.
  void disableTool(String toolId) {
    state = state.copyWith(
      enabledTools: () => state.enabledTools.where((t) => t != toolId).toSet(),
    );
  }

  /// Updates the state.
  void updateState(toolbar_state.FondeToolbarState newState) {
    state = newState;
  }
}

/// Provider that supplies toolbar actions.
@riverpod
FondeToolbarActions fondeToolbarActions(Ref ref) {
  return FondeToolbarActions(ref);
}

/// Toolbar actions class.
class FondeToolbarActions {
  final Ref _ref;

  FondeToolbarActions(this._ref);

  /// Selects a tool.
  void selectTool(String toolId) {
    _ref.read(fondeToolbarStateManagerProvider.notifier).selectTool(toolId);
  }

  /// Enables a tool.
  void enableTool(String toolId) {
    _ref.read(fondeToolbarStateManagerProvider.notifier).enableTool(toolId);
  }

  /// Disables a tool.
  void disableTool(String toolId) {
    _ref.read(fondeToolbarStateManagerProvider.notifier).disableTool(toolId);
  }
}
