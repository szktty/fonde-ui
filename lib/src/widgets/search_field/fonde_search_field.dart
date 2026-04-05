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
  late FocusNode _focusNode;
  final OverlayPortalController _overlayController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  bool _isFocused = false;
  bool _hasText = false;
  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.value);
    _focusNode = FocusNode();
    _hasText = _controller.text.isNotEmpty;
    _focusNode.addListener(_handleFocusChange);
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_handleTextChange);
    }
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (!_focusNode.hasFocus) {
      _closeOverlay();
    }
  }

  void _handleTextChange() {
    final text = _controller.text;
    final hasText = text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    widget.onChange?.call(text);
    _updateSuggestions(text);
  }

  void _updateSuggestions(String text) {
    final suggestions = widget.suggestions ?? [];
    if (text.isEmpty || suggestions.isEmpty) {
      _closeOverlay();
      return;
    }
    final filtered =
        suggestions
            .where((s) => s.toLowerCase().contains(text.toLowerCase()))
            .toList();
    if (filtered.isEmpty) {
      _closeOverlay();
      return;
    }
    setState(() {
      _filteredSuggestions = filtered;
    });
    if (!_overlayController.isShowing) {
      _overlayController.show();
    }
  }

  void _closeOverlay() {
    if (_overlayController.isShowing) {
      _overlayController.hide();
    }
  }

  void _selectSuggestion(String value) {
    _controller.text = value;
    _controller.selection = TextSelection.collapsed(offset: value.length);
    _closeOverlay();
    widget.onSuggestionTap?.call(value);
    _focusNode.unfocus();
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

    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: (overlayContext) {
        return CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, 32.0 * zoomScale + 4.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: _SuggestionList(
              options: _filteredSuggestions,
              zoomScale: zoomScale,
              borderScale: borderScale,
              appColorScheme: appColorScheme,
              onSelected: _selectSuggestion,
            ),
          ),
        );
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: CustomPaint(
          foregroundPainter:
              _isFocused
                  ? _OuterBorderPainter(
                    color: activeBorderColor,
                    borderWidth: 2.0 * borderScale,
                    cornerRadius: 8.0 * zoomScale,
                  )
                  : null,
          child: SizedBox(
            width: double.infinity,
            height: 32.0 * zoomScale,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 8.0 * zoomScale,
                    cornerSmoothing: 0.6,
                  ),
                  side: BorderSide(
                    color: _isFocused ? Colors.transparent : borderColor,
                    width: borderScale,
                  ),
                ),
              ),
              child: TextSelectionTheme(
                data: TextSelectionThemeData(
                  selectionColor: selectionColor.withAlpha(100),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  cursorColor: cursorColor,
                  onTap: () {
                    // On desktop, a single click does not always place the cursor.
                    // Force selection to ensure the cursor becomes visible.
                    final text = _controller.text;
                    _controller.selection = TextSelection.collapsed(
                      offset:
                          _controller.selection.isValid
                              ? _controller.selection.baseOffset
                              : text.length,
                    );
                  },
                  onSubmitted: (value) {
                    _closeOverlay();
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
                                _controller.clear();
                                _closeOverlay();
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
            ),
          ),
        ),
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({
    required this.options,
    required this.zoomScale,
    required this.borderScale,
    required this.appColorScheme,
    required this.onSelected,
  });

  final List<String> options;
  final double zoomScale;
  final double borderScale;
  final FondeColorScheme appColorScheme;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    final radius = FondeBorderRadius.small();
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 200.0 * zoomScale,
          maxWidth: 300.0 * zoomScale,
        ),
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
              final option = options[index];
              return InkWell(
                onTap: () => onSelected(option),
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
    );
  }
}

class _OuterBorderPainter extends CustomPainter {
  const _OuterBorderPainter({
    required this.color,
    required this.borderWidth,
    required this.cornerRadius,
  });

  final Color color;
  final double borderWidth;
  final double cornerRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth;

    final expand = borderWidth / 2;
    final rect = Rect.fromLTWH(
      -expand,
      -expand,
      size.width + borderWidth,
      size.height + borderWidth,
    );

    final path = SmoothRectangleBorder(
      borderRadius: SmoothBorderRadius(
        cornerRadius: cornerRadius + expand,
        cornerSmoothing: 0.6,
      ),
    ).getOuterPath(rect);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_OuterBorderPainter oldDelegate) =>
      color != oldDelegate.color ||
      borderWidth != oldDelegate.borderWidth ||
      cornerRadius != oldDelegate.cornerRadius;
}
