import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal.dart';
import 'fonde_rectangle_border.dart';
import '../icons/icon_theme_providers.dart';

/// Action item for FondeSplitButton
class FondeSplitButtonAction {
  /// Label of the action
  final String label;

  /// Callback when the action is executed
  final VoidCallback onPressed;

  /// Icon for the action (optional)
  final Widget? icon;

  /// Whether the action is enabled
  final bool enabled;

  const FondeSplitButtonAction({
    required this.label,
    required this.onPressed,
    this.icon,
    this.enabled = true,
  });
}

/// App app common SplitButton
///
/// A component that combines a primary action button and a dropdown menu
/// where additional actions can be selected.
class FondeSplitButton extends ConsumerWidget {
  /// Label for the primary action
  final String primaryLabel;

  /// Callback when the primary action is pressed
  final VoidCallback? onPrimaryPressed;

  /// Icon for the primary action (optional)
  final Widget? primaryIcon;

  /// List of additional actions
  final List<FondeSplitButtonAction> actions;

  /// Width of the button
  final double? width;

  /// Height of the button
  final double? height;

  /// Text style
  final TextStyle? textStyle;

  /// Enabled/disabled state
  final bool enabled;

  /// Corner radius (uses FondeRectangleBorder's default if not specified)
  final double? cornerRadius;

  /// Corner smoothing (uses FondeRectangleBorder's default if not specified)
  final double? cornerSmoothing;

  /// Background color of the button
  final Color? backgroundColor;

  /// Border color of the button
  final Color? borderColor;

  /// Text color of the button
  final Color? textColor;

  /// Background color of the dropdown menu
  final Color? menuBackgroundColor;

  /// Border color of the dropdown menu
  final Color? menuBorderColor;

  /// Whether to disable zoom functionality
  final bool disableZoom;

  /// Constructor
  const FondeSplitButton({
    super.key,
    required this.primaryLabel,
    this.onPrimaryPressed,
    this.primaryIcon,
    required this.actions,
    this.width,
    this.height,
    this.textStyle,
    this.enabled = true,
    this.cornerRadius,
    this.cornerSmoothing,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.menuBackgroundColor,
    this.menuBorderColor,
    this.disableZoom = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get theme colors using core_themes API
    final appColorScheme = ref.watch(fondeColorSchemeProvider);
    final themeData = ref.watch(fondeEffectiveThemeDataProvider);
    final accessibilityConfig = ref.watch(fondeAccessibilityConfigProvider);

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

    return _AppSplitButtonWidget(
      primaryLabel: primaryLabel,
      onPrimaryPressed: onPrimaryPressed,
      primaryIcon: primaryIcon,
      actions: actions,
      width: width != null ? width! * zoomScale : null,
      height: height != null ? height! * zoomScale : null,
      textStyle: effectiveTextStyle,
      enabled: enabled,
      borderRadius: smoothBorderRadius,
      backgroundColor:
          backgroundColor ?? appColorScheme.uiAreas.sideBar.background,
      borderColor: borderColor ?? appColorScheme.base.border,
      textColor: textColor ?? appColorScheme.base.foreground,
      menuBackgroundColor:
          menuBackgroundColor ?? appColorScheme.uiAreas.sideBar.background,
      menuBorderColor: menuBorderColor ?? appColorScheme.base.border,
      hoverBackgroundColor:
          appColorScheme.interactive.list.itemBackground.hover,
      zoomScale: zoomScale,
      borderScale: borderScale,
    );
  }
}

// Constants for FondeSplitButton
class _AppSplitButtonConstants {
  static const double horizontalPadding = 12.0;
  static const double verticalPadding = 8.0;
  static const double defaultHeight = 48.0;
  static const double chevronIconSize = 16.0;
  static const double iconSpacing = 4.0;
  static const double dropdownButtonWidth = 32.0;
}

/// Internal implementation widget for FondeSplitButton
class _AppSplitButtonWidget extends StatefulWidget {
  final String primaryLabel;
  final VoidCallback? onPrimaryPressed;
  final Widget? primaryIcon;
  final List<FondeSplitButtonAction> actions;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final bool enabled;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color menuBackgroundColor;
  final Color menuBorderColor;
  final Color hoverBackgroundColor;
  final double zoomScale;
  final double borderScale;

  const _AppSplitButtonWidget({
    required this.primaryLabel,
    this.onPrimaryPressed,
    this.primaryIcon,
    required this.actions,
    this.width,
    this.height,
    this.textStyle,
    this.enabled = true,
    required this.borderRadius,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.menuBackgroundColor,
    required this.menuBorderColor,
    required this.hoverBackgroundColor,
    required this.zoomScale,
    required this.borderScale,
  });

  @override
  State<_AppSplitButtonWidget> createState() => _AppSplitButtonWidgetState();
}

class _AppSplitButtonWidgetState extends State<_AppSplitButtonWidget> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
  }

  void _showOverlay() {
    if (_isOpen) {
      _removeOverlay();
      return;
    }

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _isOpen = true;
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder:
          (context) => GestureDetector(
            // Close the menu when tapping outside the overlay menu area
            onTap: _removeOverlay,
            behavior: HitTestBehavior.translucent,
            child: Stack(
              children: [
                // Transparent area covering the entire screen
                Positioned.fill(child: Container(color: Colors.transparent)),
                // Overlay menu body
                Positioned(
                  child: CompositedTransformFollower(
                    link: _layerLink,
                    showWhenUnlinked: false,
                    offset: Offset(0, size.height),
                    child: GestureDetector(
                      // Do not propagate taps inside the menu to the parent GestureDetector
                      onTap: () {},
                      child: Material(
                        color: Colors.transparent,
                        child: _AppSplitButtonMenu(
                          actions: widget.actions,
                          borderRadius: widget.borderRadius,
                          backgroundColor: widget.menuBackgroundColor,
                          borderColor: widget.menuBorderColor,
                          textColor: widget.textColor,
                          textStyle: widget.textStyle,
                          hoverBackgroundColor: widget.hoverBackgroundColor,
                          zoomScale: widget.zoomScale,
                          borderScale: widget.borderScale,
                          onActionSelected: (action) {
                            action.onPressed();
                            _removeOverlay();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final iconTheme = ref.watch(fondeDefaultIconThemeProvider);
        return _buildButton(context, iconTheme);
      },
    );
  }

  Widget _buildButton(BuildContext context, FondeIconTheme iconTheme) {
    final effectiveHeight =
        widget.height ??
        _AppSplitButtonConstants.defaultHeight * widget.zoomScale;

    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: widget.width,
        height: effectiveHeight,
        child: Row(
          mainAxisSize:
              widget.width != null ? MainAxisSize.max : MainAxisSize.min,
          children: [
            // Primary button section
            if (widget.width != null)
              Expanded(
                child: GestureDetector(
                  onTap: widget.enabled ? widget.onPrimaryPressed : null,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: effectiveHeight,
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: widget.borderRadius.topLeft,
                        bottomLeft: widget.borderRadius.bottomLeft,
                      ),
                      border: Border.all(
                        color: widget.borderColor,
                        width: 1.5 * widget.borderScale,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          _AppSplitButtonConstants.horizontalPadding *
                          widget.zoomScale,
                      vertical:
                          _AppSplitButtonConstants.verticalPadding *
                          widget.zoomScale,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.primaryIcon != null) ...[
                          widget.primaryIcon!,
                          SizedBox(
                            width:
                                _AppSplitButtonConstants.iconSpacing *
                                widget.zoomScale,
                          ),
                        ],
                        Flexible(
                          child: Text(
                            widget.primaryLabel,
                            style: widget.textStyle?.copyWith(
                              color:
                                  widget.enabled
                                      ? widget.textColor
                                      : widget.textColor.withValues(alpha: 0.6),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              GestureDetector(
                onTap: widget.enabled ? widget.onPrimaryPressed : null,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: effectiveHeight,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: widget.borderRadius.topLeft,
                      bottomLeft: widget.borderRadius.bottomLeft,
                    ),
                    border: Border.all(
                      color: widget.borderColor,
                      width: 1.5 * widget.borderScale,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        _AppSplitButtonConstants.horizontalPadding *
                        widget.zoomScale,
                    vertical:
                        _AppSplitButtonConstants.verticalPadding *
                        widget.zoomScale,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.primaryIcon != null) ...[
                        widget.primaryIcon!,
                        SizedBox(
                          width:
                              _AppSplitButtonConstants.iconSpacing *
                              widget.zoomScale,
                        ),
                      ],
                      Text(
                        widget.primaryLabel,
                        style: widget.textStyle?.copyWith(
                          color:
                              widget.enabled
                                  ? widget.textColor
                                  : widget.textColor.withValues(alpha: 0.6),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            // Space between buttons
            SizedBox(width: 2.0 * widget.zoomScale),
            // Dropdown button section
            GestureDetector(
              onTap: widget.enabled ? _showOverlay : null,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width:
                    _AppSplitButtonConstants.dropdownButtonWidth *
                    widget.zoomScale,
                height: effectiveHeight,
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topRight: widget.borderRadius.topRight,
                    bottomRight: widget.borderRadius.bottomRight,
                  ),
                  border: Border.all(
                    color: widget.borderColor,
                    width: 1.5 * widget.borderScale,
                  ),
                ),
                child: Center(
                  child: Icon(
                    iconTheme.chevronDown,
                    color:
                        widget.enabled
                            ? widget.textColor
                            : widget.textColor.withValues(alpha: 0.6),
                    size:
                        _AppSplitButtonConstants.chevronIconSize *
                        widget.zoomScale,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dropdown menu for the split button
class _AppSplitButtonMenu extends StatelessWidget {
  final List<FondeSplitButtonAction> actions;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final TextStyle? textStyle;
  final Color hoverBackgroundColor;
  final double zoomScale;
  final double borderScale;
  final ValueChanged<FondeSplitButtonAction> onActionSelected;

  const _AppSplitButtonMenu({
    required this.actions,
    required this.borderRadius,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    this.textStyle,
    required this.hoverBackgroundColor,
    required this.zoomScale,
    required this.borderScale,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            actions
                .map(
                  (action) => _AppSplitButtonMenuItem(
                    action: action,
                    textColor: textColor,
                    textStyle: textStyle,
                    hoverBackgroundColor: hoverBackgroundColor,
                    zoomScale: zoomScale,
                    onPressed: () => onActionSelected(action),
                  ),
                )
                .toList(),
      ),
    );
  }
}

/// Item for the split button menu
class _AppSplitButtonMenuItem extends StatefulWidget {
  final FondeSplitButtonAction action;
  final Color textColor;
  final TextStyle? textStyle;
  final Color hoverBackgroundColor;
  final double zoomScale;
  final VoidCallback onPressed;

  const _AppSplitButtonMenuItem({
    required this.action,
    required this.textColor,
    this.textStyle,
    required this.hoverBackgroundColor,
    required this.zoomScale,
    required this.onPressed,
  });

  @override
  State<_AppSplitButtonMenuItem> createState() =>
      _AppSplitButtonMenuItemState();
}

class _AppSplitButtonMenuItemState extends State<_AppSplitButtonMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.action.enabled ? widget.onPressed : null,
        behavior: HitTestBehavior.opaque,
        child: Container(
          color:
              _isHovered && widget.action.enabled
                  ? widget.hoverBackgroundColor
                  : Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal:
                _AppSplitButtonConstants.horizontalPadding * widget.zoomScale,
            vertical:
                _AppSplitButtonConstants.verticalPadding * widget.zoomScale,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.action.icon != null) ...[
                widget.action.icon!,
                SizedBox(
                  width:
                      _AppSplitButtonConstants.iconSpacing * widget.zoomScale,
                ),
              ],
              Flexible(
                child: Text(
                  widget.action.label,
                  style: widget.textStyle?.copyWith(
                    color:
                        widget.action.enabled
                            ? widget.textColor
                            : widget.textColor.withValues(alpha: 0.6),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
