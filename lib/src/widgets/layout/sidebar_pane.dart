import 'package:flutter/material.dart';
import '../toolbar/primary_sidebar_toolbar.dart';

/// A pane that combines a toolbar and sidebar content.
///
/// Used as the [sidebar] of [FondePrimarySide].
class FondeSidebarPane extends StatelessWidget {
  const FondeSidebarPane({required this.child, this.toolbar, super.key});

  /// The sidebar content widget (e.g., [FondeSidebarList]).
  final Widget child;

  /// The toolbar widget shown at the top of the pane.
  /// Defaults to [FondePrimarySidebarToolbar] if not specified.
  final Widget? toolbar;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        toolbar ?? const FondePrimarySidebarToolbar(),
        Expanded(child: child),
      ],
    );
  }
}
