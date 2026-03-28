import 'package:flutter/material.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class GestureDetectorPage extends StatelessWidget {
  const GestureDetectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Gesture Detector',
          description:
              'Gesture detector that detects single/double taps without delay',
          children: [
            const CatalogDemo(label: 'Events', child: _GestureLogDemo()),
          ],
        ),
      ],
    );
  }
}

class _GestureLogDemo extends StatefulWidget {
  const _GestureLogDemo();

  @override
  State<_GestureLogDemo> createState() => _GestureLogDemoState();
}

class _GestureLogDemoState extends State<_GestureLogDemo> {
  static const int _maxLines = 12;
  final List<String> _logs = [];
  DateTime? _lastEventTime;
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _log(String event) {
    final now = DateTime.now();
    String entry;
    if (_lastEventTime != null) {
      final ms = now.difference(_lastEventTime!).inMilliseconds;
      entry = '+${ms}ms  $event';
    } else {
      entry = '        $event';
    }
    _lastEventTime = now;

    setState(() {
      _logs.insert(0, entry);
      if (_logs.length > _maxLines) _logs.removeLast();
      _textController.text = _logs.join('\n');
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.fondeColorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FondeGestureDetector(
          onTapDown: (_) => _log('tap down'),
          onTapUp: (_) => _log('tap up'),
          onTap: () => _log('single tap'),
          onTapCancel: () => _log('tap cancel'),
          onDoubleTap: () => _log('double tap'),
          onHover: (hover) => _log(hover ? 'hover enter' : 'hover exit'),
          cursor: SystemMouseCursors.click,
          child: Container(
            width: 120,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.base.border),
              borderRadius: FondeBorderRadiusValues.mediumRadius,
            ),
            alignment: Alignment.center,
            child: const FondeText(
              'Click me',
              variant: FondeTextVariant.bodyText,
            ),
          ),
        ),
        FondeSpacing.sm(),
        SizedBox(
          width: 400,
          height: 200,
          child: TextField(
            controller: _textController,
            readOnly: true,
            maxLines: null,
            expands: true,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: colorScheme.base.foreground,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              filled: true,
              fillColor: colorScheme.base.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: colorScheme.base.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: colorScheme.base.divider),
              ),
              hintText: 'Events will appear here',
              hintStyle: TextStyle(
                fontSize: 12,
                color: colorScheme.base.foreground.withValues(alpha: 0.4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
