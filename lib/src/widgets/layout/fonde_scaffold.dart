import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../internal.dart';

import '../toolbar/secondary_sidebar_toolbar.dart';
import '../widgets/fonde_icon_button.dart';
import '../navigation/sidebar.dart';
import 'collapsed_sidebar_layout.dart';
import 'main_content_area.dart';
import 'primary_side.dart';
import 'sidebar_pane.dart';

/// The top-level scaffold layout of a fonde_ui application.
///
/// Layout configuration:
/// - Top: Toolbar (fixed height)
/// - Bottom: Main layout
///   - Launch bar (variable width)
///   - Primary sidebar (variable width)
///   - Main content (flex)
///   - Secondary sidebar (variable width, optional)
///
/// Sidebar visibility and width are managed internally. Supply external
/// [FondePrimarySidebarController] / [FondeSecondarySidebarController]
/// instances (and width controllers) if you need to drive them from outside
/// the widget tree.
class FondeScaffold extends StatefulWidget {
  const FondeScaffold({
    required this.toolbar,
    required this.content,
    this.launchBar,
    this.primarySidebar,
    this.secondarySidebar,
    this.statusBar,
    this.showLaunchBar = true,
    this.showPrimarySidebar = true,
    this.showSecondarySidebar = true,
    this.disableZoom = false,
    this.useSafeArea,
    this.primarySidebarController,
    this.secondarySidebarController,
    this.primarySidebarWidthController,
    this.secondarySidebarWidthController,
    super.key,
  });

  final Widget toolbar;
  final Widget content;
  final Widget? launchBar;
  final Widget? primarySidebar;
  final Widget? secondarySidebar;

  /// Optional status bar displayed at the bottom of the scaffold.
  final Widget? statusBar;

  final bool showLaunchBar;
  final bool showPrimarySidebar;
  final bool showSecondarySidebar;
  final bool disableZoom;

  /// Whether to wrap the scaffold in a [SafeArea].
  /// Defaults to `true` on iOS and Android, `false` otherwise.
  final bool? useSafeArea;

  /// External primary sidebar visibility controller.
  /// When `null`, [FondeScaffold] creates and owns an internal one.
  final FondePrimarySidebarController? primarySidebarController;

  /// External secondary sidebar visibility controller.
  final FondeSecondarySidebarController? secondarySidebarController;

  /// External primary sidebar width controller.
  final FondeSidebarWidthController? primarySidebarWidthController;

  /// External secondary sidebar width controller.
  final FondeSecondarySidebarWidthController? secondarySidebarWidthController;

  @override
  State<FondeScaffold> createState() => _FondeScaffoldState();
}

bool get _isMobilePlatform =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);

class _FondeScaffoldState extends State<FondeScaffold> {
  late FondePrimarySidebarController _primarySidebarCtrl;
  late FondeSecondarySidebarController _secondarySidebarCtrl;
  late FondeSidebarWidthController _primaryWidthCtrl;
  late FondeSecondarySidebarWidthController _secondaryWidthCtrl;

  bool _ownsPrimary = false;
  bool _ownsSecondary = false;
  bool _ownsPrimaryWidth = false;
  bool _ownsSecondaryWidth = false;

  bool get _effectiveUseSafeArea => widget.useSafeArea ?? _isMobilePlatform;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _primarySidebarCtrl.addListener(_onSidebarChanged);
    _secondarySidebarCtrl.addListener(_onSidebarChanged);
    _primaryWidthCtrl.addListener(_onSidebarChanged);
    _secondaryWidthCtrl.addListener(_onSidebarChanged);
  }

  void _initControllers() {
    if (widget.primarySidebarController != null) {
      _primarySidebarCtrl = widget.primarySidebarController!;
    } else {
      _primarySidebarCtrl = FondePrimarySidebarController();
      _ownsPrimary = true;
    }
    if (widget.secondarySidebarController != null) {
      _secondarySidebarCtrl = widget.secondarySidebarController!;
    } else {
      _secondarySidebarCtrl = FondeSecondarySidebarController();
      _ownsSecondary = true;
    }
    if (widget.primarySidebarWidthController != null) {
      _primaryWidthCtrl = widget.primarySidebarWidthController!;
    } else {
      _primaryWidthCtrl = FondeSidebarWidthController();
      _ownsPrimaryWidth = true;
    }
    if (widget.secondarySidebarWidthController != null) {
      _secondaryWidthCtrl = widget.secondarySidebarWidthController!;
    } else {
      _secondaryWidthCtrl = FondeSecondarySidebarWidthController();
      _ownsSecondaryWidth = true;
    }
  }

  void _onSidebarChanged() => setState(() {});

  @override
  void dispose() {
    _primarySidebarCtrl.removeListener(_onSidebarChanged);
    _secondarySidebarCtrl.removeListener(_onSidebarChanged);
    _primaryWidthCtrl.removeListener(_onSidebarChanged);
    _secondaryWidthCtrl.removeListener(_onSidebarChanged);
    if (_ownsPrimary) _primarySidebarCtrl.dispose();
    if (_ownsSecondary) _secondarySidebarCtrl.dispose();
    if (_ownsPrimaryWidth) _primaryWidthCtrl.dispose();
    if (_ownsSecondaryWidth) _secondaryWidthCtrl.dispose();
    super.dispose();
  }

  Widget _wrapSafeArea(Widget child) =>
      _effectiveUseSafeArea ? SafeArea(child: child) : child;

  @override
  Widget build(BuildContext context) {
    final accessibility = context.fondeAccessibility;
    final zoomScale = widget.disableZoom ? 1.0 : accessibility.zoomScale;
    final borderScale = widget.disableZoom ? 1.0 : accessibility.borderScale;
    final appColorScheme = context.fondeColorScheme;
    final iconTheme = context.fondeIconTheme;

    final sidebarVisible =
        widget.showPrimarySidebar && _primarySidebarCtrl.isVisible;
    final secondarySidebarVisible = _secondarySidebarCtrl.isVisible;

    return FondeSidebarControllerScope(
      primaryController: _primarySidebarCtrl,
      secondaryController: _secondarySidebarCtrl,
      primaryWidthController: _primaryWidthCtrl,
      secondaryWidthController: _secondaryWidthCtrl,
      child: _wrapSafeArea(
        _buildBody(
          context,
          sidebarVisible: sidebarVisible,
          secondarySidebarVisible: secondarySidebarVisible,
          zoomScale: zoomScale,
          borderScale: borderScale,
          appColorScheme: appColorScheme,
          iconTheme: iconTheme,
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required bool sidebarVisible,
    required bool secondarySidebarVisible,
    required double zoomScale,
    required double borderScale,
    required FondeColorScheme appColorScheme,
    required FondeIconTheme iconTheme,
  }) {
    if (!sidebarVisible) {
      const double openButtonWidth = 28.0;
      final openButtonArea = Container(
        width: openButtonWidth,
        color: appColorScheme.uiAreas.toolbar.background,
        padding: const EdgeInsets.only(left: 8.0),
        alignment: Alignment.centerLeft,
        child: FondeIconButton(
          icon: iconTheme.panelLeft,
          iconSize: 20,
          onPressed: _primarySidebarCtrl.show,
          tooltip: 'Open Sidebar',
          padding: EdgeInsets.zero,
          hoverColor: Colors.transparent,
        ),
      );
      return FondeCollapsedSidebarLayout(
        toolbar: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: openButtonWidth),
              child: widget.toolbar,
            ),
            Positioned(left: 0, top: 0, bottom: 0, child: openButtonArea),
          ],
        ),
        mainContent: _buildMainContent(context, zoomScale, 288.0 * zoomScale),
        launchBar: widget.launchBar,
        showLaunchBar: widget.showLaunchBar,
        zoomScale: zoomScale,
        borderScale: borderScale,
        disableZoom: widget.disableZoom,
      );
    }

    final hasSecondarySidebar =
        widget.secondarySidebar != null &&
        widget.showSecondarySidebar &&
        secondarySidebarVisible;

    Widget? sidebarPane;
    if (widget.primarySidebar != null) {
      final sidebarHasToolbar =
          widget.primarySidebar is FondeSidebar &&
          (widget.primarySidebar! as FondeSidebar).toolbar != null;
      sidebarPane =
          sidebarHasToolbar
              ? widget.primarySidebar!
              : FondeSidebarPane(child: widget.primarySidebar!);
    }

    final primaryPane = FondePrimarySide(
      launchBar: widget.launchBar,
      sidebar: sidebarPane,
      showLaunchBar: widget.showLaunchBar,
      showSidebar: widget.showPrimarySidebar,
      zoomScale: zoomScale,
      borderScale: borderScale,
      disableZoom: widget.disableZoom,
    );

    final mainPane = Column(
      children: [
        widget.toolbar,
        Expanded(child: FondeMainContentArea(child: widget.content)),
        if (widget.statusBar != null) widget.statusBar!,
      ],
    );

    final secondaryPane =
        hasSecondarySidebar
            ? Column(
              children: [
                const FondeSecondarySidebarToolbar(),
                Expanded(
                  child: widget.secondarySidebar ?? const SizedBox.shrink(),
                ),
              ],
            )
            : null;

    return _ScaffoldSplitView(
      primaryPane: primaryPane,
      mainPane: mainPane,
      secondaryPane: secondaryPane,
      primaryWidthCtrl: _primaryWidthCtrl,
      secondaryWidthCtrl: _secondaryWidthCtrl,
      zoomScale: zoomScale,
      borderScale: borderScale,
      dividerColor: appColorScheme.base.divider,
      dividerHighlightColor: appColorScheme.theme.primaryColor,
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    double zoomScale,
    double secondaryWidth,
  ) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: FondeMainContentArea(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 480 * zoomScale),
                    child: widget.content,
                  ),
                ),
              ),
              if (widget.secondarySidebar != null &&
                  widget.showSecondarySidebar)
                SizedBox(
                  width: secondaryWidth,
                  child: widget.secondarySidebar!,
                ),
            ],
          ),
        ),
        if (widget.statusBar != null) widget.statusBar!,
      ],
    );
  }
}

/// Internal horizontal split layout for [FondeScaffold].
///
/// Manages pixel sizes for primary sidebar, main content, and optional
/// secondary sidebar with min/max constraints and drag-to-resize dividers.
class _ScaffoldSplitView extends StatefulWidget {
  const _ScaffoldSplitView({
    required this.primaryPane,
    required this.mainPane,
    required this.secondaryPane,
    required this.primaryWidthCtrl,
    required this.secondaryWidthCtrl,
    required this.zoomScale,
    required this.borderScale,
    required this.dividerColor,
    required this.dividerHighlightColor,
  });

  final Widget primaryPane;
  final Widget mainPane;
  final Widget? secondaryPane;
  final FondeSidebarWidthController primaryWidthCtrl;
  final FondeSecondarySidebarWidthController secondaryWidthCtrl;
  final double zoomScale;
  final double borderScale;
  final Color dividerColor;
  final Color dividerHighlightColor;

  @override
  State<_ScaffoldSplitView> createState() => _ScaffoldSplitViewState();
}

class _ScaffoldSplitViewState extends State<_ScaffoldSplitView> {
  // Pixel widths; initialized from controllers on first layout.
  double _primaryWidth = 0;
  double _secondaryWidth = 0;
  bool _initialized = false;

  // Hovered divider index: 0 = primary divider, 1 = secondary divider, -1 = none.
  int _hoveredDivider = -1;

  static const double _dividerThickness = 2.0;

  double get _effectiveDividerThickness =>
      _dividerThickness * widget.borderScale;

  double _primaryMin() => 240.0 * widget.zoomScale;
  double _primaryMax() => 480.0 * widget.zoomScale;
  double _secondaryMin() => 200.0 * widget.zoomScale;
  double _secondaryMax() => 400.0 * widget.zoomScale;

  void _initSizes() {
    _primaryWidth = (widget.primaryWidthCtrl.width * widget.zoomScale).clamp(
      _primaryMin(),
      _primaryMax(),
    );
    _secondaryWidth = (widget.secondaryWidthCtrl.width * widget.zoomScale)
        .clamp(_secondaryMin(), _secondaryMax());
    _initialized = true;
  }

  void _onPrimaryDividerDrag(double delta) {
    setState(() {
      _primaryWidth = (_primaryWidth + delta).clamp(
        _primaryMin(),
        _primaryMax(),
      );
    });
    widget.primaryWidthCtrl.setWidth(_primaryWidth / widget.zoomScale);
  }

  void _onSecondaryDividerDrag(double delta) {
    // Secondary divider: dragging right increases secondary width.
    setState(() {
      _secondaryWidth = (_secondaryWidth - delta).clamp(
        _secondaryMin(),
        _secondaryMax(),
      );
    });
    widget.secondaryWidthCtrl.setWidth(_secondaryWidth / widget.zoomScale);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!_initialized) {
          _initSizes();
        }

        final hasSecondary = widget.secondaryPane != null;
        final dividerThickness = _effectiveDividerThickness;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Primary sidebar
            SizedBox(width: _primaryWidth, child: widget.primaryPane),

            // Primary divider
            _ScaffoldDivider(
              thickness: dividerThickness,
              isHovered: _hoveredDivider == 0,
              normalColor: widget.dividerColor,
              highlightColor: widget.dividerHighlightColor,
              onHoverChanged:
                  (h) => setState(() => _hoveredDivider = h ? 0 : -1),
              onDragUpdate: _onPrimaryDividerDrag,
            ),

            // Main content (flex)
            Expanded(child: widget.mainPane),

            // Secondary divider + pane
            if (hasSecondary) ...[
              _ScaffoldDivider(
                thickness: dividerThickness,
                isHovered: _hoveredDivider == 1,
                normalColor: widget.dividerColor,
                highlightColor: widget.dividerHighlightColor,
                onHoverChanged:
                    (h) => setState(() => _hoveredDivider = h ? 1 : -1),
                onDragUpdate: _onSecondaryDividerDrag,
              ),
              SizedBox(width: _secondaryWidth, child: widget.secondaryPane!),
            ],
          ],
        );
      },
    );
  }
}

/// Horizontal drag divider used inside [_ScaffoldSplitView].
class _ScaffoldDivider extends StatefulWidget {
  const _ScaffoldDivider({
    required this.thickness,
    required this.isHovered,
    required this.normalColor,
    required this.highlightColor,
    required this.onHoverChanged,
    required this.onDragUpdate,
  });

  final double thickness;
  final bool isHovered;
  final Color normalColor;
  final Color highlightColor;
  final void Function(bool hovered) onHoverChanged;
  final void Function(double delta) onDragUpdate;

  @override
  State<_ScaffoldDivider> createState() => _ScaffoldDividerState();
}

class _ScaffoldDividerState extends State<_ScaffoldDivider> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isHovered || _isDragging;

    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      onEnter: (_) => widget.onHoverChanged(true),
      onExit: (_) => widget.onHoverChanged(false),
      child: GestureDetector(
        onHorizontalDragStart: (_) => setState(() => _isDragging = true),
        onHorizontalDragEnd: (_) => setState(() => _isDragging = false),
        onHorizontalDragUpdate: (d) => widget.onDragUpdate(d.delta.dx),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: widget.thickness,
          color: isActive ? widget.highlightColor : widget.normalColor,
        ),
      ),
    );
  }
}
