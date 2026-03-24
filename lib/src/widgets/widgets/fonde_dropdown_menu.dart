import 'package:flutter/gestures.dart';
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

  /// Whether to show the macOS-style selection effect (flash + fade out)
  final bool selectionEffect;

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
    this.selectionEffect = true,
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
      selectionEffect: selectionEffect,
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
  final bool selectionEffect;

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
    this.selectionEffect = true,
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
      selectionEffect: selectionEffect,
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
  final bool selectionEffect;

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
    this.selectionEffect = true,
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

  // The pointer ID of the tap that opened the menu.
  int? _openingPointerId;
  // Timestamp when the opening tap went down.
  DateTime? _openingPointerDownAt;
  // Position where the opening tap went down.
  Offset? _openingPointerDownPosition;
  // Releases of the opening tap within this duration are ignored (menu stays open),
  // unless the pointer has moved to a different item (press-drag-release).
  static const _longPressThreshold = Duration(milliseconds: 500);
  bool _globalRouteRegistered = false;

  // Selection effect state: opacity of the overlay (1.0 = visible, 0.0 = hidden)
  final ValueNotifier<double> _overlayOpacity = ValueNotifier<double>(1.0);
  // True while the selection effect is running — hover updates are suppressed.
  bool _selectionEffectRunning = false;

  @override
  void dispose() {
    _removeOverlay();
    _hoveredIndex.dispose();
    _overlayOpacity.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  void _removeOverlay() {
    if (_globalRouteRegistered) {
      GestureBinding.instance.pointerRouter.removeGlobalRoute(
        _onGlobalPointerEvent,
      );
      _globalRouteRegistered = false;
    }
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
    _selectionEffectRunning = false;
    _hoveredIndex.value = null;
    _overlayOpacity.value = 1.0;
    _keyboardFocusNode.unfocus();
  }

  // Runs the macOS-style selection effect then calls [onDone].
  // 1. Hide highlight (50ms) → 2. Show highlight (100ms) → 3. Fade out (150ms)
  Future<void> _runSelectionEffect(int selectedIndex) async {
    _selectionEffectRunning = true;
    // Step 1: hide highlight
    _hoveredIndex.value = null;
    await Future.delayed(const Duration(milliseconds: 50));
    if (!_isOpen) return;
    // Step 2: restore highlight
    _hoveredIndex.value = selectedIndex;
    await Future.delayed(const Duration(milliseconds: 100));
    if (!_isOpen) return;
    // Step 3: fade out overlay
    const steps = 10;
    const stepDuration = Duration(milliseconds: 15); // ~150ms total
    for (int i = steps - 1; i >= 0; i--) {
      _overlayOpacity.value = i / steps;
      await Future.delayed(stepDuration);
      if (!_isOpen) return;
    }
    _selectionEffectRunning = false;
  }

  // Select an item with optional effect, then close.
  Future<void> _selectAndClose(int? index) async {
    final entry = index != null ? widget.dropdownMenuEntries[index] : null;
    if (widget.selectionEffect && index != null) {
      await _runSelectionEffect(index);
      if (!_isOpen) return; // closed by other means during effect
    }
    if (entry != null) widget.onSelected?.call(entry.value);
    _removeOverlay();
    setState(() {});
  }

  void _openOverlay(int pointerId) {
    if (_isOpen) return;
    _openingPointerId = pointerId;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    // Register a root-level pointer route so we receive move events regardless
    // of which widget the pointer is over (including the menu panel itself).
    if (!_globalRouteRegistered) {
      GestureBinding.instance.pointerRouter.addGlobalRoute(
        _onGlobalPointerEvent,
      );
      _globalRouteRegistered = true;
    }
    // Request focus after the overlay is inserted so keyboard events are received.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isOpen) _keyboardFocusNode.requestFocus();
    });
    setState(() => _isOpen = true);
  }

  void _onGlobalPointerEvent(PointerEvent event) {
    if (!_isOpen) return;
    if (event is PointerMoveEvent || event is PointerHoverEvent) {
      if (!_selectionEffectRunning) {
        final index = _findItemIndexAt(event.position);
        _hoveredIndex.value = index;
      }
    } else if (event is PointerUpEvent) {
      _handleOverlayPointerUp(event);
    }
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
    if (!_isOpen) {
      _openingPointerDownAt = DateTime.now();
      _openingPointerDownPosition = event.position;
      _openOverlay(event.pointer);
      // Highlight the item under the pointer immediately on press.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_isOpen) {
          _hoveredIndex.value = _findItemIndexAt(event.position);
        }
      });
    }
    // If already open, do nothing on down — let pointerUp handle it.
  }

  // Called from the button's Listener — kept for press-drag from button.
  void _handlePointerMove(PointerMoveEvent event) {
    // Handled by _onGlobalPointerEvent; nothing needed here.
  }

  // All pointer-up handling is done here (via global pointer route).
  void _handleOverlayPointerUp(PointerUpEvent event) {
    if (!_isOpen) return;

    // Release of the opening tap.
    if (event.pointer == _openingPointerId) {
      _openingPointerId = null;
      final downAt = _openingPointerDownAt;
      final downPos = _openingPointerDownPosition;
      _openingPointerDownAt = null;
      _openingPointerDownPosition = null;
      final held =
          downAt != null ? DateTime.now().difference(downAt) : Duration.zero;
      // Short tap: check movement distance.
      if (held < _longPressThreshold) {
        final dist =
            downPos != null ? (event.position - downPos).distance : 0.0;
        if (dist < 4.0) {
          // Barely moved — treat as the opening tap, keep menu open.
          return;
        }
        // Moved enough (press-drag-release) → fall through to select.
      }
      // Long press or drag to different item → fall through to select.
    }

    // Any other release (second tap, long-press release): select then close.
    final index = _findItemIndexAt(event.position);
    _selectAndClose(index);
  }

  void _handleOverlayPointerMove(PointerMoveEvent event) {
    // Handled by _onGlobalPointerEvent.
  }

  void _handleKeyEvent(KeyEvent event) {
    if (!_isOpen) return;
    if (_selectionEffectRunning) return;
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
      _selectAndClose(index);
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
        return ValueListenableBuilder<double>(
          valueListenable: _overlayOpacity,
          builder:
              (context, opacity, child) =>
                  Opacity(opacity: opacity, child: child),
          child: KeyboardListener(
            focusNode: _keyboardFocusNode,
            onKeyEvent: _handleKeyEvent,
            child: Listener(
              // Move and up are handled via the global pointer route.
              // This Listener is kept as structural scaffolding for the overlay.
              onPointerMove: _handleOverlayPointerMove,
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
    // IgnorePointer lets move/up events pass through to the overlay Listener.
    return IgnorePointer(
      child: Container(
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
      ),
    );
  }
}
