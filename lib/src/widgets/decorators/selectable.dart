import 'package:flutter/material.dart';
import '../../internal.dart';
import '../../core/context_extensions.dart';
import '../styling/fonde_border_radius.dart';

/// Decorator for managing selection state.
///
/// Wraps widgets to provide style changes according to the
/// selection state. By adopting the decorator pattern, selection functionality
/// is separated from other components, improving reusability.
///
/// Usage example:
/// ```dart
/// FondeSelectionDecorator(
///   isSelected: true,
///   child: FondePanel(
///     child: Text('Selectable Panel'),
///   ),
/// )
/// ```
class FondeSelectionDecorator extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// The selection state.
  final bool isSelected;

  /// Background color when selected (automatically obtained from the theme if null).
  final Color? selectedBackgroundColor;

  /// Border color when selected (automatically obtained from the theme if null).
  final Color? selectedBorderColor;

  /// Border width when selected.
  final double selectedBorderWidth;

  /// Corner radius (needs to match the child widget).
  final double? cornerRadius;

  /// Whether to disable zoom support.
  final bool disableZoom;

  const FondeSelectionDecorator({
    super.key,
    required this.child,
    required this.isSelected,
    this.selectedBackgroundColor,
    this.selectedBorderColor,
    this.selectedBorderWidth = 2.0,
    this.cornerRadius,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isSelected) {
      return child;
    }

    final colorScheme = context.fondeColorScheme;

    // Zoom support
    final zoomScale = disableZoom ? 1.0 : context.fondeZoomScale;

    // Determine the style for the selected state
    final effectiveSelectedBackgroundColor =
        selectedBackgroundColor ??
        colorScheme.interactive.list.selectedBackground.withValues(alpha: 0.1);
    final effectiveSelectedBorderColor =
        selectedBorderColor ?? colorScheme.theme.primaryColor;
    final effectiveCornerRadius =
        cornerRadius ?? FondeBorderRadiusValues.medium;
    final effectiveBorderWidth = selectedBorderWidth * zoomScale;

    // Apply overlay for the selected state
    return Container(
      decoration: BoxDecoration(
        color: effectiveSelectedBackgroundColor,
        border: Border.all(
          color: effectiveSelectedBorderColor,
          width: effectiveBorderWidth,
        ),
        borderRadius: BorderRadius.circular(effectiveCornerRadius),
      ),
      child: child,
    );
  }
}

/// Helper class for managing selection state.
///
/// Used when managing multiple selectable items.
class FondeSelectionState<T> {
  final Set<T> _selectedItems = <T>{};

  /// Set of selected items.
  Set<T> get selectedItems => Set.unmodifiable(_selectedItems);

  /// Whether an item is selected.
  bool isSelected(T item) => _selectedItems.contains(item);

  /// Select an item.
  void select(T item) => _selectedItems.add(item);

  /// Deselect an item.
  void deselect(T item) => _selectedItems.remove(item);

  /// Toggle the selection state of an item.
  void toggle(T item) {
    if (isSelected(item)) {
      deselect(item);
    } else {
      select(item);
    }
  }

  /// Clear all selections.
  void clearSelection() => _selectedItems.clear();

  /// Number of selected items.
  int get selectedCount => _selectedItems.length;

  /// Whether anything is selected.
  bool get hasSelection => _selectedItems.isNotEmpty;
}
