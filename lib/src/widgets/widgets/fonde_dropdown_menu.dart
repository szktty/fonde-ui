import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../internal.dart';
import 'fonde_rectangle_border.dart';
import '../typography/fonde_text.dart';

/// Vertical position of FondeDropdownMenu
enum FondeDropdownMenuPosition {
  /// Focus on selected item and overlay (default)
  overlay,

  /// Display below dropdown button
  below,

  /// Display above dropdown button
  above,
}

/// Horizontal alignment of FondeDropdownMenu
enum FondeDropdownMenuAlignment {
  /// Left aligned
  left,

  /// Center aligned
  center,

  /// Right aligned
  right,

  /// Overhang to left (overlay menu expands to left side)
  leftOverhang,
}

// Constants for FondeDropdownMenu (adjusted to match FondeButton)
class _AppDropdownMenuConstants {
  static const double checkboxSpaceWidth = 16.0;
  static const double spacing = 4.0;
  static const double checkIconSize = 12.0;
  static const double chevronIconSize = 16.0;
  static const double horizontalPadding =
      16.0; // 12.0 → 16.0 (match FondeButton)
  static const double verticalPadding =
      4.0; // 6.0 → 4.0 (adjust label position)
  static const double defaultHeight = 32.0; // 48.0 → 32.0 (match FondeButton)
  static const double standardIconSize =
      24.0; // Standard size for leading/trailing icons
  static const double widthMargin = 8.0; // Safety margin for width calculation

  // Total offset of checkbox space + spacing
  static const double totalOffset = checkboxSpaceWidth + spacing;
}

/// Common DropdownMenu for App app
///
/// Provides a design where menu items completely cover the dropdown button
/// when selected using a custom overlay menu.
/// Achieves Figma-style rounded rectangle design using FondeRectangleBorder,
/// and obtains theme colors via core_themes capsule.
class FondeDropdownMenu<T> extends StatelessWidget {
  /// Initial selection value
  final T? initialSelection;

  /// Callback when selection changes
  final ValueChanged<T?>? onSelected;

  /// List of dropdown menu entries
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;

  /// Width of dropdown menu
  final double? width;

  /// Height of dropdown menu
  final double? height;

  /// Text style
  final TextStyle? textStyle;

  /// Hint text
  final String? hintText;

  /// Enabled/disabled state
  final bool enabled;

  /// Corner radius (uses FondeRectangleBorder default if not specified)
  final double? cornerRadius;

  /// Corner smoothing (uses FondeRectangleBorder default if not specified)
  final double? cornerSmoothing;

  /// Background color of dropdown button
  final Color? backgroundColor;

  /// Border color of dropdown button
  final Color? borderColor;

  /// Background color of overlay menu
  final Color? overlayBackgroundColor;

  /// Border color of overlay menu
  final Color? overlayBorderColor;

  /// Text color
  final Color? textColor;

  /// Vertical position of overlay menu
  final FondeDropdownMenuPosition position;

  /// Horizontal alignment of overlay menu
  final FondeDropdownMenuAlignment alignment;

  /// Whether to show checkmark for selected item
  final bool showCheckmark;

  /// Whether to disable zoom functionality
  final bool disableZoom;

  /// Whether to display as action icon button
  /// If true, dropdown button is displayed as action icon (3-dot menu)
  final bool showAsActionIcon;

  /// Icon data for action icon (used when showAsActionIcon is true)
  final IconData? actionIcon;

  /// Constructor
  const FondeDropdownMenu({
    super.key,
    this.initialSelection,
    this.onSelected,
    required this.dropdownMenuEntries,
    this.width,
    this.height,
    this.textStyle,
    this.hintText,
    this.enabled = true,
    this.cornerRadius,
    this.cornerSmoothing,
    this.backgroundColor,
    this.borderColor,
    this.overlayBackgroundColor,
    this.overlayBorderColor,
    this.textColor,
    this.position = FondeDropdownMenuPosition.overlay,
    this.alignment = FondeDropdownMenuAlignment.leftOverhang,
    this.showCheckmark = true,
    this.disableZoom = false,
    this.showAsActionIcon = false,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return _AppDropdownMenuWidget<T>(
      initialSelection: initialSelection,
      onSelected: onSelected,
      dropdownMenuEntries: dropdownMenuEntries,
      width: width,
      height: height,
      textStyle: textStyle,
      hintText: hintText,
      enabled: enabled,
      cornerRadius: cornerRadius,
      cornerSmoothing: cornerSmoothing,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      overlayBackgroundColor: overlayBackgroundColor,
      overlayBorderColor: overlayBorderColor,
      textColor: textColor,
      position: position,
      alignment: alignment,
      showCheckmark: showCheckmark,
      disableZoom: disableZoom,
      showAsActionIcon: showAsActionIcon,
      actionIcon: actionIcon,
    );
  }
}

/// Internal implementation widget for FondeDropdownMenu
class _AppDropdownMenuWidget<T> extends StatelessWidget {
  final T? initialSelection;
  final ValueChanged<T?>? onSelected;
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final String? hintText;
  final bool enabled;
  final double? cornerRadius;
  final double? cornerSmoothing;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? overlayBackgroundColor;
  final Color? overlayBorderColor;
  final Color? textColor;
  final FondeDropdownMenuPosition position;
  final FondeDropdownMenuAlignment alignment;
  final bool showCheckmark;
  final bool disableZoom;
  final bool showAsActionIcon;
  final IconData? actionIcon;

  const _AppDropdownMenuWidget({
    super.key,
    this.initialSelection,
    this.onSelected,
    required this.dropdownMenuEntries,
    this.width,
    this.height,
    this.textStyle,
    this.hintText,
    this.enabled = true,
    this.cornerRadius,
    this.cornerSmoothing,
    this.backgroundColor,
    this.borderColor,
    this.overlayBackgroundColor,
    this.overlayBorderColor,
    this.textColor,
    required this.position,
    required this.alignment,
    required this.showCheckmark,
    this.disableZoom = false,
    this.showAsActionIcon = false,
    this.actionIcon,
  });

  /// Calculate maximum item width for dropdown button
  double _calculateMaxItemWidth({
    required List<DropdownMenuEntry<T>> dropdownMenuEntries,
    required TextStyle? textStyle,
    required bool showCheckmark,
    required FondeDropdownMenuAlignment alignment,
    required double zoomScale,
  }) {
    double maxWidth = 0.0;

    for (final entry in dropdownMenuEntries) {
      double itemWidth = 0.0;

      // Add horizontal padding (for dropdown button)
      itemWidth += _AppDropdownMenuConstants.horizontalPadding * 2 * zoomScale;

      // Add leading icon space
      if (entry.leadingIcon != null) {
        itemWidth += _AppDropdownMenuConstants.standardIconSize * zoomScale;
        itemWidth += _AppDropdownMenuConstants.spacing * zoomScale;
      }

      // Calculate text width (using text style with zoom scale applied)
      final zoomedTextStyle = textStyle?.copyWith(
        fontSize: (textStyle.fontSize ?? 14.0) * zoomScale,
      );
      final textPainter = TextPainter(
        text: TextSpan(text: entry.label, style: zoomedTextStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textWidth = textPainter.size.width;
      itemWidth += textWidth;

      // Add trailing icon space
      if (entry.trailingIcon != null) {
        itemWidth += _AppDropdownMenuConstants.spacing * zoomScale;
        itemWidth += _AppDropdownMenuConstants.standardIconSize * zoomScale;
      }

      // Add chevron icon space (for dropdown button)
      itemWidth += _AppDropdownMenuConstants.spacing * zoomScale;
      itemWidth += _AppDropdownMenuConstants.chevronIconSize * zoomScale;

      maxWidth = maxWidth > itemWidth ? maxWidth : itemWidth;
    }

    // Add safety margin to prevent rendering errors
    return maxWidth + _AppDropdownMenuConstants.widthMargin * zoomScale;
  }

  @override
  Widget build(BuildContext context) {
    // Get theme colors using core_themes API
    final appColorScheme = context.fondeColorScheme;
    final themeData = Theme.of(context);
    final accessibilityConfig = context.fondeAccessibility;

    // Create FondeBorderRadius
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;
    final borderScale = disableZoom ? 1.0 : accessibilityConfig.borderScale;
    final appBorderRadius = FondeBorderRadius.create(
      cornerRadius: cornerRadius != null ? cornerRadius! * zoomScale : null,
      cornerSmoothing: cornerSmoothing,
    );
    final smoothBorderRadius = appBorderRadius.toSmoothBorderRadius();

    // Build text style
    final effectiveTextStyle =
        textStyle ??
        themeData.textTheme.bodyMedium?.copyWith(
          color: appColorScheme.base.foreground,
        );

    // Get currently selected value
    final selectedEntry =
        dropdownMenuEntries
            .where((entry) => entry.value == initialSelection)
            .firstOrNull;

    // If width is not specified, calculate maximum width of all items
    double? effectiveWidth;
    if (showAsActionIcon) {
      effectiveWidth = _calculateMaxItemWidth(
        dropdownMenuEntries: dropdownMenuEntries,
        textStyle: effectiveTextStyle,
        showCheckmark: showCheckmark,
        alignment: alignment,
        zoomScale: zoomScale,
      );
    } else if (width != null && width!.isFinite) {
      effectiveWidth = width! * zoomScale;
    } else {
      effectiveWidth = _calculateMaxItemWidth(
        dropdownMenuEntries: dropdownMenuEntries,
        textStyle: effectiveTextStyle,
        showCheckmark: showCheckmark,
        alignment: alignment,
        zoomScale: zoomScale,
      );
    }

    return _AppDropdownButton<T>(
      selectedEntry: selectedEntry,
      dropdownMenuEntries: dropdownMenuEntries,
      onSelected: onSelected,
      width: effectiveWidth,
      height: height != null ? height! * zoomScale : null,
      textStyle: effectiveTextStyle,
      hintText: hintText,
      enabled: enabled,
      borderRadius: smoothBorderRadius,
      backgroundColor: backgroundColor ?? appColorScheme.base.background,
      borderColor: borderColor ?? appColorScheme.base.border,
      overlayBackgroundColor:
          overlayBackgroundColor ?? appColorScheme.base.background,
      overlayBorderColor: overlayBorderColor ?? appColorScheme.base.border,
      textColor: textColor ?? appColorScheme.base.foreground,
      position: position,
      alignment: alignment,
      showCheckmark: showCheckmark,
      hoverBackgroundColor:
          appColorScheme.interactive.list.itemBackground.hover,
      zoomScale: zoomScale,
      borderScale: borderScale,
      showAsActionIcon: showAsActionIcon,
      actionIcon: actionIcon,
    );
  }
}

/// Custom dropdown button implementation
class _AppDropdownButton<T> extends StatefulWidget {
  final DropdownMenuEntry<T>? selectedEntry;
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;
  final ValueChanged<T?>? onSelected;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final String? hintText;
  final bool enabled;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final Color overlayBackgroundColor;
  final Color overlayBorderColor;
  final Color textColor;
  final FondeDropdownMenuPosition position;
  final FondeDropdownMenuAlignment alignment;
  final bool showCheckmark;
  final Color hoverBackgroundColor;
  final double zoomScale;
  final double borderScale;
  final bool showAsActionIcon;
  final IconData? actionIcon;

  const _AppDropdownButton({
    super.key,
    this.selectedEntry,
    required this.dropdownMenuEntries,
    this.onSelected,
    this.width,
    this.height,
    this.textStyle,
    this.hintText,
    this.enabled = true,
    required this.borderRadius,
    required this.backgroundColor,
    required this.borderColor,
    required this.overlayBackgroundColor,
    required this.overlayBorderColor,
    required this.textColor,
    required this.position,
    required this.alignment,
    required this.showCheckmark,
    required this.hoverBackgroundColor,
    required this.zoomScale,
    required this.borderScale,
    this.showAsActionIcon = false,
    this.actionIcon,
  });

  @override
  State<_AppDropdownButton<T>> createState() => _AppDropdownButtonState<T>();
}

class _AppDropdownButtonState<T> extends State<_AppDropdownButton<T>> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;

  // FocusNode for the KeyboardListener inside OverlayEntry
  final FocusNode _keyboardFocusNode = FocusNode();

  // Notifier shared with the overlay for hover index and keyboard focus index
  final ValueNotifier<int?> _hoveredIndex = ValueNotifier<int?>(null);
  // GlobalKey for the menu panel container — used for hit testing via Y coordinate.
  final GlobalKey _menuPanelKey = GlobalKey();

  // Whether the current pointer sequence started on the button (press-drag-release)
  bool _pointerDownActive = false;
  // Timestamp when the menu was opened
  DateTime? _menuOpenedAt;
  // How long the pointer must be held after opening before a release can
  // select an item. Matches the approximate macOS feel (~700ms).
  static const _selectionDelay = Duration(milliseconds: 700);

  @override
  void dispose() {
    _removeOverlay();
    _hoveredIndex.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
    _hoveredIndex.value = null;
    // Return focus to the primary focus scope so other widgets are unaffected.
    _keyboardFocusNode.unfocus();
  }

  void _openOverlay() {
    if (_isOpen) return;
    _menuOpenedAt = DateTime.now();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    // Request focus after the overlay is inserted so keyboard events are received.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isOpen) _keyboardFocusNode.requestFocus();
    });
    setState(() => _isOpen = true);
  }

  /// Find which item index (if any) contains [globalPosition].
  /// Uses the menu panel's RenderBox and uniform item height to calculate
  /// the index — more reliable than per-item GlobalKey hit testing.
  int? _findItemIndexAt(Offset globalPosition) {
    final renderBox =
        _menuPanelKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) return null;
    final local = renderBox.globalToLocal(globalPosition);
    if (local.dx < 0 ||
        local.dy < 0 ||
        local.dx > renderBox.size.width ||
        local.dy > renderBox.size.height) {
      return null;
    }
    final itemHeight =
        _AppDropdownMenuConstants.defaultHeight * widget.zoomScale;
    final index = (local.dy / itemHeight).floor();
    if (index < 0 || index >= widget.dropdownMenuEntries.length) return null;
    return index;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (!widget.enabled) return;
    _pointerDownActive = true;
    _openOverlay();
  }

  // Called from the button's Listener — drives hover during press-drag.
  void _handlePointerMove(PointerMoveEvent event) {
    if (!_isOpen || !_pointerDownActive) return;
    final index = _findItemIndexAt(event.position);
    _hoveredIndex.value = index;
  }

  // All pointer-up handling is done here (called from the overlay Listener).
  void _handleOverlayPointerUp(PointerUpEvent event) {
    if (!_isOpen) return;

    final openedAt = _menuOpenedAt;
    final elapsed =
        openedAt != null
            ? DateTime.now().difference(openedAt)
            : _selectionDelay;

    // If the pointer was released too quickly after the menu opened, it is
    // the same tap that triggered the open. Keep the menu open.
    if (elapsed < _selectionDelay && _pointerDownActive) {
      _pointerDownActive = false;
      return;
    }

    _pointerDownActive = false;

    final index = _findItemIndexAt(event.position);
    if (index != null) {
      final entry = widget.dropdownMenuEntries[index];
      widget.onSelected?.call(entry.value);
    }
    // Close whether or not an item was hit (click outside = dismiss).
    _removeOverlay();
    setState(() {});
  }

  void _handleOverlayPointerMove(PointerMoveEvent event) {
    if (!_isOpen) return;
    final index = _findItemIndexAt(event.position);
    _hoveredIndex.value = index;
  }

  void _handleKeyEvent(KeyEvent event) {
    if (!_isOpen) return;
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return;

    final key = event.logicalKey;
    final count = widget.dropdownMenuEntries.length;

    if (key == LogicalKeyboardKey.escape) {
      _removeOverlay();
      setState(() {});
    } else if (key == LogicalKeyboardKey.arrowDown) {
      final current = _hoveredIndex.value;
      _hoveredIndex.value =
          current == null ? 0 : (current + 1).clamp(0, count - 1);
    } else if (key == LogicalKeyboardKey.arrowUp) {
      final current = _hoveredIndex.value;
      _hoveredIndex.value =
          current == null ? count - 1 : (current - 1).clamp(0, count - 1);
    } else if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      final index = _hoveredIndex.value;
      if (index != null) {
        final entry = widget.dropdownMenuEntries[index];
        widget.onSelected?.call(entry.value);
      }
      _removeOverlay();
      setState(() {});
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    // Get index of selected item
    final selectedIndex = widget.dropdownMenuEntries.indexWhere(
      (entry) => entry.value == widget.selectedEntry?.value,
    );

    // Calculate vertical offset based on position
    double verticalOffset;
    switch (widget.position) {
      case FondeDropdownMenuPosition.overlay:
        verticalOffset =
            selectedIndex >= 0 ? -selectedIndex * size.height : 0.0;
        break;
      case FondeDropdownMenuPosition.below:
        verticalOffset = size.height;
        break;
      case FondeDropdownMenuPosition.above:
        verticalOffset = -(widget.dropdownMenuEntries.length * size.height);
        break;
    }

    // Calculate overlay menu width
    final overlayWidth =
        widget.showAsActionIcon ? (widget.width ?? 200.0) : size.width;

    // Calculate horizontal offset based on alignment
    final checkmarkOffset =
        widget.showCheckmark
            ? _AppDropdownMenuConstants.totalOffset * widget.zoomScale
            : 0.0;
    double horizontalOffset;
    switch (widget.alignment) {
      case FondeDropdownMenuAlignment.left:
        horizontalOffset = 0.0;
        break;
      case FondeDropdownMenuAlignment.center:
        horizontalOffset = -checkmarkOffset / 2;
        break;
      case FondeDropdownMenuAlignment.right:
        horizontalOffset = -checkmarkOffset;
        break;
      case FondeDropdownMenuAlignment.leftOverhang:
        horizontalOffset = -checkmarkOffset;
        break;
    }

    return OverlayEntry(
      builder: (context) {
        return KeyboardListener(
          focusNode: _keyboardFocusNode,
          onKeyEvent: _handleKeyEvent,
          child: Listener(
            // Full-screen transparent layer captures pointer move and up
            // events even when the pointer has left individual item widgets.
            onPointerMove: _handleOverlayPointerMove,
            onPointerUp: _handleOverlayPointerUp,
            behavior: HitTestBehavior.translucent,
            child: Stack(
              children: [
                // Menu panel
                Positioned(
                  width: overlayWidth,
                  height:
                      widget.dropdownMenuEntries.length *
                          (_AppDropdownMenuConstants.defaultHeight *
                              widget.zoomScale) +
                      _AppDropdownMenuConstants.verticalPadding *
                          widget.zoomScale,
                  child: CompositedTransformFollower(
                    link: _layerLink,
                    showWhenUnlinked: false,
                    offset: Offset(horizontalOffset, verticalOffset - 0.5),
                    child: Material(
                      color: Colors.transparent,
                      child: _AppDropdownOverlay<T>(
                        panelKey: _menuPanelKey,
                        entries: widget.dropdownMenuEntries,
                        onSelected: (value) {
                          widget.onSelected?.call(value);
                          _removeOverlay();
                          setState(() {});
                        },
                        borderRadius: widget.borderRadius,
                        backgroundColor: widget.overlayBackgroundColor,
                        borderColor: widget.overlayBorderColor,
                        textColor: widget.textColor,
                        textStyle: widget.textStyle,
                        buttonHeight: size.height,
                        selectedValue: widget.selectedEntry?.value,
                        overlayWidth: overlayWidth,
                        alignment: widget.alignment,
                        showCheckmark: widget.showCheckmark,
                        hoverBackgroundColor: widget.hoverBackgroundColor,
                        zoomScale: widget.zoomScale,
                        borderScale: widget.borderScale,
                        hoveredIndex: _hoveredIndex,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconTheme = context.fondeIconTheme;
    return _buildButton(context, iconTheme);
  }

  Widget _buildButton(BuildContext context, FondeIconTheme iconTheme) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Listener(
        onPointerDown: _handlePointerDown,
        onPointerMove: _handlePointerMove,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width:
              widget.showAsActionIcon
                  ? (_AppDropdownMenuConstants.defaultHeight * widget.zoomScale)
                  : widget.width,
          height:
              widget.height ??
              _AppDropdownMenuConstants.defaultHeight * widget.zoomScale,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: widget.borderRadius,
            border: Border.all(
              color: widget.borderColor,
              width: 1.5 * widget.borderScale,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal:
                _AppDropdownMenuConstants.horizontalPadding * widget.zoomScale,
            vertical:
                _AppDropdownMenuConstants.verticalPadding * widget.zoomScale,
          ),
          child:
              widget.showAsActionIcon
                  ? Align(
                    alignment: Alignment.center,
                    child: Icon(
                      widget.actionIcon ?? iconTheme.moreVert,
                      color: widget.textColor,
                      size: 20 * widget.zoomScale,
                    ),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.selectedEntry?.leadingIcon != null) ...[
                        Padding(
                          padding: EdgeInsets.only(top: 2.0 * widget.zoomScale),
                          child: widget.selectedEntry!.leadingIcon!,
                        ),
                        SizedBox(
                          width:
                              _AppDropdownMenuConstants.spacing *
                              widget.zoomScale,
                        ),
                      ],
                      Expanded(
                        child: FondeText(
                          widget.selectedEntry?.label ?? widget.hintText ?? '',
                          variant: FondeTextVariant.bodyText,
                          color:
                              widget.selectedEntry != null
                                  ? widget.textColor
                                  : widget.textColor.withValues(alpha: 0.6),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width:
                            _AppDropdownMenuConstants.spacing *
                            widget.zoomScale,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0 * widget.zoomScale),
                        child: Icon(
                          iconTheme.chevronDown,
                          color: widget.textColor,
                          size:
                              _AppDropdownMenuConstants.chevronIconSize *
                              widget.zoomScale,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}

/// Overlay menu implementation
class _AppDropdownOverlay<T> extends StatelessWidget {
  final GlobalKey panelKey;
  final List<DropdownMenuEntry<T>> entries;
  final ValueChanged<T?> onSelected;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final TextStyle? textStyle;
  final double buttonHeight;
  final T? selectedValue;
  final double overlayWidth;
  final FondeDropdownMenuAlignment alignment;
  final bool showCheckmark;
  final Color hoverBackgroundColor;
  final double zoomScale;
  final double borderScale;
  final ValueNotifier<int?> hoveredIndex;

  const _AppDropdownOverlay({
    super.key,
    required this.panelKey,
    required this.entries,
    required this.onSelected,
    required this.borderRadius,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    this.textStyle,
    required this.buttonHeight,
    this.selectedValue,
    required this.overlayWidth,
    required this.alignment,
    required this.showCheckmark,
    required this.hoverBackgroundColor,
    required this.zoomScale,
    required this.borderScale,
    required this.hoveredIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: panelKey,
      width: overlayWidth,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor, width: 1.5 * borderScale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8.0 * zoomScale,
            offset: Offset(0, 4 * zoomScale),
          ),
        ],
      ),
      child: ValueListenableBuilder<int?>(
        valueListenable: hoveredIndex,
        builder: (context, hovered, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(entries.length, (index) {
              final entry = entries[index];
              return _AppDropdownMenuItem<T>(
                entry: entry,
                onSelected: onSelected,
                textColor: textColor,
                textStyle: textStyle,
                buttonHeight: buttonHeight,
                isSelected: entry.value == selectedValue,
                isHovered: hovered == index,
                alignment: alignment,
                showCheckmark: showCheckmark,
                hoverBackgroundColor: hoverBackgroundColor,
                zoomScale: zoomScale,
              );
            }),
          );
        },
      ),
    );
  }
}

/// Dropdown menu item implementation
class _AppDropdownMenuItem<T> extends StatelessWidget {
  final DropdownMenuEntry<T> entry;
  final ValueChanged<T?> onSelected;
  final Color textColor;
  final TextStyle? textStyle;
  final double buttonHeight;
  final bool isSelected;
  final bool isHovered;
  final FondeDropdownMenuAlignment alignment;
  final bool showCheckmark;
  final Color hoverBackgroundColor;
  final double zoomScale;

  const _AppDropdownMenuItem({
    super.key,
    required this.entry,
    required this.onSelected,
    required this.textColor,
    this.textStyle,
    required this.buttonHeight,
    required this.isSelected,
    required this.isHovered,
    required this.alignment,
    required this.showCheckmark,
    required this.hoverBackgroundColor,
    required this.zoomScale,
  });

  @override
  Widget build(BuildContext context) {
    final iconTheme = context.fondeIconTheme;
    return Container(
      height: _AppDropdownMenuConstants.defaultHeight * zoomScale,
      color: isHovered ? hoverBackgroundColor : Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: _AppDropdownMenuConstants.horizontalPadding * zoomScale,
        vertical: _AppDropdownMenuConstants.verticalPadding * zoomScale,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showCheckmark &&
              alignment != FondeDropdownMenuAlignment.left) ...[
            SizedBox(
              width: _AppDropdownMenuConstants.checkboxSpaceWidth * zoomScale,
              child:
                  isSelected
                      ? Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 4.0 * zoomScale),
                          child: Icon(
                            iconTheme.check,
                            color: textColor,
                            size:
                                _AppDropdownMenuConstants.checkIconSize *
                                zoomScale,
                          ),
                        ),
                      )
                      : null,
            ),
            SizedBox(width: _AppDropdownMenuConstants.spacing * zoomScale),
          ],
          if (entry.leadingIcon != null) ...[
            Padding(
              padding: EdgeInsets.only(top: 2.0 * zoomScale),
              child: entry.leadingIcon!,
            ),
            SizedBox(width: _AppDropdownMenuConstants.spacing * zoomScale),
          ],
          Flexible(
            child:
                entry.labelWidget ??
                FondeText(
                  entry.label,
                  variant: FondeTextVariant.bodyText,
                  color: textColor,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
          ),
          if (entry.trailingIcon != null) ...[
            SizedBox(width: _AppDropdownMenuConstants.spacing * zoomScale),
            entry.trailingIcon!,
          ],
        ],
      ),
    );
  }
}
