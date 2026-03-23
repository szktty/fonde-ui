import '../../internal.dart';
import 'package:flutter/material.dart';
import '../../core/context_extensions.dart';

/// The available text variants for FondeText.
///
/// These variants map to different font categories and styles within the application.
/// Each variant represents a specific use case and may use different font families
/// depending on the active theme settings.
enum FondeTextVariant {
  // === New role-based variants (component role) ===

  // For UI structure
  pageTitle, // Page title (headlineLarge, 32px)
  // Dialog titles (by importance)
  dialogTitleCritical, // Critical dialog title (headlineMedium, 28px) - errors, warnings, destructive actions
  dialogTitleStandard, // Standard dialog title (bodyMedium Bold, 16px) - settings, forms, general actions
  dialogTitleUtility, // Utility dialog title (bodyMedium Bold, 16px) - filters, search, auxiliary functions
  // Section titles (by importance)
  sectionTitlePrimary, // Primary section title (headlineSmall, 24px) - main content area
  sectionTitleSecondary, // Secondary section title (bodyMedium Bold, 16px) - sidebar, panels
  sectionTitleUtility, // Utility section title (bodyMedium, 16px) - filters, lightweight sections

  itemTitle, // List/grid item name (bodyMedium Bold, 16px)
  // For interaction
  buttonLabel, // Button label (bodyMedium, 16px)
  labelText, // Form element label (bodyMedium, 16px)
  inputText, // Text field input (bodyMedium, 16px)
  // For information display
  bodyText, // Standard text/description (bodyMedium, 16px)
  captionText, // Auxiliary info/small description (bodySmall, 14px)
  smallText, // Small label/badge (labelSmall, 11px)
  /// UI component caption text (14px, for table headers/cells and compact UI elements)
  uiCaption,
  // For table (extended)
  tableTitle, // Table title (titleLarge)
  tableHeader, // Table header (titleMedium)
  tableBody, // Table body (bodyMedium)
  tableCell, // Normal cell (bodyMedium)
  tableCellEditing, // Editing cell (bodyMedium)
  tableRowHeader, // Row header (bodyMedium Bold)
  tableCellSmall, // Small cell content (bodySmall)
  // === Existing variants (content scale) ===

  // For user-generated content (existing)
  textHeading1, // Document top-level heading
  textHeading2, // Chapter title
  textHeading3, // Section title
  textHeading4, // Subtitle/catchphrase
  textBody, // Body text
  textCaption, // Caption
  textSmall, // Supplementary text (content area)
  // Code block related (existing)
  codeBlock, // Code block body
  codeInline, // Inline code
  // === Existing special variants (maintained) ===

  // Table related (existing)
  tableFooter, // Table footer
  // Label related (renamed)
  entityLabelPrimary, // labelPrimary -> entityLabelPrimary
  entityLabelSecondary, // labelSecondary -> entityLabelSecondary
  entityLabelMeta, // labelMeta -> entityLabelMeta
  // Page title related (existing)
  pageTitleLarge, // Page title (large)
  pageTitleMedium, // Page title (medium)
  pageTitleSmall, // Page title (small, normal text size)
}

/// A text widget that automatically applies typography styles based on the app theme.
class FondeText extends StatelessWidget {
  final String text;
  final FondeTextVariant variant;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;

  /// Custom font family
  final String? fontFamily;

  /// Whether to disable zoom functionality
  final bool disableZoom;

  const FondeText(
    this.text, {
    required this.variant,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    this.fontFamily,
    this.disableZoom = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get accessibility settings
    final zoomScale = disableZoom ? 1.0 : context.fondeZoomScale;

    // Get text style from ThemeData
    final flutterTheme = Theme.of(context);

    return Text(
      text,
      style: _buildTextStyle(
        flutterTheme.textTheme,
        flutterTheme.colorScheme,
        zoomScale,
        context,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle _buildTextStyle(
    TextTheme textTheme,
    ColorScheme colorScheme,
    double zoomScale,
    BuildContext context,
  ) {
    // Get typography settings from active theme
    final baseStyle = switch (variant) {
      // === New role-based variants ===

      // For UI structure
      FondeTextVariant.pageTitle => textTheme.headlineLarge,

      // Dialog titles (by importance)
      FondeTextVariant.dialogTitleCritical => textTheme.headlineMedium, // 28px
      FondeTextVariant.dialogTitleStandard => textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ), // 16px Bold
      FondeTextVariant.dialogTitleUtility => textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ), // 16px Bold
      // Section titles (by importance)
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

      // For table (extended)
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

    // Try to get color scope
    Color textColor;
    try {
      final colorScope = context.fondeColorScope;
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
}
