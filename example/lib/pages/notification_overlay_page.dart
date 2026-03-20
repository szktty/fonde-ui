import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class NotificationOverlayPage extends ConsumerWidget {
  const NotificationOverlayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Notification Overlay',
          description:
              'FondeNotificationOverlay stacks notifications managed via fondeNotificationProvider. '
              'Press buttons below to add notifications. They auto-dismiss after a few seconds.',
          children: [
            CatalogDemo(
              label: 'Trigger notifications',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FondeButton.normal(
                    label: 'Info',
                    onPressed: () {
                      ref
                          .read(fondeNotificationProvider.notifier)
                          .add(
                            FondeNotification(
                              title: 'Info',
                              message: 'This is an informational notification.',
                              type: FondeNotificationType.info,
                            ),
                          );
                    },
                  ),
                  FondeButton.normal(
                    label: 'Success',
                    onPressed: () {
                      ref
                          .read(fondeNotificationProvider.notifier)
                          .add(
                            FondeNotification(
                              title: 'Saved',
                              message: 'File saved successfully.',
                              type: FondeNotificationType.success,
                            ),
                          );
                    },
                  ),
                  FondeButton.normal(
                    label: 'Warning',
                    onPressed: () {
                      ref
                          .read(fondeNotificationProvider.notifier)
                          .add(
                            FondeNotification(
                              title: 'Warning',
                              message:
                                  'This action may have unintended side effects.',
                              type: FondeNotificationType.warning,
                            ),
                          );
                    },
                  ),
                  FondeButton.destructive(
                    label: 'Error',
                    onPressed: () {
                      ref
                          .read(fondeNotificationProvider.notifier)
                          .add(
                            FondeNotification(
                              title: 'Error',
                              message:
                                  'An error occurred while processing the request.',
                              type: FondeNotificationType.error,
                              duration: const Duration(seconds: 6),
                            ),
                          );
                    },
                  ),
                  FondeButton.normal(
                    label: 'Dismiss all',
                    onPressed: () {
                      ref.read(fondeNotificationProvider.notifier).dismissAll();
                    },
                  ),
                ],
              ),
            ),
            CatalogDemo(
              label: 'Active notifications',
              child: Consumer(
                builder: (context, ref, _) {
                  final notifications = ref.watch(fondeNotificationProvider);
                  if (notifications.isEmpty) {
                    return const FondeText(
                      'No active notifications.',
                      variant: FondeTextVariant.smallText,
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final n in notifications)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: FondeText(
                            '[${n.type.name}] ${n.title != null ? '${n.title}: ' : ''}${n.message}',
                            variant: FondeTextVariant.captionText,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
