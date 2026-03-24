import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:figma_squircle/figma_squircle.dart';
import '../../internal.dart';
import 'dart:ui' as ui;
import '../typography/fonde_text.dart';

/// App-specific text field
///
/// Enforces app-specific design with fixed height of 36px.
/// Label text cannot be used due to height constraints.
/// To maintain consistent design system, do not use InputDecoration,
/// use dedicated properties instead.
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
    this.textVariant = FondeTextVariant.inputText,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
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
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection,
    this.selectionControls,
    this.onTap,
    this.onTapOutside,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const <String>[],
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scribbleEnabled = true,
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
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 0,
    ),
    this.disableZoom = false,
  });

  /// Text field controller
  final TextEditingController? controller;

  /// Focus node
  final FocusNode? focusNode;

  /// Hint text
  final String? hintText;

  /// Error text
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

  /// Text variant (unified with FondeText system)
  final FondeTextVariant textVariant;

  /// Text style (takes precedence over textVariant)
  final TextStyle? style;

  /// Strut style
  final StrutStyle? strutStyle;

  /// Text alignment
  final TextAlign textAlign;

  /// Text vertical alignment
  final TextAlignVertical? textAlignVertical;

  /// Text direction
  final TextDirection? textDirection;

  /// Whether read-only
  final bool readOnly;

  /// Whether to show cursor
  final bool? showCursor;

  /// Whether to autofocus
  final bool autofocus;

  /// Password character
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

  /// Cursor height
  final double? cursorHeight;

  /// Cursor radius
  final Radius? cursorRadius;

  /// Cursor color
  final Color? cursorColor;

  /// Selection height style
  final dynamic selectionHeightStyle;

  /// Selection width style
  final dynamic selectionWidthStyle;

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

  /// Counter builder
  final InputCounterWidgetBuilder? buildCounter;

  /// Scroll controller
  final ScrollController? scrollController;

  /// Scroll physics
  final ScrollPhysics? scrollPhysics;

  /// Autofill hints
  final Iterable<String> autofillHints;

  /// Clip behavior
  final Clip clipBehavior;

  /// Restoration ID
  final String? restorationId;

  /// Whether to enable scribble input
  final bool scribbleEnabled;

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

  /// Content padding
  final EdgeInsets contentPadding;

  /// Whether to disable zoom functionality
  final bool disableZoom;

  @override
  State<FondeTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<FondeTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final flutterTheme = Theme.of(context);
    final accessibilityConfig = context.fondeAccessibility;
    final zoomScale = widget.disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale =
        widget.disableZoom ? 1.0 : accessibilityConfig.borderScale;

    // Use the new color scheme provider that responds to theme mode changes
    final appColorScheme = context.fondeColorScheme;

    // Set default colors using color scheme
    final backgroundColor =
        widget.backgroundColor ?? appColorScheme.interactive.input.background;
    final borderColor =
        widget.borderColor ?? appColorScheme.interactive.input.border;
    final activeBorderColor =
        widget.activeBorderColor ??
        appColorScheme.interactive.input.focusBorder;

    return Container(
      width: double.infinity,
      height: 32.0 * zoomScale, // Explicitly specify height
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: widget.radius * zoomScale,
            cornerSmoothing: 0.6,
          ),
          side: BorderSide(
            color: _isFocused ? activeBorderColor : borderColor,
            width: widget.borderWidth * borderScale,
          ),
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: widget.hintText,
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon,
          suffixIcon:
              widget.suffixIcon != null
                  // Center align with Align widget.
                  // This allows adjusting visual position without unnecessarily
                  // expanding the clickable area of IconButton.
                  ? Align(alignment: Alignment.center, child: widget.suffixIcon)
                  : null,
          suffixIconConstraints:
              widget.suffixIcon != null
                  ? BoxConstraints(
                    // Match height to TextField height so Align centers correctly.
                    minHeight: 32.0 * zoomScale,
                    maxHeight: 32.0 * zoomScale,
                    // Width reserves space for icon and left/right padding.
                    minWidth: 32.0 * zoomScale,
                    maxWidth: 32.0 * zoomScale,
                  )
                  : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          labelText: null,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: widget.contentPadding.horizontal / 2 * zoomScale,
            vertical: () {
              final textStyle =
                  widget.style ??
                  _buildTextStyle(
                    flutterTheme.textTheme,
                    appColorScheme,
                    zoomScale,
                  );
              final fontSize = (textStyle.fontSize ?? 14.0);
              final fieldHeight = 32.0 * zoomScale;
              final verticalPadding = (fieldHeight - fontSize) / 2 - 2.0;
              return verticalPadding.clamp(0.0, double.infinity);
            }(),
          ),
        ),
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        style:
            widget.style ??
            _buildTextStyle(flutterTheme.textTheme, appColorScheme, zoomScale),
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign,
        textAlignVertical: widget.textAlignVertical ?? TextAlignVertical.center,
        textDirection: widget.textDirection,
        readOnly: widget.readOnly,
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
        maxLength: widget.maxLength,
        maxLengthEnforcement: widget.maxLengthEnforcement,
        onChanged: widget.onChanged,
        onEditingComplete: widget.onEditingComplete,
        onSubmitted: widget.onSubmitted,
        onAppPrivateCommand: widget.onAppPrivateCommand,
        inputFormatters: widget.inputFormatters,
        enabled: widget.enabled,
        cursorWidth: widget.cursorWidth * zoomScale,
        cursorHeight:
            widget.cursorHeight != null
                ? widget.cursorHeight! * zoomScale
                : null,
        cursorRadius:
            widget.cursorRadius != null
                ? Radius.circular(widget.cursorRadius!.x * zoomScale)
                : null,
        cursorColor: widget.cursorColor,
        // selectionHeightStyle and selectionWidthStyle don't allow null, so specify directly
        selectionHeightStyle: ui.BoxHeightStyle.tight,
        selectionWidthStyle: ui.BoxWidthStyle.tight,
        keyboardAppearance: widget.keyboardAppearance,
        scrollPadding: EdgeInsets.only(
          left: widget.scrollPadding.left * zoomScale,
          top: widget.scrollPadding.top * zoomScale,
          right: widget.scrollPadding.right * zoomScale,
          bottom: widget.scrollPadding.bottom * zoomScale,
        ),
        dragStartBehavior: widget.dragStartBehavior,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        selectionControls: widget.selectionControls,
        onTap: widget.onTap,
        onTapOutside: widget.onTapOutside,
        mouseCursor: widget.mouseCursor,
        buildCounter: widget.buildCounter,
        scrollController: widget.scrollController,
        scrollPhysics: widget.scrollPhysics,
        autofillHints: widget.autofillHints,
        clipBehavior: widget.clipBehavior,
        restorationId: widget.restorationId,
        stylusHandwritingEnabled: widget.scribbleEnabled,
        enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
        contextMenuBuilder: widget.contextMenuBuilder,
        canRequestFocus: widget.canRequestFocus,
        spellCheckConfiguration: widget.spellCheckConfiguration,
        magnifierConfiguration: widget.magnifierConfiguration,
        contentInsertionConfiguration: widget.contentInsertionConfiguration,
      ),
    );
  }

  /// Build text style based on FondeTextVariant
  TextStyle _buildTextStyle(
    TextTheme textTheme,
    FondeColorScheme colorScheme,
    double zoomScale,
  ) {
    // Build text style using same logic as FondeText

    final baseStyle = switch (widget.textVariant) {
      // === New role-based variants ===
      FondeTextVariant.inputText => textTheme.bodyMedium,
      FondeTextVariant.buttonLabel => textTheme.bodyMedium,
      FondeTextVariant.labelText => textTheme.bodyMedium,
      FondeTextVariant.bodyText => textTheme.bodyMedium,
      FondeTextVariant.captionText => textTheme.bodySmall,
      FondeTextVariant.smallText => textTheme.labelSmall,

      // Add other variants as needed
      _ => textTheme.bodyMedium,
    };

    final scaledStyle = (baseStyle ?? const TextStyle()).copyWith(
      color: colorScheme.interactive.input.text,
    );

    // Apply zoom scale
    if (scaledStyle.fontSize != null) {
      return scaledStyle.copyWith(fontSize: scaledStyle.fontSize! * zoomScale);
    }

    return scaledStyle;
  }
}
