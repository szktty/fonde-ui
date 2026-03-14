import 'package:flutter/material.dart';

/// A class representing font settings.
class FondeFontConfig {
  final String fontFamily;
  final FontWeight weight;
  final double size;
  final double lineHeight;
  final double letterSpacing;

  const FondeFontConfig({
    required this.fontFamily,
    this.weight = FontWeight.w400,
    this.size = 14.0,
    this.lineHeight = 1.2,
    this.letterSpacing = 0.0,
  });

  /// Creates a copy and modifies the specified properties.
  FondeFontConfig copyWith({
    String? fontFamily,
    FontWeight? weight,
    double? size,
    double? lineHeight,
    double? letterSpacing,
  }) {
    return FondeFontConfig(
      fontFamily: fontFamily ?? this.fontFamily,
      weight: weight ?? this.weight,
      size: size ?? this.size,
      lineHeight: lineHeight ?? this.lineHeight,
      letterSpacing: letterSpacing ?? this.letterSpacing,
    );
  }

  /// Creates an instance from JSON.
  factory FondeFontConfig.fromJson(Map<String, dynamic> json) {
    return FondeFontConfig(
      fontFamily: json['fontFamily'] as String,
      weight:
          json['weight'] == null
              ? FontWeight.w400
              : FontWeight.values[(json['weight'] as int) ~/ 100 - 1],
      size: (json['size'] as num?)?.toDouble() ?? 14.0,
      lineHeight: (json['lineHeight'] as num?)?.toDouble() ?? 1.2,
      letterSpacing: (json['letterSpacing'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'fontFamily': fontFamily,
      'weight': weight.index * 100 + 100,
      'size': size,
      'lineHeight': lineHeight,
      'letterSpacing': letterSpacing,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeFontConfig &&
        other.fontFamily == fontFamily &&
        other.weight == weight &&
        other.size == size &&
        other.lineHeight == lineHeight &&
        other.letterSpacing == letterSpacing;
  }

  @override
  int get hashCode {
    return fontFamily.hashCode ^
        weight.hashCode ^
        size.hashCode ^
        lineHeight.hashCode ^
        letterSpacing.hashCode;
  }

  @override
  String toString() {
    return 'FondeFontConfig(fontFamily: $fontFamily, weight: $weight, size: $size, lineHeight: $lineHeight, letterSpacing: $letterSpacing)';
  }
}
