import 'package:flutter/widgets.dart';
import '../widgets/toolbar/toolbar_state.dart';

// ---------------------------------------------------------------------------
// Sidebar controllers
// ---------------------------------------------------------------------------

/// Controls the visibility of the primary sidebar.
class FondePrimarySidebarController extends ChangeNotifier {
  FondePrimarySidebarController({bool initiallyVisible = true})
    : _visible = initiallyVisible;

  bool _visible;

  bool get isVisible => _visible;

  void show() => _setVisible(true);
  void hide() => _setVisible(false);
  void toggle() => _setVisible(!_visible);
  void setVisible(bool visible) => _setVisible(visible);

  void _setVisible(bool v) {
    if (_visible == v) return;
    _visible = v;
    notifyListeners();
  }

  static FondePrimarySidebarController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_FondeSidebarControllerScope>()
        ?.primaryController;
  }
}

/// Controls the visibility of the secondary sidebar.
class FondeSecondarySidebarController extends ChangeNotifier {
  FondeSecondarySidebarController({bool initiallyVisible = false})
    : _visible = initiallyVisible;

  bool _visible;

  bool get isVisible => _visible;

  void show() => _setVisible(true);
  void hide() => _setVisible(false);
  void toggle() => _setVisible(!_visible);
  void setVisible(bool visible) => _setVisible(visible);

  void _setVisible(bool v) {
    if (_visible == v) return;
    _visible = v;
    notifyListeners();
  }

  static FondeSecondarySidebarController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_FondeSidebarControllerScope>()
        ?.secondaryController;
  }
}

/// Controls the width of the primary sidebar.
class FondeSidebarWidthController extends ChangeNotifier {
  FondeSidebarWidthController({
    double initialWidth = 320.0,
    this.minWidth = 240.0,
    this.maxWidth = 480.0,
  }) : _width = initialWidth.clamp(240.0, 480.0);

  final double minWidth;
  final double maxWidth;
  double _width;

  double get width => _width;

  void setWidth(double w) {
    final clamped = w.clamp(minWidth, maxWidth);
    if (_width == clamped) return;
    _width = clamped;
    notifyListeners();
  }

  void adjustWidth(double delta) => setWidth(_width + delta);
}

/// Controls the width of the secondary sidebar.
class FondeSecondarySidebarWidthController extends ChangeNotifier {
  FondeSecondarySidebarWidthController({
    double initialWidth = 288.0,
    this.minWidth = 200.0,
    this.maxWidth = 400.0,
  }) : _width = initialWidth.clamp(200.0, 400.0);

  final double minWidth;
  final double maxWidth;
  double _width;

  double get width => _width;

  void setWidth(double w) {
    final clamped = w.clamp(minWidth, maxWidth);
    if (_width == clamped) return;
    _width = clamped;
    notifyListeners();
  }

  void adjustWidth(double delta) => setWidth(_width + delta);
}

// ---------------------------------------------------------------------------
// InheritedWidget for sidebar controllers
// ---------------------------------------------------------------------------

class _FondeSidebarControllerScope extends InheritedWidget {
  const _FondeSidebarControllerScope({
    required this.primaryController,
    required this.secondaryController,
    required this.primaryWidthController,
    required this.secondaryWidthController,
    required super.child,
  });

  final FondePrimarySidebarController primaryController;
  final FondeSecondarySidebarController secondaryController;
  final FondeSidebarWidthController primaryWidthController;
  final FondeSecondarySidebarWidthController secondaryWidthController;

  @override
  bool updateShouldNotify(_FondeSidebarControllerScope old) =>
      primaryController != old.primaryController ||
      secondaryController != old.secondaryController ||
      primaryWidthController != old.primaryWidthController ||
      secondaryWidthController != old.secondaryWidthController;
}

/// Wraps a subtree with sidebar controller scopes.
///
/// Used internally by [FondeScaffold]. Descendant widgets can retrieve
/// controllers via the static accessors.
class FondeSidebarControllerScope extends StatelessWidget {
  const FondeSidebarControllerScope({
    super.key,
    required this.primaryController,
    required this.secondaryController,
    required this.primaryWidthController,
    required this.secondaryWidthController,
    required this.child,
  });

  final FondePrimarySidebarController primaryController;
  final FondeSecondarySidebarController secondaryController;
  final FondeSidebarWidthController primaryWidthController;
  final FondeSecondarySidebarWidthController secondaryWidthController;
  final Widget child;

  static _FondeSidebarControllerScope? _scope(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_FondeSidebarControllerScope>();

  static FondePrimarySidebarController? primaryOf(BuildContext context) =>
      _scope(context)?.primaryController;

  static FondeSecondarySidebarController? secondaryOf(BuildContext context) =>
      _scope(context)?.secondaryController;

  static FondeSidebarWidthController? primaryWidthOf(BuildContext context) =>
      _scope(context)?.primaryWidthController;

  static FondeSecondarySidebarWidthController? secondaryWidthOf(
    BuildContext context,
  ) => _scope(context)?.secondaryWidthController;

  @override
  Widget build(BuildContext context) {
    return _FondeSidebarControllerScope(
      primaryController: primaryController,
      secondaryController: secondaryController,
      primaryWidthController: primaryWidthController,
      secondaryWidthController: secondaryWidthController,
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Navigation controller
// ---------------------------------------------------------------------------

/// Navigation state data.
class FondeNavigationStateData {
  const FondeNavigationStateData({
    this.expandedGroupIds = const [],
    this.selectedItemId,
  });

  final List<String> expandedGroupIds;
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

/// Controls navigation item selection and group expansion.
class FondeNavigationController extends ChangeNotifier {
  FondeNavigationController({FondeNavigationStateData? initialState})
    : _state = initialState ?? const FondeNavigationStateData();

  FondeNavigationStateData _state;

  FondeNavigationStateData get state => _state;

  String? get selectedItemId => _state.selectedItemId;
  List<String> get expandedGroupIds => _state.expandedGroupIds;

  void selectItem(String itemId) {
    _state = _state.copyWith(selectedItemId: itemId);
    notifyListeners();
  }

  void clearSelection() {
    _state = _state.copyWith(selectedItemId: null);
    notifyListeners();
  }

  void toggleGroup(String groupId) {
    final isExpanded = _state.expandedGroupIds.contains(groupId);
    if (isExpanded) {
      _state = _state.copyWith(
        expandedGroupIds:
            _state.expandedGroupIds.where((id) => id != groupId).toList(),
      );
    } else {
      _state = _state.copyWith(
        expandedGroupIds: [..._state.expandedGroupIds, groupId],
      );
    }
    notifyListeners();
  }

  bool isItemSelected(String itemId) => _state.selectedItemId == itemId;
  bool isGroupExpanded(String groupId) =>
      _state.expandedGroupIds.contains(groupId);

  static FondeNavigationController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_FondeNavigationControllerScope>()
        ?.controller;
  }
}

class _FondeNavigationControllerScope extends InheritedWidget {
  const _FondeNavigationControllerScope({
    required this.controller,
    required super.child,
  });

  final FondeNavigationController controller;

  @override
  bool updateShouldNotify(_FondeNavigationControllerScope old) =>
      controller != old.controller;
}

/// Wraps a subtree so descendants can access [FondeNavigationController].
class FondeNavigationControllerScope extends StatelessWidget {
  const FondeNavigationControllerScope({
    super.key,
    required this.controller,
    required this.child,
  });

  final FondeNavigationController controller;
  final Widget child;

  static FondeNavigationController? of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_FondeNavigationControllerScope>()
          ?.controller;

  @override
  Widget build(BuildContext context) {
    return _FondeNavigationControllerScope(
      controller: controller,
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Toolbar controller
// ---------------------------------------------------------------------------

/// Controls toolbar item selection and enabled state.
class FondeToolbarController extends ChangeNotifier {
  FondeToolbarController({FondeToolbarState? initialState})
    : _state = initialState ?? const FondeToolbarState();

  FondeToolbarState _state;

  FondeToolbarState get state => _state;

  void selectTool(String toolId) {
    _state = _state.copyWith(selectedTool: () => toolId);
    notifyListeners();
  }

  void enableTool(String toolId) {
    _state = _state.copyWith(
      enabledTools: () => {..._state.enabledTools, toolId},
    );
    notifyListeners();
  }

  void disableTool(String toolId) {
    _state = _state.copyWith(
      enabledTools: () => _state.enabledTools.where((t) => t != toolId).toSet(),
    );
    notifyListeners();
  }

  void updateState(FondeToolbarState newState) {
    _state = newState;
    notifyListeners();
  }

  static FondeToolbarController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_FondeToolbarControllerScope>()
        ?.controller;
  }
}

class _FondeToolbarControllerScope extends InheritedWidget {
  const _FondeToolbarControllerScope({
    required this.controller,
    required super.child,
  });

  final FondeToolbarController controller;

  @override
  bool updateShouldNotify(_FondeToolbarControllerScope old) =>
      controller != old.controller;
}

/// Wraps a subtree so descendants can access [FondeToolbarController].
class FondeToolbarControllerScope extends StatelessWidget {
  const FondeToolbarControllerScope({
    super.key,
    required this.controller,
    required this.child,
  });

  final FondeToolbarController controller;
  final Widget child;

  static FondeToolbarController? of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_FondeToolbarControllerScope>()
          ?.controller;

  @override
  Widget build(BuildContext context) {
    return _FondeToolbarControllerScope(controller: controller, child: child);
  }
}

// ---------------------------------------------------------------------------
// Search controller
// ---------------------------------------------------------------------------

/// Controls the current search query.
class FondeSearchController extends ChangeNotifier {
  FondeSearchController({String initialQuery = ''}) : _query = initialQuery;

  String _query;

  String get query => _query;

  void updateQuery(String? newQuery) {
    final q = newQuery ?? '';
    if (_query == q) return;
    _query = q;
    notifyListeners();
  }

  void clearQuery() => updateQuery('');

  static FondeSearchController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_FondeSearchControllerScope>()
        ?.controller;
  }
}

class _FondeSearchControllerScope extends InheritedWidget {
  const _FondeSearchControllerScope({
    required this.controller,
    required super.child,
  });

  final FondeSearchController controller;

  @override
  bool updateShouldNotify(_FondeSearchControllerScope old) =>
      controller != old.controller;
}

/// Wraps a subtree so descendants can access [FondeSearchController].
class FondeSearchControllerScope extends StatelessWidget {
  const FondeSearchControllerScope({
    super.key,
    required this.controller,
    required this.child,
  });

  final FondeSearchController controller;
  final Widget child;

  static FondeSearchController? of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_FondeSearchControllerScope>()
          ?.controller;

  @override
  Widget build(BuildContext context) {
    return _FondeSearchControllerScope(controller: controller, child: child);
  }
}
