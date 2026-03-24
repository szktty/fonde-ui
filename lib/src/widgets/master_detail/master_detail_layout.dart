import 'package:flutter/material.dart';
import './master_detail_state.dart';
import '../widgets/fonde_divider.dart';

/// Signature for building master items
typedef FondeMasterItemBuilder =
    Widget Function(
      BuildContext context,
      String itemId,
      bool isSelected,
      VoidCallback onSelect,
    );

/// A layout widget that implements the master-detail pattern.
class FondeMasterDetailLayout extends StatefulWidget {
  const FondeMasterDetailLayout({
    required this.items,
    required this.masterItemBuilder,
    required this.detailBuilder,
    this.initialMasterWidth = 280,
    this.minMasterWidth = 200,
    this.maxMasterWidth = 400,
    this.breakpoint = 600,
    this.showDetailOnInit = false,
    this.initialSelectedId,
    this.dividerColor,
    this.masterBackgroundColor,
    this.detailBackgroundColor,
    this.resizeBarColor,
    this.resizeBarWidth = 2.0,
    this.masterPadding = const EdgeInsets.only(top: 20.0, right: 20.0),
    this.detailPadding = const EdgeInsets.only(top: 20.0, right: 20.0),
    super.key,
  });

  /// List of item IDs to display in master view
  final List<String> items;

  /// Builder for individual items in master view
  final FondeMasterItemBuilder masterItemBuilder;

  /// Builder for the detail view
  final Widget Function(
    BuildContext context,
    String? selectedId,
    VoidCallback showMaster,
  )
  detailBuilder;

  /// Initial width of master view in desktop mode
  final double initialMasterWidth;

  /// Minimum width of master view when resizing
  final double minMasterWidth;

  /// Maximum width of master view when resizing
  final double maxMasterWidth;

  /// Breakpoint width for responsive layout
  final double breakpoint;

  /// Whether to show detail on init in mobile mode
  final bool showDetailOnInit;

  /// Color of divider between views
  final Color? dividerColor;

  /// Background colors
  final Color? masterBackgroundColor;
  final Color? detailBackgroundColor;

  /// Color of the resize bar
  final Color? resizeBarColor;

  /// Width of the resize bar
  final double resizeBarWidth;

  /// Padding for the master view
  final EdgeInsetsGeometry masterPadding;

  /// Padding for the detail view
  final EdgeInsetsGeometry detailPadding;

  /// Initial selected item ID
  final String? initialSelectedId;

  @override
  State<FondeMasterDetailLayout> createState() =>
      _FondeMasterDetailLayoutState();
}

class _FondeMasterDetailLayoutState extends State<FondeMasterDetailLayout> {
  late FondeMasterDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FondeMasterDetailController(
      initialSelectedId: widget.initialSelectedId,
      initialMasterWidth: widget.initialMasterWidth,
      initialDetailVisible: widget.showDetailOnInit,
    );
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final selectedId = _controller.selectedId;
    final masterWidth = _controller.masterWidth;
    final isDetailVisible = _controller.detailVisible;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > widget.breakpoint;

        // Build master view
        Widget buildMasterView(bool showingDetail) {
          return Padding(
            padding: widget.masterPadding,
            child: ListView.builder(
              shrinkWrap: false,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final itemId = widget.items[index];
                return widget.masterItemBuilder(
                  context,
                  itemId,
                  itemId == selectedId,
                  () {
                    _controller.setSelectedId(itemId);
                    if (!isDesktop) {
                      _controller.setVisible(true);
                    }
                  },
                );
              },
            ),
          );
        }

        // Desktop layout: side by side
        if (isDesktop) {
          return Row(
            children: [
              Container(
                width: masterWidth,
                color: widget.masterBackgroundColor,
                child: buildMasterView(true),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.resizeColumn,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    final newWidth = masterWidth + details.delta.dx;
                    if (newWidth >= widget.minMasterWidth &&
                        newWidth <= widget.maxMasterWidth) {
                      _controller.setWidth(newWidth);
                    }
                  },
                  child: Container(
                    width: widget.resizeBarWidth + 8.0,
                    height: double.infinity,
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    child: SizedBox(
                      width: widget.resizeBarWidth,
                      height: double.infinity,
                      child: FondeVerticalDivider(
                        thickness: widget.resizeBarWidth,
                        color: widget.resizeBarColor ?? widget.dividerColor,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: widget.detailBackgroundColor,
                  child: Padding(
                    padding: widget.detailPadding,
                    child: widget.detailBuilder(
                      context,
                      selectedId,
                      () => _controller.setVisible(false),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        // Mobile layout: stack with navigation
        return isDetailVisible
            ? Padding(
              padding: widget.detailPadding,
              child: widget.detailBuilder(
                context,
                selectedId,
                () => _controller.setVisible(false),
              ),
            )
            : buildMasterView(false);
      },
    );
  }
}
