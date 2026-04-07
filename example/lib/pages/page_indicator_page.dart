import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class PageIndicatorPage extends StatefulWidget {
  const PageIndicatorPage({super.key});

  @override
  State<PageIndicatorPage> createState() => _PageIndicatorPageState();
}

class _PageIndicatorPageState extends State<PageIndicatorPage> {
  double _position = 0;
  final int _pageCount = 5;

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'FondePageIndicator',
          description: 'Page indicator dots for pagination UI.',
          children: [
            CatalogDemo(
              label: 'Horizontal (default)',
              child: FondePageIndicator(
                dotsCount: _pageCount,
                position: _position,
              ),
            ),
            CatalogDemo(
              label: 'Vertical',
              child: FondePageIndicator(
                dotsCount: _pageCount,
                position: _position,
                axis: Axis.vertical,
              ),
            ),
            CatalogDemo(
              label: 'Tappable (tap a dot to select)',
              child: FondePageIndicator(
                dotsCount: _pageCount,
                position: _position,
                onDotTapped:
                    (index) => setState(() => _position = index.toDouble()),
              ),
            ),
            CatalogDemo(
              label: 'Large dots (dotSize: 10)',
              child: FondePageIndicator(
                dotsCount: _pageCount,
                position: _position,
                dotSize: 10.0,
              ),
            ),
            CatalogDemo(
              label: 'Tight spacing (dotSpacing: 6)',
              child: FondePageIndicator(
                dotsCount: _pageCount,
                position: _position,
                dotSpacing: 6.0,
              ),
            ),
            CatalogDemo(
              label: 'Navigation buttons',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FondeButton.normal(
                    label: '‹ Prev',
                    onPressed:
                        _position > 0
                            ? () => setState(() => _position -= 1)
                            : null,
                  ),
                  const SizedBox(width: 12),
                  FondePageIndicator(
                    dotsCount: _pageCount,
                    position: _position,
                    onDotTapped:
                        (index) => setState(() => _position = index.toDouble()),
                  ),
                  const SizedBox(width: 12),
                  FondeButton.normal(
                    label: 'Next ›',
                    onPressed:
                        _position < _pageCount - 1
                            ? () => setState(() => _position += 1)
                            : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
