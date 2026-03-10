import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal.dart';

/// A title bar placed within the main content area.
///
/// This is an application-agnostic version of the main area title bar.
/// In RinneGraph the original widget integrates a pathfinder search field
/// and stack context. Extend or replace this widget to add application-
/// specific content such as a search field or breadcrumb.
class FondeMainToolbar extends ConsumerWidget {
  const FondeMainToolbar({
    super.key,
    this.leading,
    this.center,
    this.trailing,
    this.height = 50.0,
  });

  final Widget? leading;
  final Widget? center;
  final Widget? trailing;

  /// Height of the title bar. Defaults to 50.
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(fondeEffectiveColorSchemeProvider);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: appColorScheme.uiAreas.toolbar.background,
        border: Border(
          bottom: BorderSide(
            color: appColorScheme.uiAreas.toolbar.border,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          if (leading != null) leading!,
          if (center != null) Expanded(child: center!),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
