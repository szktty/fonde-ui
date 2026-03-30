import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import '../../internal.dart';
import '../widgets/fonde_icon_button.dart';
import '../widgets/fonde_rectangle_border.dart';

/// A platform-adaptive search field widget with suggestions support.
class FondeSearchField extends StatefulWidget {
  const FondeSearchField({
    super.key,
    this.controller,
    this.onClear,
    this.suggestions,
    this.onSuggestionTap,
    this.onSubmit,
    this.hint = '',
    this.enabled = true,
    this.value,
    this.onChange,
  });

  /// External controller (optional). If not provided, managed internally.
  final TextEditingController? controller;

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

  /// Called when the text changes in real-time.
  final void Function(String)? onChange;

  /// Called when the clear button is tapped.
  final VoidCallback? onClear;

  @override
  State<FondeSearchField> createState() => _FondeSearchFieldState();
}

class _FondeSearchFieldState extends State<FondeSearchField> {
  late TextEditingController _controller;
  bool _isFocused = false;
  bool _hasText = false;
  // The actual focus node passed by Autocomplete's fieldViewBuilder.
  FocusNode? _fieldFocusNode;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.value);
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_handleTextChange);
    }
    _fieldFocusNode?.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _attachFocusNode(FocusNode node) {
    if (_fieldFocusNode == node) return;
    _fieldFocusNode?.removeListener(_handleFocusChange);
    _fieldFocusNode = node;
    _fieldFocusNode!.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _fieldFocusNode?.hasFocus ?? false;
    });
  }

  void _handleTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    widget.onChange?.call(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final accessibilityConfig = context.fondeAccessibility;
    final iconTheme = context.fondeIconTheme;
    final zoomScale = accessibilityConfig.zoomScale;
    final borderScale = accessibilityConfig.borderScale;

    final borderColor = appColorScheme.base.divider;
    final activeBorderColor = appColorScheme.theme.primaryColor;
    final cursorColor = appColorScheme.base.foreground;
    final selectionColor = appColorScheme.base.border;

    final effectiveSuggestions = widget.suggestions ?? [];

    Widget fieldView(
      BuildContext fieldContext,
      TextEditingController fieldController,
      FocusNode fieldFocusNode,
      VoidCallback onFieldSubmitted,
    ) {
      _attachFocusNode(fieldFocusNode);
      if (widget.controller != null &&
          fieldController.text != _controller.text) {
        fieldController.text = _controller.text;
      }

      return FondeRectangleBorder(
        cornerRadius: 8.0 * zoomScale,
        width: double.infinity,
        height: 32.0 * zoomScale,
        side: BorderSide(
          color: _isFocused ? Colors.transparent : borderColor,
          width: borderScale,
        ),
        outerSide:
            _isFocused
                ? BorderSide(color: activeBorderColor, width: 2.0 * borderScale)
                : null,
        child: TextSelectionTheme(
          data: TextSelectionThemeData(
            selectionColor: selectionColor.withAlpha(100),
          ),
          child: TextField(
            controller: fieldController,
            focusNode: fieldFocusNode,
            enabled: widget.enabled,
            cursorColor: cursorColor,
            onSubmitted: (value) {
              onFieldSubmitted();
              widget.onSubmit?.call(value);
            },
            decoration: InputDecoration(
              hintText: widget.hint,
              prefixIcon: Icon(
                iconTheme.search,
                color: appColorScheme.uiAreas.sideBar.inactiveItemText,
                size: 16.0 * zoomScale,
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 32.0 * zoomScale,
                minHeight: 32.0 * zoomScale,
              ),
              suffixIcon:
                  _hasText && widget.onClear != null
                      ? FondeIconButton.circle(
                        icon: iconTheme.x,
                        iconSize: 14.0 * zoomScale,
                        iconColor: appColorScheme.base.foreground,
                        backgroundColor: appColorScheme.base.border,
                        constraints: BoxConstraints.tightFor(
                          width: 20.0 * zoomScale,
                          height: 20.0 * zoomScale,
                        ),
                        onPressed: () {
                          fieldController.clear();
                          widget.onClear?.call();
                        },
                        tooltip: 'Clear',
                      )
                      : null,
              suffixIconConstraints:
                  _hasText && widget.onClear != null
                      ? BoxConstraints(
                        minWidth: 32.0 * zoomScale,
                        maxWidth: 32.0 * zoomScale,
                        minHeight: 32.0 * zoomScale,
                        maxHeight: 32.0 * zoomScale,
                      )
                      : null,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.0 * zoomScale,
                vertical: 4.0 * zoomScale,
              ),
            ),
          ),
        ),
      );
    }

    Widget optionsView(
      BuildContext context,
      AutocompleteOnSelected<String> onSelected,
      Iterable<String> options,
    ) {
      final radius = FondeBorderRadius.small();
      return Align(
        alignment: Alignment.topLeft,
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: 200.0 * zoomScale,
              maxWidth: 300.0 * zoomScale,
            ),
            margin: EdgeInsets.only(top: 4.0 * zoomScale),
            decoration: ShapeDecoration(
              color: appColorScheme.uiAreas.sideBar.background,
              shape: SmoothRectangleBorder(
                borderRadius: radius.toSmoothBorderRadius(),
                side: BorderSide(
                  color: appColorScheme.base.divider,
                  width: borderScale,
                ),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipSmoothRect(
              radius: radius.toSmoothBorderRadius(),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 4.0 * zoomScale),
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return InkWell(
                    onTap: () {
                      onSelected(option);
                      widget.onSuggestionTap?.call(option);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.0 * zoomScale,
                        vertical: 6.0 * zoomScale,
                      ),
                      child: Text(option),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    }

    return Autocomplete<String>(
      initialValue: TextEditingValue(text: widget.value ?? ''),
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text.isEmpty || effectiveSuggestions.isEmpty) {
          return const [];
        }
        return effectiveSuggestions.where(
          (s) => s.toLowerCase().contains(textEditingValue.text.toLowerCase()),
        );
      },
      onSelected: (value) {
        widget.onSuggestionTap?.call(value);
      },
      fieldViewBuilder: fieldView,
      optionsViewBuilder: optionsView,
    );
  }
}
