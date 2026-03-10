import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/internal.dart';

/// Riverpod-dependent extension methods for [FondeTextStyleBuilder].
extension FondeTextStyleBuilderRef on FondeTextStyleBuilder {
  /// Build a TextStyle from an FondeTextVariant using a [WidgetRef].
  ///
  /// [variant] - The text variant.
  /// [context] - BuildContext (for getting TextTheme).
  /// [ref] - WidgetRef (for getting accessibility config and color scope).
  /// [color] - Custom text color (optional).
  /// [fontWeight] - Custom font weight (optional).
  /// [fontFamily] - Custom font family (optional).
  /// [disableZoom] - Whether to disable the zoom function (default: false).
  static TextStyle buildTextStyle({
    required FondeTextVariant variant,
    required BuildContext context,
    required WidgetRef ref,
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    bool disableZoom = false,
  }) {
    return FondeTextStyleBuilder.buildTextStyle(
      variant: variant,
      context: context,
      ref: ref,
      color: color,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      disableZoom: disableZoom,
    );
  }

  /// Build a TextStyle with a specific color using a [WidgetRef].
  static TextStyle buildTextStyleWithColor({
    required FondeTextVariant variant,
    required BuildContext context,
    required WidgetRef ref,
    required Color color,
    FontWeight? fontWeight,
    String? fontFamily,
    bool disableZoom = false,
  }) {
    return FondeTextStyleBuilder.buildTextStyleWithColor(
      variant: variant,
      context: context,
      ref: ref,
      color: color,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      disableZoom: disableZoom,
    );
  }
}
