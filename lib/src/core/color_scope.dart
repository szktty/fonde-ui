import 'package:flutter/material.dart';
import 'models/fonde_color_scheme.dart';

/// Standard color definitions provided by the color scope.
///
/// Provides color abstraction based on context to improve component
/// reusability and maintainability.
class FondeColorScope {
  final Color text;
  final Color background;
  final Color border;
  final Color selection;

  /// Subtle selection background (light grey, used with accent-colored text).
  final Color subtleSelection;

  final Color hover;
  final Color accent;
  final Color disabled;

  const FondeColorScope({
    required this.text,
    required this.background,
    required this.border,
    required this.selection,
    required this.subtleSelection,
    required this.hover,
    required this.accent,
    required this.disabled,
  });

  FondeColorScope copyWith({
    Color? text,
    Color? background,
    Color? border,
    Color? selection,
    Color? subtleSelection,
    Color? hover,
    Color? accent,
    Color? disabled,
  }) {
    return FondeColorScope(
      text: text ?? this.text,
      background: background ?? this.background,
      border: border ?? this.border,
      selection: selection ?? this.selection,
      subtleSelection: subtleSelection ?? this.subtleSelection,
      hover: hover ?? this.hover,
      accent: accent ?? this.accent,
      disabled: disabled ?? this.disabled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FondeColorScope &&
        other.text == text &&
        other.background == background &&
        other.border == border &&
        other.selection == selection &&
        other.subtleSelection == subtleSelection &&
        other.hover == hover &&
        other.accent == accent &&
        other.disabled == disabled;
  }

  @override
  int get hashCode => Object.hash(
    text,
    background,
    border,
    selection,
    subtleSelection,
    hover,
    accent,
    disabled,
  );

  @override
  String toString() =>
      'ColorScope('
      'text: $text, background: $background, border: $border, '
      'selection: $selection, subtleSelection: $subtleSelection, '
      'hover: $hover, accent: $accent, disabled: $disabled)';
}
