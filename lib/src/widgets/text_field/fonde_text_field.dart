import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:figma_squircle/figma_squircle.dart';
import '../../internal.dart';
import '../widgets/fonde_rectangle_border.dart';
import 'dart:ui' as ui;
import 'focus_ring_painter.dart';

/// App-specific text field
///
/// Enforces app-specific design with fixed height of 32px.
/// Implemented with [EditableText] directly to guarantee correct vertical
/// centering at all zoom scales — the previous [TextField]/[InputDecoration]
/// approach required a magic-number pixel adjustment that broke at non-1.0
/// zoom scales.
class FondeTextField extends StatefulWidget {
  /// Constructor
  const FondeTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.readOnly = false,
    this.showCursor,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 1.5,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection,
    this.selectionControls,
    this.onTap,
    this.onTapOutside,
    this.mouseCursor,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const <String>[],
    this.restorationId,
    this.enableIMEPersonalizedLearning = true,
    this.contextMenuBuilder,
    this.canRequestFocus = true,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
    this.contentInsertionConfiguration,
    this.backgroundColor,
    this.borderColor,
    this.activeBorderColor,
    this.borderWidth = 1.5,
    this.radius = 12.0,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 12),
    this.disableZoom = false,
  });

  /// Text field controller
  final TextEditingController? controller;

  /// Focus node
  final FocusNode? focusNode;

  /// Hint text
  final String? hintText;

  /// Error text shown below the field
  final String? errorText;

  /// Prefix icon
  final Widget? prefixIcon;

  /// Suffix icon
  final Widget? suffixIcon;

  /// Keyboard type
  final TextInputType? keyboardType;

  /// Text input action
  final TextInputAction? textInputAction;

  /// Text capitalization setting
  final TextCapitalization textCapitalization;

  /// Text style (overrides default style derived from theme)
  final TextStyle? style;

  /// Text alignment
  final TextAlign textAlign;

  /// Text direction
  final TextDirection? textDirection;

  /// Whether read-only
  final bool readOnly;

  /// Whether to show cursor
  final bool? showCursor;

  /// Whether to autofocus
  final bool autofocus;

  /// Password obscuring character
  final String obscuringCharacter;

  /// Whether to display as password
  final bool obscureText;

  /// Whether to enable autocorrect
  final bool autocorrect;

  /// Smart dashes type
  final SmartDashesType? smartDashesType;

  /// Smart quotes type
  final SmartQuotesType? smartQuotesType;

  /// Whether to enable input suggestions
  final bool enableSuggestions;

  /// Maximum number of lines
  final int? maxLines;

  /// Minimum number of lines
  final int? minLines;

  /// Whether to expand
  final bool expands;

  /// Maximum character count
  final int? maxLength;

  /// How to enforce maximum character count
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// Callback when text changes
  final ValueChanged<String>? onChanged;

  /// Callback when editing completes
  final VoidCallback? onEditingComplete;

  /// Callback when submitted
  final ValueChanged<String>? onSubmitted;

  /// Callback for private command
  final AppPrivateCommandCallback? onAppPrivateCommand;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Whether enabled
  final bool? enabled;

  /// Cursor width
  final double cursorWidth;

  /// Cursor height (defaults to font size)
  final double? cursorHeight;

  /// Cursor radius
  final Radius? cursorRadius;

  /// Cursor color
  final Color? cursorColor;

  /// Keyboard appearance
  final Brightness? keyboardAppearance;

  /// Scroll padding
  final EdgeInsets scrollPadding;

  /// Drag start behavior
  final DragStartBehavior dragStartBehavior;

  /// Whether to enable interactive selection
  final bool? enableInteractiveSelection;

  /// Selection controls
  final TextSelectionControls? selectionControls;

  /// Callback on tap
  final GestureTapCallback? onTap;

  /// Callback on outside tap
  final TapRegionCallback? onTapOutside;

  /// Mouse cursor
  final MouseCursor? mouseCursor;

  /// Scroll controller
  final ScrollController? scrollController;

  /// Scroll physics
  final ScrollPhysics? scrollPhysics;

  /// Autofill hints
  final Iterable<String> autofillHints;

  /// Restoration ID
  final String? restorationId;

  /// Whether to enable IME personalized learning
  final bool enableIMEPersonalizedLearning;

  /// Context menu builder
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Whether can request focus
  final bool canRequestFocus;

  /// Spell check configuration
  final SpellCheckConfiguration? spellCheckConfiguration;

  /// Magnifier configuration
  final TextMagnifierConfiguration? magnifierConfiguration;

  /// Content insertion configuration
  final ContentInsertionConfiguration? contentInsertionConfiguration;

  /// Background color
  final Color? backgroundColor;

  /// Border color
  final Color? borderColor;

  /// Border color when active
  final Color? activeBorderColor;

  /// Border width
  final double borderWidth;

  /// Corner radius
  final double radius;

  /// Horizontal content padding (vertical is ignored; centering is automatic)
  final EdgeInsets contentPadding;

  /// Whether to disable zoom functionality
  final bool disableZoom;

  @override
  State<FondeTextField> createState() => _FondeTextFieldState();
}

class _FondeTextFieldState extends State<FondeTextField>
    implements TextSelectionGestureDetectorBuilderDelegate {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;

  // TextSelectionGestureDetectorBuilderDelegate
  @override
  final GlobalKey<EditableTextState> editableTextKey =
      GlobalKey<EditableTextState>();
  @override
  bool get forcePressEnabled => false;
  @override
  bool get selectionEnabled => widget.enableInteractiveSelection ?? true;

  late _FondeTextFieldSelectionGestureDetectorBuilder
  _selectionGestureDetectorBuilder;

  @override
  void initState() {
    super.initState();
    _selectionGestureDetectorBuilder =
        _FondeTextFieldSelectionGestureDetectorBuilder(state: this);
    _controller = widget.controller ?? TextEditingController();
    _focusNode =
        widget.focusNode ?? FocusNode(canRequestFocus: widget.canRequestFocus);
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(FondeTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Swap controller if the external one changed
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        _controller.dispose();
      }
      _controller = widget.controller ?? TextEditingController();
    }
    // Swap focus node if the external one changed
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_handleFocusChange);
      if (oldWidget.focusNode == null) {
        _focusNode.dispose();
      }
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  bool get _isEnabled => widget.enabled ?? true;

  @override
  Widget build(BuildContext context) {
    final appColorScheme = context.fondeColorScheme;
    final accessibilityConfig = context.fondeAccessibility;
    final zoomScale = widget.disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale =
        widget.disableZoom ? 1.0 : accessibilityConfig.borderScale;

    final backgroundColor =
        widget.backgroundColor ?? appColorScheme.interactive.input.background;
    final borderColor =
        widget.borderColor ?? appColorScheme.interactive.input.border;
    final activeBorderColor =
        widget.activeBorderColor ??
        appColorScheme.interactive.input.focusBorder;

    final effectiveBorderColor = _isFocused ? activeBorderColor : borderColor;
    final fieldHeight = 32.0 * zoomScale;
    final hPadding = widget.contentPadding.horizontal / 2 * zoomScale;

    final brightness = widget.keyboardAppearance ?? appColorScheme.brightness;
    final textStyle = _resolveTextStyle(appColorScheme, zoomScale);
    final hintStyle = textStyle.copyWith(
      color: appColorScheme.interactive.input.placeholder,
    );

    Widget field = _buildField(
      context: context,
      appColorScheme: appColorScheme,
      zoomScale: zoomScale,
      fieldHeight: fieldHeight,
      hPadding: hPadding,
      textStyle: textStyle,
      hintStyle: hintStyle,
      brightness: brightness,
    );

    // Outer border shape + background
    field = CustomPaint(
      foregroundPainter:
          _isFocused
              ? FondeFocusRingPainter(
                color: activeBorderColor,
                borderWidth: 2.0 * borderScale,
                cornerRadius: widget.radius * zoomScale,
              )
              : null,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color:
              _isEnabled
                  ? backgroundColor
                  : backgroundColor.withValues(alpha: 0.5),
          shape: SmoothRectangleBorder(
            borderRadius:
                FondeBorderRadius.radius(
                  widget.radius * zoomScale,
                ).toSmoothBorderRadius(),
            side: BorderSide(
              color: _isFocused ? Colors.transparent : effectiveBorderColor,
              width: widget.borderWidth * borderScale,
            ),
          ),
        ),
        child: field,
      ),
    );

    // Wrap in TextFieldTapRegion so that prefix/suffix icons, padding, and
    // the editable area all belong to the same tap-region group as the
    // EditableText's internal TextFieldTapRegion (groupId: EditableText).
    // This prevents taps inside the field from triggering onTapOutside, which
    // was causing spurious unfocus events (e.g. after Cmd+A, context menu).
    field = TextFieldTapRegion(
      onTapOutside:
          widget.onTapOutside ??
          (_) {
            if (_focusNode.hasFocus) {
              _focusNode.unfocus();
            }
          },
      child: field,
    );

    // Error text below the field
    if (widget.errorText != null) {
      final errorStyle = TextStyle(
        fontSize: 12.0 * zoomScale,
        color: appColorScheme.status.error,
      );
      field = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          field,
          SizedBox(height: 4.0 * zoomScale),
          Text(widget.errorText!, style: errorStyle),
        ],
      );
    }

    return field;
  }

  Widget _buildField({
    required BuildContext context,
    required FondeColorScheme appColorScheme,
    required double zoomScale,
    required double fieldHeight,
    required double hPadding,
    required TextStyle textStyle,
    required TextStyle hintStyle,
    required Brightness brightness,
  }) {
    final iconSize = fieldHeight;

    // Tapping the prefix/suffix padding areas should move focus to the field.
    // The editable area itself handles pointer events directly (cursor
    // placement, selection, keyboard shortcuts) — no GestureDetector there.
    void onPaddingTap() {
      if (!_isEnabled) return;
      widget.onTap?.call();
      if (!_focusNode.hasFocus) {
        _focusNode.requestFocus();
      }
    }

    return SizedBox(
      width: double.infinity,
      height: fieldHeight,
      child: MouseRegion(
        cursor:
            widget.mouseCursor ??
            (_isEnabled ? SystemMouseCursors.text : SystemMouseCursors.basic),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Prefix icon or left padding area (tappable → focus)
            if (widget.prefixIcon != null)
              SizedBox(
                width: iconSize,
                height: iconSize,
                child: Center(child: widget.prefixIcon),
              )
            else
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onPaddingTap,
                child: SizedBox(width: hPadding, height: fieldHeight),
              ),

            // Editable text — receives pointer events directly so that
            // tapping places the cursor at the correct position.
            Expanded(
              child: _buildEditableArea(
                appColorScheme: appColorScheme,
                zoomScale: zoomScale,
                textStyle: textStyle,
                hintStyle: hintStyle,
                brightness: brightness,
              ),
            ),

            // Suffix icon or right padding area (tappable → focus)
            if (widget.suffixIcon != null)
              SizedBox(
                width: iconSize,
                height: iconSize,
                child: Center(child: widget.suffixIcon),
              )
            else
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onPaddingTap,
                child: SizedBox(width: hPadding, height: fieldHeight),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableArea({
    required FondeColorScheme appColorScheme,
    required double zoomScale,
    required TextStyle textStyle,
    required TextStyle hintStyle,
    required Brightness brightness,
  }) {
    final cursorColor =
        widget.cursorColor ?? appColorScheme.interactive.input.text;
    final selectionColor = appColorScheme.base.selection.withValues(alpha: 0.4);

    // StrutStyle with forceStrutHeight eliminates font-metrics variance,
    // ensuring the line box height is determined solely by fontSize × height.
    final strutStyle = StrutStyle(
      fontSize: textStyle.fontSize,
      height: 1.0,
      forceStrutHeight: true,
    );

    final effectiveSelectionControls =
        widget.selectionControls ?? desktopTextSelectionControls;

    Widget editableText = EditableText(
      key: editableTextKey,
      controller: _controller,
      focusNode: _focusNode,
      style: textStyle,
      strutStyle: strutStyle,
      cursorColor: cursorColor,
      backgroundCursorColor: Colors.transparent,
      cursorWidth: widget.cursorWidth * zoomScale,
      cursorHeight:
          widget.cursorHeight != null ? widget.cursorHeight! * zoomScale : null,
      cursorRadius:
          widget.cursorRadius != null
              ? Radius.circular(widget.cursorRadius!.x * zoomScale)
              : null,
      selectionColor: selectionColor,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      readOnly: widget.readOnly || !_isEnabled,
      showCursor: widget.showCursor,
      autofocus: widget.autofocus,
      obscuringCharacter: widget.obscuringCharacter,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      enableSuggestions: widget.enableSuggestions,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      onAppPrivateCommand: widget.onAppPrivateCommand,
      inputFormatters: [
        if (widget.maxLength != null)
          LengthLimitingTextInputFormatter(
            widget.maxLength,
            maxLengthEnforcement: widget.maxLengthEnforcement,
          ),
        ...?widget.inputFormatters,
      ],
      mouseCursor: MouseCursor.defer,
      rendererIgnoresPointer: true,
      scrollController: widget.scrollController,
      scrollPhysics: widget.scrollPhysics,
      scrollPadding: EdgeInsets.only(
        left: widget.scrollPadding.left * zoomScale,
        top: widget.scrollPadding.top * zoomScale,
        right: widget.scrollPadding.right * zoomScale,
        bottom: widget.scrollPadding.bottom * zoomScale,
      ),
      dragStartBehavior: widget.dragStartBehavior,
      enableInteractiveSelection: widget.enableInteractiveSelection ?? true,
      selectionControls: effectiveSelectionControls,
      autofillHints: widget.autofillHints,
      restorationId: widget.restorationId,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
      contextMenuBuilder:
          widget.contextMenuBuilder ??
          (context, editableTextState) {
            return AdaptiveTextSelectionToolbar.editableText(
              editableTextState: editableTextState,
            );
          },
      spellCheckConfiguration: widget.spellCheckConfiguration,
      magnifierConfiguration:
          widget.magnifierConfiguration ??
          TextMagnifier.adaptiveMagnifierConfiguration,
      contentInsertionConfiguration: widget.contentInsertionConfiguration,
      selectionHeightStyle: ui.BoxHeightStyle.tight,
      selectionWidthStyle: ui.BoxWidthStyle.tight,
      keyboardAppearance: brightness,
      // Suppress EditableText's built-in TextFieldTapRegion unfocus behaviour.
      // Outside-tap handling is delegated to the TapRegion that wraps the
      // entire field (including prefix/suffix icons).
      onTapOutside: (_) {},
    );

    // Hint text layered under the editable text via a Stack.
    // EditableText has no built-in hint support.
    if (widget.hintText != null) {
      editableText = Stack(
        alignment: Alignment.centerLeft,
        children: [
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) {
              if (value.text.isNotEmpty) return const SizedBox.shrink();
              return Text(
                widget.hintText!,
                style: hintStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          editableText,
        ],
      );
    }

    // Wrap with the gesture detector that handles tap-to-place-cursor,
    // double-tap word selection, drag selection, and keyboard shortcuts.
    editableText = _selectionGestureDetectorBuilder.buildGestureDetector(
      behavior: HitTestBehavior.translucent,
      child: editableText,
    );

    // Align vertically center; EditableText itself is inline/text-baseline
    // aligned, so wrapping in Align gives us reliable vertical centering
    // independent of font metrics or zoom scale.
    return Align(alignment: Alignment.centerLeft, child: editableText);
  }

  TextStyle _resolveTextStyle(FondeColorScheme colorScheme, double zoomScale) {
    if (widget.style != null) {
      final s = widget.style!;
      return s.copyWith(
        fontSize: (s.fontSize ?? 14.0) * zoomScale,
        color: s.color ?? colorScheme.interactive.input.text,
      );
    }
    return TextStyle(
      fontSize: 14.0 * zoomScale,
      color:
          _isEnabled
              ? colorScheme.interactive.input.text
              : colorScheme.interactive.input.text.withValues(alpha: 0.4),
    );
  }
}

/// Gesture detector builder that wires standard text-selection gestures
/// (tap-to-place, double-tap word select, drag select) to [EditableText].
///
/// Mirrors the pattern used internally by [TextField].
class _FondeTextFieldSelectionGestureDetectorBuilder
    extends TextSelectionGestureDetectorBuilder {
  _FondeTextFieldSelectionGestureDetectorBuilder({
    required _FondeTextFieldState state,
  }) : _state = state,
       super(delegate: state);

  final _FondeTextFieldState _state;

  @override
  void onUserTap() {
    _state.widget.onTap?.call();
  }
}
