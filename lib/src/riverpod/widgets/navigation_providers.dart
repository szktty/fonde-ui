import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_providers.g.dart';

/// Provider for managing navigation state.
///
/// Manages the selection state of navigation items and the expansion state
/// of groups. Item and group identifiers are plain [String] values.
@riverpod
class FondeNavigationState extends _$FondeNavigationState {
  @override
  FondeNavigationStateData build() {
    return const FondeNavigationStateData(
      expandedGroupIds: [],
      selectedItemId: null,
    );
  }

  /// Toggle the expansion state of a group.
  void toggleGroup(String groupId) {
    final current = state;
    final isExpanded = current.expandedGroupIds.contains(groupId);

    if (isExpanded) {
      state = current.copyWith(
        expandedGroupIds: current.expandedGroupIds
            .where((id) => id != groupId)
            .toList(),
      );
    } else {
      state = current.copyWith(
        expandedGroupIds: [...current.expandedGroupIds, groupId],
      );
    }
  }

  /// Select an item.
  void selectItem(String itemId) {
    state = state.copyWith(selectedItemId: itemId);
  }

  /// Clear the selection.
  void clearSelection() {
    state = state.copyWith(selectedItemId: null);
  }

  /// Check if the specified group ID is expanded.
  bool isGroupExpanded(String groupId) =>
      state.expandedGroupIds.contains(groupId);

  /// Check if the specified item ID is selected.
  bool isItemSelected(String itemId) => state.selectedItemId == itemId;
}

/// Navigation state data class.
class FondeNavigationStateData {
  const FondeNavigationStateData({
    required this.expandedGroupIds,
    required this.selectedItemId,
  });

  /// List of IDs of expanded groups.
  final List<String> expandedGroupIds;

  /// ID of the selected item (null if nothing is selected).
  final String? selectedItemId;

  FondeNavigationStateData copyWith({
    List<String>? expandedGroupIds,
    String? selectedItemId,
  }) {
    return FondeNavigationStateData(
      expandedGroupIds: expandedGroupIds ?? this.expandedGroupIds,
      selectedItemId: selectedItemId ?? this.selectedItemId,
    );
  }
}
