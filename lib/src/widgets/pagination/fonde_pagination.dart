import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal.dart';

import '../page_indicator/fonde_page_indicator.dart';
import '../widgets/fonde_button.dart';

/// A simple pagination component with only page dots.
///
/// Intended to be used alongside [FondeExternalPagination].
/// This component consists only of dot indicators.
class FondePagination extends ConsumerWidget {
  const FondePagination({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.onPageChanged,
    this.dotSize = 8.0,
    this.dotSpacing = 4.0,
  });

  /// Total number of pages.
  final int totalPages;

  /// Current page number (0-based).
  final int currentPage;

  /// Callback when the page changes.
  final ValueChanged<int> onPageChanged;

  /// Size of the dots.
  final double dotSize;

  /// Spacing between dots.
  final double dotSpacing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }

    return FondePageIndicator(
      dotsCount: totalPages,
      position: currentPage.toDouble(),
      onDotTapped: onPageChanged,
      dotSize: dotSize,
      dotSpacing: dotSpacing,
    );
  }
}

/// Pagination arrows for external navigation.
///
/// A single arrow button placed at the edge of the screen.
/// The entire area is tappable, improving accessibility and usability.
class FondeExternalPagination extends ConsumerWidget {
  const FondeExternalPagination({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.onPageChanged,
    required this.direction,
    this.width = 64.0,
    this.height,
    this.iconSize = 40.0,
    this.tooltip,
    this.showIcon = true,
  });

  /// Total number of pages.
  final int totalPages;

  /// Current page number (0-based).
  final int currentPage;

  /// Callback when the page changes.
  final ValueChanged<int> onPageChanged;

  /// Direction of the arrow.
  final FondePaginationDirection direction;

  /// Width of the container.
  final double width;

  /// Height of the container (follows parent height if null).
  final double? height;

  /// Size of the icon.
  final double iconSize;

  /// Tooltip text.
  final String? tooltip;

  /// Whether to show the icon.
  final bool showIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (totalPages <= 1) {
      return SizedBox(width: width, height: height);
    }

    // Get theme color using core_themes API
    final appColorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(fondeAccessibilityConfigProvider);

    final bool canNavigate;
    final int targetPage;
    final IconData icon;
    final String defaultTooltip;

    switch (direction) {
      case FondePaginationDirection.previous:
        canNavigate = currentPage > 0;
        targetPage = currentPage - 1;
        icon = Icons.chevron_left;
        defaultTooltip = 'Previous page';
        break;
      case FondePaginationDirection.next:
        canNavigate = currentPage < totalPages - 1;
        targetPage = currentPage + 1;
        icon = Icons.chevron_right;
        defaultTooltip = 'Next page';
        break;
    }

    // Scaling based on accessibility settings
    final zoomScale = accessibilityConfig.zoomScale;
    final effectiveIconSize = iconSize * zoomScale;

    return SizedBox(
      width: width,
      height: height,
      child: Tooltip(
        message: tooltip ?? defaultTooltip,
        child: FondeButton(
          label: '', // Label is empty as it's only an icon
          onPressed: canNavigate ? () => onPageChanged(targetPage) : null,
          leadingIcon: showIcon && canNavigate
              ? Icon(
                  icon,
                  size: effectiveIconSize,
                  color: appColorScheme.base.foreground,
                )
              : null,
          width: width,
          height: height,
          enabled: canNavigate,
          backgroundColor: Colors.transparent,
          borderColor: Colors.transparent,
          expandHeight: true, // Adjust height according to parent constraints
        ),
      ),
    );
  }
}

/// Pagination using a page controller (dots only).
///
/// A dot indicator integrated with a [PageController].
/// Use when combined with external navigation.
class FondePageControllerPagination extends ConsumerWidget {
  const FondePageControllerPagination({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.pageController,
    this.dotSize = 8.0,
    this.dotSpacing = 4.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  /// Total number of pages.
  final int totalPages;

  /// Current page number (0-based).
  final int currentPage;

  /// Page controller.
  final PageController pageController;

  /// Size of the dots.
  final double dotSize;

  /// Spacing between dots.
  final double dotSpacing;

  /// Animation duration.
  final Duration animationDuration;

  /// Animation curve.
  final Curve animationCurve;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FondePagination(
      totalPages: totalPages,
      currentPage: currentPage,
      onPageChanged: _navigateToPage,
      dotSize: dotSize,
      dotSpacing: dotSpacing,
    );
  }

  void _navigateToPage(int page) {
    if (pageController.hasClients) {
      pageController.animateToPage(
        page,
        duration: animationDuration,
        curve: animationCurve,
      );
    }
  }
}

/// PageController integrated version for external navigation.
class FondeExternalPageControllerPagination extends ConsumerWidget {
  const FondeExternalPageControllerPagination({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.pageController,
    required this.direction,
    this.width = 64.0,
    this.height,
    this.iconSize = 40.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.tooltip,
    this.showIcon = true,
  });

  /// Total number of pages.
  final int totalPages;

  /// Current page number (0-based).
  final int currentPage;

  /// Page controller.
  final PageController pageController;

  /// Direction of the arrow.
  final FondePaginationDirection direction;

  /// Width of the container.
  final double width;

  /// Height of the container (follows parent height if null).
  final double? height;

  /// Size of the icon.
  final double iconSize;

  /// Animation duration.
  final Duration animationDuration;

  /// Animation curve.
  final Curve animationCurve;

  /// Tooltip text.
  final String? tooltip;

  /// Whether to show the icon.
  final bool showIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FondeExternalPagination(
      totalPages: totalPages,
      currentPage: currentPage,
      onPageChanged: _navigateToPage,
      direction: direction,
      width: width,
      height: height,
      iconSize: iconSize,
      tooltip: tooltip,
      showIcon: showIcon,
    );
  }

  void _navigateToPage(int page) {
    if (pageController.hasClients) {
      pageController.animateToPage(
        page,
        duration: animationDuration,
        curve: animationCurve,
      );
    }
  }
}

/// Enum representing pagination direction.
enum FondePaginationDirection {
  /// Previous page.
  previous,

  /// Next page.
  next,
}
