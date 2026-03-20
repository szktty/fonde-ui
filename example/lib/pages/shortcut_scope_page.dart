import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class ShortcutScopePage extends StatefulWidget {
  const ShortcutScopePage({super.key});

  @override
  State<ShortcutScopePage> createState() => _ShortcutScopePageState();
}

class _ShortcutScopePageState extends State<ShortcutScopePage> {
  final List<String> _log = [];

  void _addLog(String message) {
    setState(() {
      _log.insert(0, message);
      if (_log.length > 6) _log.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Shortcut Scope',
          description:
              'FondeShortcutScope binds keyboard shortcuts to a widget subtree. '
              'Shortcuts only fire when focus is inside the scope.',
          children: [
            CatalogDemo(
              label: 'Basic scope (click inside to focus, then press keys)',
              child: FondeShortcutScope(
                autofocus: false,
                bindings: [
                  FondeShortcutBinding(
                    activator: const SingleActivator(
                      LogicalKeyboardKey.keyN,
                      meta: true,
                    ),
                    label: 'New Item (⌘N)',
                    onInvoke: () => _addLog('⌘N — New Item'),
                  ),
                  FondeShortcutBinding(
                    activator: const SingleActivator(
                      LogicalKeyboardKey.keyS,
                      meta: true,
                    ),
                    label: 'Save (⌘S)',
                    onInvoke: () => _addLog('⌘S — Save'),
                  ),
                  FondeShortcutBinding(
                    activator: const SingleActivator(LogicalKeyboardKey.delete),
                    label: 'Delete',
                    onInvoke: () => _addLog('Delete — Remove'),
                  ),
                ],
                child: Focus(
                  child: Builder(
                    builder: (ctx) {
                      final hasFocus = Focus.of(ctx).hasFocus;
                      return GestureDetector(
                        onTap: () => Focus.of(ctx).requestFocus(),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  hasFocus ? Colors.blue : Colors.grey.shade400,
                              width: hasFocus ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FondeText(
                                hasFocus
                                    ? 'Focused — try ⌘N, ⌘S, Delete'
                                    : 'Click to focus',
                                variant: FondeTextVariant.captionText,
                              ),
                              const SizedBox(height: 8),
                              const FondeText(
                                'Registered shortcuts:',
                                variant: FondeTextVariant.smallText,
                              ),
                              const FondeText(
                                '  ⌘N — New Item',
                                variant: FondeTextVariant.smallText,
                              ),
                              const FondeText(
                                '  ⌘S — Save',
                                variant: FondeTextVariant.smallText,
                              ),
                              const FondeText(
                                '  Delete — Remove',
                                variant: FondeTextVariant.smallText,
                              ),
                              if (_log.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                const FondeText(
                                  'Event log:',
                                  variant: FondeTextVariant.smallText,
                                ),
                                for (final entry in _log)
                                  FondeText(
                                    '  → $entry',
                                    variant: FondeTextVariant.smallText,
                                  ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
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
