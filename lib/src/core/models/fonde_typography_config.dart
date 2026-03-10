import 'package:flutter/material.dart';
import 'fonde_font_config.dart';

/// A class representing typography settings.
class FondeTypographyConfig {
  // UI font - covers interface elements throughout the application.
  final FondeFontConfig? uiFont;
  // Text font - for general text display in content areas.
  final FondeFontConfig? textFont;
  // Code block font - monospaced font for displaying program code and scripts.
  final FondeFontConfig? codeBlockFont;
  // Table font - for displaying tabular data and search results.
  final FondeFontConfig? tableFont;
  // Label font - for displaying labels of nodes and edges in graph databases.
  final FondeFontConfig? labelFont;

  const FondeTypographyConfig({
    this.uiFont,
    this.textFont,
    this.codeBlockFont,
    this.tableFont,
    this.labelFont,
  });

  /// Creates a copy and modifies the specified properties.
  FondeTypographyConfig copyWith({
    FondeFontConfig? uiFont,
    FondeFontConfig? textFont,
    FondeFontConfig? codeBlockFont,
    FondeFontConfig? tableFont,
    FondeFontConfig? labelFont,
    bool clearUiFont = false,
    bool clearTextFont = false,
    bool clearCodeBlockFont = false,
    bool clearTableFont = false,
    bool clearLabelFont = false,
  }) {
    return FondeTypographyConfig(
      uiFont: clearUiFont ? null : (uiFont ?? this.uiFont),
      textFont: clearTextFont ? null : (textFont ?? this.textFont),
      codeBlockFont: clearCodeBlockFont
          ? null
          : (codeBlockFont ?? this.codeBlockFont),
      tableFont: clearTableFont ? null : (tableFont ?? this.tableFont),
      labelFont: clearLabelFont ? null : (labelFont ?? this.labelFont),
    );
  }

  /// Creates an instance from JSON.
  factory FondeTypographyConfig.fromJson(Map<String, dynamic> json) {
    return FondeTypographyConfig(
      uiFont: json['uiFont'] == null
          ? null
          : FondeFontConfig.fromJson(json['uiFont'] as Map<String, dynamic>),
      textFont: json['textFont'] == null
          ? null
          : FondeFontConfig.fromJson(json['textFont'] as Map<String, dynamic>),
      codeBlockFont: json['codeBlockFont'] == null
          ? null
          : FondeFontConfig.fromJson(
              json['codeBlockFont'] as Map<String, dynamic>,
            ),
      tableFont: json['tableFont'] == null
          ? null
          : FondeFontConfig.fromJson(json['tableFont'] as Map<String, dynamic>),
      labelFont: json['labelFont'] == null
          ? null
          : FondeFontConfig.fromJson(json['labelFont'] as Map<String, dynamic>),
    );
  }

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      if (uiFont != null) 'uiFont': uiFont!.toJson(),
      if (textFont != null) 'textFont': textFont!.toJson(),
      if (codeBlockFont != null) 'codeBlockFont': codeBlockFont!.toJson(),
      if (tableFont != null) 'tableFont': tableFont!.toJson(),
      if (labelFont != null) 'labelFont': labelFont!.toJson(),
    };
  }

  /// Generates a TextTheme.
  TextTheme toTextTheme() {
    // If no UI font is available, return the default TextTheme.
    if (uiFont == null) {
      return const TextTheme();
    }

    return TextTheme(
      // Set text theme based on UI font.
      displayLarge: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 57.0,
        fontWeight: uiFont!.weight,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      displayMedium: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 45.0,
        fontWeight: uiFont!.weight,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      displaySmall: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 36.0,
        fontWeight: uiFont!.weight,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      headlineLarge: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      headlineMedium: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 28.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      headlineSmall: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      titleLarge: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 22.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      titleMedium: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      titleSmall: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      bodyLarge: TextStyle(
        fontFamily: textFont?.fontFamily ?? uiFont!.fontFamily,
        fontSize: textFont?.size ?? uiFont!.size,
        fontWeight: textFont?.weight ?? uiFont!.weight,
        letterSpacing: textFont?.letterSpacing ?? uiFont!.letterSpacing,
        height: textFont?.lineHeight ?? uiFont!.lineHeight,
      ),
      bodyMedium: TextStyle(
        fontFamily: textFont?.fontFamily ?? uiFont!.fontFamily,
        fontSize: (textFont?.size ?? uiFont!.size) - 2,
        fontWeight: textFont?.weight ?? uiFont!.weight,
        letterSpacing: textFont?.letterSpacing ?? uiFont!.letterSpacing,
        height: textFont?.lineHeight ?? uiFont!.lineHeight,
      ),
      bodySmall: TextStyle(
        fontFamily: textFont?.fontFamily ?? uiFont!.fontFamily,
        fontSize: (textFont?.size ?? uiFont!.size) - 4,
        fontWeight: textFont?.weight ?? uiFont!.weight,
        letterSpacing: textFont?.letterSpacing ?? uiFont!.letterSpacing,
        height: textFont?.lineHeight ?? uiFont!.lineHeight,
      ),
      labelLarge: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      labelMedium: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
      labelSmall: TextStyle(
        fontFamily: uiFont!.fontFamily,
        fontSize: 11.0,
        fontWeight: FontWeight.w600,
        letterSpacing: uiFont!.letterSpacing,
        height: uiFont!.lineHeight,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeTypographyConfig &&
        other.uiFont == uiFont &&
        other.textFont == textFont &&
        other.codeBlockFont == codeBlockFont &&
        other.tableFont == tableFont &&
        other.labelFont == labelFont;
  }

  @override
  int get hashCode {
    return uiFont.hashCode ^
        textFont.hashCode ^
        codeBlockFont.hashCode ^
        tableFont.hashCode ^
        labelFont.hashCode;
  }

  @override
  String toString() {
    return 'FondeTypographyConfig(uiFont: $uiFont, textFont: $textFont, codeBlockFont: $codeBlockFont, tableFont: $tableFont, labelFont: $labelFont)';
  }
}
