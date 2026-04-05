import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../internal.dart';
import '../text_field/focus_ring_painter.dart';
import '../widgets/fonde_icon_button.dart';

/// A platform-adaptive search field widget with suggestions support.
class FondeSearchField extends StatefulWidget {
  const FondeSearchField({
    super.key,
    this.controller,
    this.onClear,
    this.suggestionOverlayBuilder,
    this.onSubmit,
    this.hint = '',
    this.enabled = true,
    this.value,
    this.onChange,
  });

  /// External controller (optional). If not provided, managed internally.
  final TextEditingController? controller;

  /// Builder for the suggestion overlay. When provided, the overlay is shown
  /// whenever the field is focused. The [close] callback hides the overlay.
  final Widget? Function(
    BuildContext context,
    TextEditingController controller,
    VoidCallback close,
  )?
  suggestionOverlayBuilder;

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
    if (_focusNode.hasFocus) {
      if (widget.suggestionOverlayBuilder != null &&
          !_overlayController.isShowing) {
        _overlayController.show();
      }
    } else {
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
    if (widget.suggestionOverlayBuilder != null && _isFocused) {
      if (!_overlayController.isShowing) {
        _overlayController.show();
      } else {
        setState(() {});
      }
    }
  }

  void _closeOverlay() {
    if (_overlayController.isShowing) {
      _overlayController.hide();
    }
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
    final fieldHeight = 32.0 * zoomScale;

    final textStyle = TextStyle(
      fontSize: 13.0 * zoomScale,
      color: appColorScheme.base.foreground,
    );
    final hintStyle = textStyle.copyWith(
      color: appColorScheme.uiAreas.sideBar.inactiveItemText,
    );

    // StrutStyle with forceStrutHeight ensures stable vertical centering
    // at all zoom scales.
    final strutStyle = StrutStyle(
      fontSize: textStyle.fontSize,
      height: 1.0,
      forceStrutHeight: true,
    );

    final iconAreaWidth = fieldHeight;

    Widget editableText = TextSelectionTheme(
      data: TextSelectionThemeData(
        selectionColor: selectionColor.withValues(alpha: 0.3),
      ),
      child: EditableText(
        controller: _controller,
        focusNode: _focusNode,
        readOnly: !widget.enabled,
        style: textStyle,
        strutStyle: strutStyle,
        cursorColor: cursorColor,
        backgroundCursorColor: Colors.transparent,
        cursorWidth: 1.5,
        selectionColor: selectionColor.withValues(alpha: 0.3),
        selectionControls: materialTextSelectionControls,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          _closeOverlay();
          widget.onSubmit?.call(value);
        },
        onChanged: (_) {},
        rendererIgnoresPointer: true,
        mouseCursor: MouseCursor.defer,
        enableInteractiveSelection: true,
        contextMenuBuilder: (context, editableTextState) {
          return AdaptiveTextSelectionToolbar.editableText(
            editableTextState: editableTextState,
          );
        },
        keyboardAppearance: appColorScheme.brightness,
      ),
    );

    // Hint text overlay
    editableText = Stack(
      alignment: Alignment.centerLeft,
      children: [
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, _) {
            if (value.text.isNotEmpty) return const SizedBox.shrink();
            return Text(
              widget.hint,
              style: hintStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
        editableText,
      ],
    );

    final clearButton =
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
            : null;

    Widget fieldRow = SizedBox(
      width: double.infinity,
      height: fieldHeight,
      child: MouseRegion(
        cursor:
            widget.enabled ? SystemMouseCursors.text : SystemMouseCursors.basic,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (!widget.enabled) return;
            if (!_focusNode.hasFocus) {
              _focusNode.requestFocus();
            }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Search icon
              SizedBox(
                width: iconAreaWidth,
                height: iconAreaWidth,
                child: Center(
                  child: Icon(
                    iconTheme.search,
                    color: appColorScheme.uiAreas.sideBar.inactiveItemText,
                    size: 16.0 * zoomScale,
                  ),
                ),
              ),
              // Text area
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: editableText,
                ),
              ),
              // Clear button
              if (clearButton != null)
                SizedBox(
                  width: iconAreaWidth,
                  height: iconAreaWidth,
                  child: Center(child: clearButton),
                ),
            ],
          ),
        ),
      ),
    );

    // Outer border + focus ring
    fieldRow = CustomPaint(
      foregroundPainter:
          _isFocused
              ? FondeFocusRingPainter(
                color: activeBorderColor,
                borderWidth: 2.0 * borderScale,
                cornerRadius: 8.0 * zoomScale,
              )
              : null,
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
        child: fieldRow,
      ),
    );

    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: (overlayContext) {
        final child = widget.suggestionOverlayBuilder?.call(
          overlayContext,
          _controller,
          _closeOverlay,
        );
        if (child == null) {
          _closeOverlay();
          return const SizedBox.shrink();
        }
        return CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, fieldHeight + 4.0),
          child: Align(alignment: Alignment.topLeft, child: child),
        );
      },
      child: CompositedTransformTarget(link: _layerLink, child: fieldRow),
    );
  }
}
