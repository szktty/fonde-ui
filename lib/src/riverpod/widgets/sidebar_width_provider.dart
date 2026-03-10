import 'package:flutter_riverpod/legacy.dart';

/// Provider that manages the width of the sidebar.
class FondeSidebarWidthNotifier extends StateNotifier<double> {
  FondeSidebarWidthNotifier() : super(320.0); // Default width

  /// Sets the width of the sidebar.
  void setWidth(double width) {
    const minWidth = 240.0;
    const maxWidth = 480.0;

    final clampedWidth = width.clamp(minWidth, maxWidth);
    if (state != clampedWidth) {
      state = clampedWidth;
    }
  }

  /// Changes the width of the sidebar relatively.
  void adjustWidth(double delta) {
    setWidth(state + delta);
  }
}

/// Primary sidebar width provider.
final sidebarWidthProvider =
    StateNotifierProvider<FondeSidebarWidthNotifier, double>(
      (ref) => FondeSidebarWidthNotifier(),
    );

/// Provider that manages the width of the secondary sidebar.
class FondeSecondarySidebarWidthNotifier extends StateNotifier<double> {
  FondeSecondarySidebarWidthNotifier() : super(288.0); // Default width

  /// Sets the width of the secondary sidebar.
  void setWidth(double width) {
    const minWidth = 200.0;
    const maxWidth = 400.0;

    final clampedWidth = width.clamp(minWidth, maxWidth);
    if (state != clampedWidth) {
      state = clampedWidth;
    }
  }

  /// Changes the width of the secondary sidebar relatively.
  void adjustWidth(double delta) {
    setWidth(state + delta);
  }
}

/// Secondary sidebar width provider.
final secondarySidebarWidthProvider =
    StateNotifierProvider<FondeSecondarySidebarWidthNotifier, double>(
      (ref) => FondeSecondarySidebarWidthNotifier(),
    );
