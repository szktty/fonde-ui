import 'package:flutter/widgets.dart';

/// A keyboard shortcut binding for use with [FondeShortcutScope].
///
/// Associates a [LogicalKeySet] or [SingleActivator] with a callback.
class FondeShortcutBinding {
  const FondeShortcutBinding({
    required this.activator,
    required this.onInvoke,
    this.label,
  });

  /// The key combination that triggers this shortcut.
  final ShortcutActivator activator;

  /// Called when the shortcut is triggered and the scope is active.
  final VoidCallback onInvoke;

  /// Optional human-readable label (for display in tooltips, command palettes, etc.).
  final String? label;
}

/// An intent used internally by [FondeShortcutScope].
class _FondeShortcutIntent extends Intent {
  const _FondeShortcutIntent(this.binding);
  final FondeShortcutBinding binding;
}

/// Scope-aware keyboard shortcut manager for desktop applications.
///
/// Wraps [Shortcuts] and [Actions] to bind keyboard shortcuts within a
/// specific UI scope. Shortcuts are only active when a descendant widget
/// has focus (or when [autofocus] is true).
///
/// Shortcuts defined in a child scope take precedence over parent scopes,
/// following Flutter's built-in focus and shortcut lookup order.
///
/// Example:
/// ```dart
/// FondeShortcutScope(
///   bindings: [
///     FondeShortcutBinding(
///       activator: const SingleActivator(LogicalKeyboardKey.keyN, meta: true),
///       label: 'New Item',
///       onInvoke: () => _createItem(),
///     ),
///     FondeShortcutBinding(
///       activator: const SingleActivator(LogicalKeyboardKey.keyW, meta: true),
///       label: 'Close Tab',
///       onInvoke: () => _closeTab(),
///     ),
///   ],
///   child: MyContent(),
/// )
/// ```
class FondeShortcutScope extends StatelessWidget {
  const FondeShortcutScope({
    super.key,
    required this.bindings,
    required this.child,
    this.autofocus = false,
  });

  /// The shortcut bindings active in this scope.
  final List<FondeShortcutBinding> bindings;

  /// The widget subtree in which shortcuts are active.
  final Widget child;

  /// Whether to request focus automatically when the scope is first built.
  /// Useful for top-level scopes that should capture keys from the start.
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final shortcuts = <ShortcutActivator, Intent>{
      for (final b in bindings) b.activator: _FondeShortcutIntent(b),
    };

    final actions = <Type, Action<Intent>>{
      _FondeShortcutIntent: CallbackAction<_FondeShortcutIntent>(
        onInvoke: (intent) {
          intent.binding.onInvoke();
          return null;
        },
      ),
    };

    Widget result = Shortcuts(
      shortcuts: shortcuts,
      child: Actions(actions: actions, child: child),
    );

    if (autofocus) {
      result = Focus(autofocus: true, child: result);
    }

    return result;
  }
}

/// A registry that collects all [FondeShortcutBinding]s from a
/// [FondeShortcutScope] subtree for display purposes (e.g. command palette,
/// keyboard shortcut overlay).
///
/// Usage: call [FondeShortcutRegistry.of] from within the subtree.
class FondeShortcutRegistry extends InheritedWidget {
  const FondeShortcutRegistry({
    super.key,
    required this.bindings,
    required super.child,
  });

  /// All bindings registered in this scope.
  final List<FondeShortcutBinding> bindings;

  static FondeShortcutRegistry? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FondeShortcutRegistry>();
  }

  @override
  bool updateShouldNotify(FondeShortcutRegistry oldWidget) {
    return bindings != oldWidget.bindings;
  }
}
