/// A class representing accessibility settings.
class FondeAccessibilityConfig {
  /// Font size scaling factor (1.0 is standard).
  final double fontScale;

  /// Zoom factor for UI elements (1.0 is standard).
  final double zoomScale;

  /// Border thickness scaling factor (1.0 is standard).
  final double borderScale;

  /// Enable/disable high contrast mode.
  final bool highContrastMode;

  /// Creates an accessibility configuration with default values.
  const FondeAccessibilityConfig({
    this.fontScale = 1.0,
    this.zoomScale = 1.0,
    this.borderScale = 1.0,
    this.highContrastMode = false,
  });

  /// Creates a copy and modifies the specified properties.
  FondeAccessibilityConfig copyWith({
    double? fontScale,
    double? zoomScale,
    double? borderScale,
    bool? highContrastMode,
  }) {
    return FondeAccessibilityConfig(
      fontScale: fontScale ?? this.fontScale,
      zoomScale: zoomScale ?? this.zoomScale,
      borderScale: borderScale ?? this.borderScale,
      highContrastMode: highContrastMode ?? this.highContrastMode,
    );
  }

  /// Creates an instance from JSON.
  factory FondeAccessibilityConfig.fromJson(Map<String, dynamic> json) {
    return FondeAccessibilityConfig(
      fontScale: (json['fontScale'] as num?)?.toDouble() ?? 1.0,
      zoomScale: (json['zoomScale'] as num?)?.toDouble() ?? 1.0,
      borderScale: (json['borderScale'] as num?)?.toDouble() ?? 1.0,
      highContrastMode: json['highContrastMode'] as bool? ?? false,
    );
  }

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'fontScale': fontScale,
      'zoomScale': zoomScale,
      'borderScale': borderScale,
      'highContrastMode': highContrastMode,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeAccessibilityConfig &&
        other.fontScale == fontScale &&
        other.zoomScale == zoomScale &&
        other.borderScale == borderScale &&
        other.highContrastMode == highContrastMode;
  }

  @override
  int get hashCode {
    return fontScale.hashCode ^
        zoomScale.hashCode ^
        borderScale.hashCode ^
        highContrastMode.hashCode;
  }

  @override
  String toString() {
    return 'FondeAccessibilityConfig(fontScale: $fontScale, zoomScale: $zoomScale, borderScale: $borderScale, highContrastMode: $highContrastMode)';
  }
}
