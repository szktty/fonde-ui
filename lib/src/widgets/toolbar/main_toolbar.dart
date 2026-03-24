import 'package:flutter/material.dart';
import '../../internal.dart';

/// A title bar placed within the main content area.
///
/// This is an application-agnostic version of the main area title bar.
/// In RinneGraph the original widget integrates a pathfinder search field
/// and stack context. Extend or replace this widget to add application-
/// specific content such as a search field or breadcrumb.
class FondeMainToolbar extends StatelessWidget {
  const FondeMainToolbar({
    super.key,
    this.leading,
    this.center,
    this.trailing,
    this.height = 50.0,
    this.leadingOffset = 0.0,
  });

  final Widget? leading;
  final Widget? center;
  final Widget? trailing;

  /// Height of the title bar. Defaults to 50.
  final double height;

  /// Extra left offset applied before [leading] (or before [center] when
  /// [leading] is null). Use this to avoid overlapping a button that is
  /// overlaid on top of the toolbar via a [Stack].
  final double leadingOffset;

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;

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
      child:
          trailing == null
              ? Row(
                children: [
                  if (leadingOffset > 0) SizedBox(width: leadingOffset),
                  if (leading != null) leading!,
                  if (center != null) Expanded(child: center!),
                ],
              )
              : _MainToolbarWithTrailing(
                leadingOffset: leadingOffset,
                leading: leading,
                center: center,
                trailing: trailing!,
              ),
    );
  }
}

/// Layout for [FondeMainToolbar] when a [trailing] widget is present.
///
/// Measures the widths of the leading widgets over two frames, then passes
/// a finite [availableWidth] to [trailing] via [FondeMainToolbarTrailingScope]
/// so that overflow-aware children (e.g. [FondeToolbarGroup]) work correctly.
class _MainToolbarWithTrailing extends StatefulWidget {
  const _MainToolbarWithTrailing({
    required this.leadingOffset,
    required this.leading,
    required this.center,
    required this.trailing,
  });

  final double leadingOffset;
  final Widget? leading;
  final Widget? center;
  final Widget trailing;

  @override
  State<_MainToolbarWithTrailing> createState() =>
      _MainToolbarWithTrailingState();
}

class _MainToolbarWithTrailingState extends State<_MainToolbarWithTrailing> {
  final _leadingKey = GlobalKey();
  double _leadingWidth = 0;
  bool _measured = false;

  void _measureLeading() {
    if (!mounted || widget.leading == null) return;
    final rb = _leadingKey.currentContext?.findRenderObject() as RenderBox?;
    if (rb != null && rb.hasSize && rb.size.width != _leadingWidth) {
      setState(() {
        _leadingWidth = rb.size.width;
        _measured = true;
      });
    } else if (!_measured) {
      // Not measured yet — retry next frame.
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureLeading());
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.leading != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureLeading());
    } else {
      _measured = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final fixedLeft = widget.leadingOffset + _leadingWidth;

        // trailing gets at most (totalWidth - fixedLeft).
        // When center is present, center fills what trailing doesn't use.
        final trailingWidth = (totalWidth - fixedLeft).clamp(0.0, totalWidth);

        return Row(
          children: [
            if (widget.leadingOffset > 0) SizedBox(width: widget.leadingOffset),
            if (widget.leading != null)
              KeyedSubtree(key: _leadingKey, child: widget.leading!),
            if (widget.center != null) Expanded(child: widget.center!),
            SizedBox(
              width: trailingWidth,
              child: Align(
                alignment: Alignment.centerRight,
                child: widget.trailing,
              ),
            ),
          ],
        );
      },
    );
  }
}
