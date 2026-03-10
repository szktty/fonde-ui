import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart' as sf;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal.dart';

import '../icons/icon_theme_providers.dart';
import '../widgets/fonde_icon_button.dart';

/// A platform-adaptive search field widget with suggestions support.
class FondeSearchField extends ConsumerWidget {
  const FondeSearchField({
    this.onClear,
    this.suggestions,
    this.onSuggestionTap,
    this.onSubmit,
    this.hint = '',
    this.enabled = true,
    this.value,
    this.onSaved,
    this.onChange,
    super.key,
  });

  /// The list of suggestions to show.
  final List<String>? suggestions;

  /// Called when a suggestion is tapped.
  final void Function(String)? onSuggestionTap;

  /// Called when the search field is submitted.
  final void Function(String)? onSubmit;

  /// The hint text to show when the search field is empty.
  final String hint;

  /// Whether the search field is enabled.
  final bool enabled;

  /// The current value of the search field.
  final String? value;

  /// Called when the text changes.
  final void Function(String?)? onSaved;

  /// Called when the text changes in real-time.
  final void Function(String)? onChange;

  /// Called when the clear button is tapped.
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildMaterial(context, ref);
  }

  Widget _buildMaterial(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(fondeAccessibilityConfigProvider);
    final iconTheme = ref.watch(fondeDefaultIconThemeProvider);
    final zoomScale = accessibilityConfig.zoomScale;
    final borderScale = accessibilityConfig.borderScale;
    final controller = TextEditingController(text: value);
    final bool hasText = value != null;

    // Set onChange callback
    controller.addListener(() {
      onChange?.call(controller.text);
    });

    return sf.SearchField(
      controller: controller,
      // Added
      suggestions:
          suggestions?.map((s) => sf.SearchFieldListItem(s)).toList() ?? [],
      suggestionsDecoration: sf.SuggestionDecoration(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0 * zoomScale,
          vertical: 4.0 * zoomScale,
        ),
        borderRadius: BorderRadius.circular(8.0 * borderScale),
      ),
      onSuggestionTap: onSuggestionTap == null
          ? null
          : (item) => onSuggestionTap?.call(item.searchKey),
      onSubmit: onSubmit,
      onSaved: onSaved,
      // Added
      searchInputDecoration: sf.SearchInputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          iconTheme.search,
          color: appColorScheme.uiAreas.sideBar.inactiveItemText,
          size: 20.0 * zoomScale,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0 * borderScale),
          borderSide: BorderSide(
            color: appColorScheme.base.divider,
            width: borderScale,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0 * borderScale),
          borderSide: BorderSide(
            color: appColorScheme.base.divider,
            width: borderScale,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0 * borderScale),
          borderSide: BorderSide(
            color: appColorScheme.theme.primaryColor,
            width: borderScale,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12.0 * zoomScale,
          vertical: 8.0 * zoomScale,
        ),
        suffixIcon: hasText && onClear != null
            ? FondeIconButton.circle(
                icon: iconTheme.x,
                iconSize: 16.0 * zoomScale,
                iconColor: appColorScheme.base.foreground,
                backgroundColor: appColorScheme.base.border,
                constraints: BoxConstraints.tightFor(
                  width: 24.0 * zoomScale,
                  height: 24.0 * zoomScale,
                ),
                onPressed: () {
                  controller.clear();
                  onClear?.call();
                },
                tooltip: 'Clear',
              )
            : null,
      ),
      enabled: enabled,
    );
  }
}
