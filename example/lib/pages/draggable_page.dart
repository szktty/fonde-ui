import 'package:flutter/material.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class DraggablePage extends StatefulWidget {
  const DraggablePage({super.key});

  @override
  State<DraggablePage> createState() => _DraggablePageState();
}

class _DraggablePageState extends State<DraggablePage> {
  final List<String> _listA = ['Apple', 'Banana', 'Cherry'];
  final List<String> _listB = <String>[];
  String? _lastDropped;

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Draggable & Drag Target',
          description:
              'FondeDraggable uses left-click drag with grab cursor and ghost feedback. '
              'Drag items from List A to List B.',
          children: [
            CatalogDemo(
              label: 'Drag items between lists',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // List A — drag source
                  Expanded(
                    child: _DroppableList(
                      label: 'List A',
                      items: _listA,
                      onDrop: (item) {
                        if (!_listA.contains(item)) {
                          setState(() {
                            _listB.remove(item);
                            _listA.add(item);
                            _lastDropped = '$item → List A';
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // List B — drop target
                  Expanded(
                    child: _DroppableList(
                      label: 'List B',
                      items: _listB,
                      onDrop: (item) {
                        if (!_listB.contains(item)) {
                          setState(() {
                            _listA.remove(item);
                            _listB.add(item);
                            _lastDropped = '$item → List B';
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_lastDropped != null)
              CatalogDemo(
                label: 'Last action',
                child: FondeText(
                  _lastDropped!,
                  variant: FondeTextVariant.captionText,
                ),
              ),
            CatalogDemo(
              label: 'Badge feedback style',
              description:
                  'feedbackStyle: FondeDragFeedbackStyle.badge shows a small dot during drag.',
              child: FondeDraggable<String>(
                data: 'badge-demo',
                feedbackStyle: FondeDragFeedbackStyle.badge,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const FondeText(
                    'Drag me (badge style)',
                    variant: FondeTextVariant.captionText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DroppableList extends StatelessWidget {
  const _DroppableList({
    required this.label,
    required this.items,
    required this.onDrop,
  });

  final String label;
  final List<String> items;
  final void Function(String item) onDrop;

  @override
  Widget build(BuildContext context) {
    return FondeDragTarget<String>(
      onAcceptWithDetails: (d) => onDrop(d.data),
      builder: (context, candidateData, rejectedData, isOver) {
        return AnimatedContainer(
          duration: Duration.zero,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: isOver ? Colors.blue : Colors.grey.shade400,
              width: isOver ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: isOver ? Colors.blue.withValues(alpha: 0.06) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FondeText(label, variant: FondeTextVariant.sectionTitleSecondary),
              const SizedBox(height: 8),
              if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: FondeText(
                    'Drop here',
                    variant: FondeTextVariant.smallText,
                    color: Colors.grey,
                  ),
                )
              else
                for (final item in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: FondeDraggable<String>(
                      data: item,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FondeText(
                          item,
                          variant: FondeTextVariant.captionText,
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}
