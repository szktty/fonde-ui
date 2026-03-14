import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../internal.dart';

part 'fonde_container.g.dart';

/// A container widget with app-specific padding.
///
/// This container applies consistent padding throughout the app.
/// Any widget can be placed on the left side, and its horizontal size
/// will be adjusted to match the fixed left padding.
///
/// Example:
/// ```dart
/// FondeContainer(
///   leadingWidget: Icon(Icons.drag_indicator),
///   child: Text('Content'),
/// )
/// ```
class FondeContainer extends ConsumerWidget {
  /// Default horizontal padding.
  static const double defaultHorizontalPadding = 16.0;

  /// Default vertical padding.
  static const double defaultVerticalPadding = 8.0;

  /// Constructor.
  const FondeContainer({
    super.key,
    required this.child,
    this.title,
    this.showTitleDivider = true,
    this.leadingWidget,
    this.padding,
    this.color,
    this.decoration,
    this.width,
    this.height,
    this.alignment,
    this.leadingWidth,
    this.disableZoom = false,
  });

  /// Child widget.
  final Widget child;

  /// Title (displayed at the top).
  final String? title;

  /// Whether to show a divider below the title.
  final bool showTitleDivider;

  /// Widget to display on the left side.
  final Widget? leadingWidget;

  /// Custom padding (uses default values if not specified).
  final EdgeInsetsGeometry? padding;

  /// Background color.
  final Color? color;

  /// Decoration.
  final Decoration? decoration;

  /// Width of the container.
  final double? width;

  /// Height of the container.
  final double? height;

  /// Alignment of the child widget.
  final AlignmentGeometry? alignment;

  /// Width of the leading widget (uses defaultHorizontalPadding if not specified).
  final double? leadingWidth;

  /// Whether to disable zoom functionality.
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get accessibility settings
    final accessibilityConfig = ref.watch(fondeAccessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    // Default padding (zoom scale applied)
    final effectivePadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: defaultHorizontalPadding * zoomScale,
          vertical: defaultVerticalPadding * zoomScale,
        );

    // Widget for the title section
    Widget? titleWidget;
    if (title != null) {
      titleWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: effectivePadding.horizontal,
              right: effectivePadding.horizontal,
              top: effectivePadding.vertical,
              bottom: 8.0 * zoomScale,
            ),
            child: Text(
              title!,
              style: TextStyle(
                fontSize: 16.0 * zoomScale,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (showTitleDivider) ...[
            Divider(
              height: 1,
              thickness: 1,
              indent: effectivePadding.horizontal,
              endIndent: effectivePadding.horizontal,
            ),
            SizedBox(height: 12.0 * zoomScale),
          ],
        ],
      );
    }

    // Width of the leading widget (zoom scale applied)
    final effectiveLeadingWidth = leadingWidth != null
        ? leadingWidth! * zoomScale
        : defaultHorizontalPadding * zoomScale;

    // Build layout
    Widget content;
    if (leadingWidget != null) {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Leading widget - fixed width
          SizedBox(
            width: effectiveLeadingWidth,
            child: Center(child: leadingWidget),
          ),
          // Child widget - fills remaining space
          Expanded(
            child: Padding(
              // If there is a leading widget, set left padding to 0
              padding: EdgeInsets.only(
                top: effectivePadding.vertical / 2,
                right: effectivePadding.horizontal,
                bottom: effectivePadding.vertical / 2,
                left: 0,
              ),
              child: child,
            ),
          ),
        ],
      );
    } else {
      // If there is no leading widget, apply normal padding
      // If there is a title, adjust the top padding
      final contentPadding = title != null
          ? EdgeInsets.only(
              left: effectivePadding.horizontal,
              right: effectivePadding.horizontal,
              bottom: effectivePadding.vertical,
            )
          : effectivePadding;
      content = Padding(padding: contentPadding, child: child);
    }

    // Set default background color (if color or decoration is not specified)
    // Use the background color from the color scope, make it transparent if not explicitly specified
    final effectiveColor =
        color ?? (decoration == null ? Colors.transparent : null);

    // Container decoration
    final containerChild = title != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget!,
              Expanded(child: content),
            ],
          )
        : content;

    return Container(
      width: width,
      height: height,
      color: effectiveColor,
      decoration: decoration,
      alignment: alignment,
      child: containerChild,
    );
  }
}

/// Provider that supplies the default padding for FondeContainer.
@riverpod
EdgeInsetsGeometry fondeContainerPadding(Ref ref) {
  return const EdgeInsets.symmetric(
    horizontal: FondeContainer.defaultHorizontalPadding,
    vertical: FondeContainer.defaultVerticalPadding,
  );
}

/// Provider that supplies the leading widget width for FondeContainer.
@riverpod
double fondeContainerLeadingWidth(Ref ref) {
  return FondeContainer.defaultHorizontalPadding;
}
