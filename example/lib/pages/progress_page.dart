import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  double _progress = 0.0;
  bool _running = false;
  bool _cancelled = false;
  Timer? _timer;

  void _start() {
    setState(() {
      _progress = 0.0;
      _running = true;
      _cancelled = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 200), (t) {
      setState(() {
        _progress = (_progress + 0.02).clamp(0.0, 1.0);
        if (_progress >= 1.0) {
          _running = false;
          t.cancel();
        }
      });
    });
  }

  void _cancel() {
    _timer?.cancel();
    setState(() {
      _running = false;
      _cancelled = true;
    });
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _progress = 0.0;
      _running = false;
      _cancelled = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        // FondeLinearProgressIndicator
        CatalogSection(
          title: 'FondeLinearProgressIndicator',
          description: 'Linear progress indicator (zoom and color aware)',
          children: [
            CatalogDemo(
              label: 'Indeterminate',
              child: const SizedBox(
                width: 300,
                child: FondeLinearProgressIndicator(),
              ),
            ),
            CatalogDemo(
              label: 'Determinate 60%',
              child: const SizedBox(
                width: 300,
                child: FondeLinearProgressIndicator(value: 0.6),
              ),
            ),
            CatalogDemo(
              label: 'Cancelled state',
              child: const SizedBox(
                width: 300,
                child: FondeLinearProgressIndicator(
                  value: 0.45,
                  isCancelled: true,
                ),
              ),
            ),
            CatalogDemo(
              label: 'Thick bar (height: 8)',
              child: const SizedBox(
                width: 300,
                child: FondeLinearProgressIndicator(value: 0.75, height: 8.0),
              ),
            ),
            CatalogDemo(
              label: 'Animated demo',
              child: SizedBox(
                width: 320,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FondeLinearProgressIndicator(
                      value:
                          _cancelled
                              ? _progress
                              : (_running ? _progress : _progress),
                      isCancelled: _cancelled,
                      height: 6.0,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        FondeButton.primary(
                          label: 'Start',
                          onPressed: _running ? null : _start,
                        ),
                        const SizedBox(width: 8),
                        FondeButton.cancel(
                          label: 'Cancel',
                          onPressed: _running ? _cancel : null,
                        ),
                        const SizedBox(width: 8),
                        FondeButton.normal(
                          label: 'Reset',
                          onPressed:
                              (!_running && (_progress > 0 || _cancelled))
                                  ? _reset
                                  : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // FondeCircularProgressIndicator
        CatalogSection(
          title: 'FondeCircularProgressIndicator',
          description: 'Circular progress indicator (zoom and color aware)',
          children: [
            CatalogDemo(
              label: 'Indeterminate',
              child: const FondeCircularProgressIndicator(),
            ),
            CatalogDemo(
              label: 'Determinate 75%',
              child: const FondeCircularProgressIndicator(value: 0.75),
            ),
            CatalogDemo(
              label: 'Large size (size: 40)',
              child: const FondeCircularProgressIndicator(
                size: 40.0,
                strokeWidth: 4.0,
              ),
            ),
            CatalogDemo(
              label: 'Small size (size: 12)',
              child: const FondeCircularProgressIndicator(
                size: 12.0,
                strokeWidth: 1.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
