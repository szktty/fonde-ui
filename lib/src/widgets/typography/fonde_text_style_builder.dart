import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal.dart';
import 'fonde_text.dart';

/// A utility class that builds a TextStyle from an FondeTextVariant.
///
/// Generates a TextStyle using the same logic as the FondeText component.
/// This allows it to automatically follow changes in the FondeTextVariant
/// specification.
class FondeTextStyleBuilder {
  /// Build a TextStyle from an FondeTextVariant.
  ///
  /// [variant] - The text variant.
  /// [context] - BuildContext (for getting TextTheme).
  /// [ref] - WidgetRef (for getting color scope).
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
    // Get text style from ThemeData
    final flutterTheme = Theme.of(context);
    final accessibilityConfig = ref.watch(fondeAccessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    return _buildTextStyle(
      variant,
      flutterTheme.textTheme,
      flutterTheme.colorScheme,
      zoomScale,
      ref,
      color: color,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
    );
  }

  /// Build a TextStyle from an FondeTextVariant (internal implementation).
  ///
  /// Same logic as the _buildTextStyle method of the FondeText component.
  static TextStyle _buildTextStyle(
    FondeTextVariant variant,
    TextTheme textTheme,
    ColorScheme colorScheme,
    double zoomScale,
    WidgetRef ref, {
    Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
  }) {
    // Get typography settings from the active theme
    final baseStyle = switch (variant) {
      // === New role-based variants ===

      // For UI structure
      FondeTextVariant.pageTitle => textTheme.headlineLarge,

      // Dialog title (by importance)
      FondeTextVariant.dialogTitleCritical => textTheme.headlineMedium, // 28px
      FondeTextVariant.dialogTitleStandard => textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ), // 16px Bold
      FondeTextVariant.dialogTitleUtility => textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ), // 16px Bold
      // Section title (by importance)
      FondeTextVariant.sectionTitlePrimary => textTheme.headlineSmall, // 24px
      FondeTextVariant.sectionTitleSecondary => textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ), // 16px Bold
      FondeTextVariant.sectionTitleUtility => textTheme.bodyMedium, // 16px

      FondeTextVariant.itemTitle => textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),

      // For interaction
      FondeTextVariant.buttonLabel => textTheme.bodyMedium,
      FondeTextVariant.labelText => textTheme.bodyMedium,
      FondeTextVariant.inputText => textTheme.bodyMedium,

      // For information display
      FondeTextVariant.bodyText => textTheme.bodyMedium,
      FondeTextVariant.captionText => textTheme.bodySmall,
      FondeTextVariant.smallText => textTheme.labelSmall,

      FondeTextVariant.uiCaption => textTheme.bodySmall,

      // For tables (extended)
      FondeTextVariant.tableTitle => textTheme.titleLarge,
      FondeTextVariant.tableHeader => textTheme.titleMedium,
      FondeTextVariant.tableBody => textTheme.bodyMedium,
      FondeTextVariant.tableCell => textTheme.bodyMedium,
      FondeTextVariant.tableCellEditing => textTheme.bodyMedium,
      FondeTextVariant.tableRowHeader => textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      FondeTextVariant.tableCellSmall => textTheme.bodySmall,

      // === Existing variants (content scale) ===

      // For user-generated content
      FondeTextVariant.textHeading1 => textTheme.displayLarge,
      FondeTextVariant.textHeading2 => textTheme.displayMedium,
      FondeTextVariant.textHeading3 => textTheme.displaySmall,
      FondeTextVariant.textHeading4 => textTheme.headlineSmall,
      FondeTextVariant.textBody => textTheme.bodyLarge,
      FondeTextVariant.textCaption => textTheme.bodyMedium,
      FondeTextVariant.textSmall => textTheme.bodySmall,

      // Code block related
      FondeTextVariant.codeBlock => textTheme.bodyMedium?.copyWith(
        fontFamily: 'monospace',
      ),
      FondeTextVariant.codeInline => textTheme.bodySmall?.copyWith(
        fontFamily: 'monospace',
      ),

      // === Existing special variants ===

      // Table related (existing)
      FondeTextVariant.tableFooter => textTheme.bodySmall,

      // Label related
      FondeTextVariant.entityLabelPrimary => textTheme.labelLarge,
      FondeTextVariant.entityLabelSecondary => textTheme.labelMedium,
      FondeTextVariant.entityLabelMeta => textTheme.labelSmall,

      // Page title related (existing)
      FondeTextVariant.pageTitleLarge => textTheme.headlineLarge,
      FondeTextVariant.pageTitleMedium => textTheme.headlineSmall,
      FondeTextVariant.pageTitleSmall => textTheme.bodyLarge,
    };

    // Try to get the color scope
    Color textColor;
    try {
      final colorScope = ref.read(fondeColorScopeProvider);
      textColor = color ?? colorScope.text;
    } catch (e) {
      // Fallback if color scope is not available
      textColor = color ?? colorScheme.onSurface;
    }

    final scaledStyle = (baseStyle ?? const TextStyle()).copyWith(
      color: textColor,
      fontWeight: fontWeight, // Apply fontWeight
      fontFamily: fontFamily, // Apply custom font family
    );

    // Apply zoom scale to the font size
    if (scaledStyle.fontSize != null) {
      return scaledStyle.copyWith(fontSize: scaledStyle.fontSize! * zoomScale);
    }

    return scaledStyle;
  }

  /// Helper method to build a TextStyle with a specific color.
  ///
  /// Applies the specified color directly without using a color scope.
  static TextStyle buildTextStyleWithColor({
    required FondeTextVariant variant,
    required BuildContext context,
    required WidgetRef ref,
    required Color color,
    FontWeight? fontWeight,
    String? fontFamily,
    bool disableZoom = false,
  }) {
    return buildTextStyle(
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
