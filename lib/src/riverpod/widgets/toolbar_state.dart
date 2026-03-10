import 'package:flutter/widgets.dart';

/// Data structure for a toolbar item.
class FondeToolbarItemData {
  const FondeToolbarItemData({
    required this.id,
    required this.icon,
    this.tooltip,
  });

  final String id;
  final Widget icon;
  final String? tooltip;
}

/// Model representing the state of the toolbar.
class FondeToolbarState {
  const FondeToolbarState({this.selectedTool, this.enabledTools = const {}});

  final String? selectedTool;
  final Set<String> enabledTools;

  FondeToolbarState copyWith({
    String? Function()? selectedTool,
    Set<String> Function()? enabledTools,
  }) {
    return FondeToolbarState(
      selectedTool: selectedTool != null ? selectedTool() : this.selectedTool,
      enabledTools: enabledTools != null ? enabledTools() : this.enabledTools,
    );
  }
}
