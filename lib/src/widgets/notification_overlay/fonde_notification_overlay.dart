import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal.dart';
import '../typography/fonde_text.dart';
import '../styling/fonde_border_radius.dart';

/// Defines the type/severity of a notification.
enum FondeNotificationType { info, success, warning, error }

/// A single notification entry managed by [FondeNotificationOverlay].
class FondeNotification {
  FondeNotification({
    required this.message,
    this.title,
    this.type = FondeNotificationType.info,
    this.duration = const Duration(seconds: 4),
    this.onDismiss,
    String? id,
  }) : id = id ?? UniqueKey().toString();

  /// Unique identifier for this notification.
  final String id;

  /// Primary message text.
  final String message;

  /// Optional bold title above the message.
  final String? title;

  final FondeNotificationType type;

  /// How long the notification is displayed before auto-dismissal.
  /// Set to [Duration.zero] to keep it until manually dismissed.
  final Duration duration;

  /// Called when the notification is dismissed (by timeout or user action).
  final VoidCallback? onDismiss;
}

/// State notifier that manages the notification queue.
class FondeNotificationNotifier extends Notifier<List<FondeNotification>> {
  @override
  List<FondeNotification> build() => [];

  /// Adds a notification to the stack.
  void add(FondeNotification notification) {
    state = [...state, notification];
    if (notification.duration > Duration.zero) {
      Timer(notification.duration, () => dismiss(notification.id));
    }
  }

  /// Removes a notification by id.
  void dismiss(String id) {
    final notification = state.where((n) => n.id == id).firstOrNull;
    state = state.where((n) => n.id != id).toList();
    notification?.onDismiss?.call();
  }

  /// Removes all notifications.
  void dismissAll() {
    for (final n in state) {
      n.onDismiss?.call();
    }
    state = [];
  }
}

/// Provider for the notification stack.
final fondeNotificationProvider =
    NotifierProvider<FondeNotificationNotifier, List<FondeNotification>>(
      FondeNotificationNotifier.new,
    );

/// Wraps a widget tree with a notification overlay anchored to a screen edge.
///
/// Notifications are managed via [fondeNotificationProvider].
///
/// Example:
/// ```dart
/// FondeNotificationOverlay(
///   alignment: Alignment.bottomRight,
///   child: MyApp(),
/// )
///
/// // To show a notification from anywhere:
/// ref.read(fondeNotificationProvider.notifier).add(
///   FondeNotification(message: 'File saved', type: FondeNotificationType.success),
/// );
/// ```
class FondeNotificationOverlay extends ConsumerWidget {
  const FondeNotificationOverlay({
    super.key,
    required this.child,
    this.alignment = Alignment.bottomRight,
    this.margin = const EdgeInsets.all(16.0),
    this.maxVisible = 5,
    this.spacing = 8.0,
    this.notificationWidth = 320.0,
    this.disableZoom = false,
  });

  final Widget child;

  /// Where to anchor the notification stack.
  final Alignment alignment;

  /// Outer margin from the screen edge.
  final EdgeInsets margin;

  /// Maximum number of notifications displayed simultaneously.
  final int maxVisible;

  /// Vertical spacing between notifications.
  final double spacing;

  /// Width of each notification card.
  final double notificationWidth;

  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(fondeNotificationProvider);
    final visible = notifications.take(maxVisible).toList();

    return Stack(
      children: [
        child,
        if (visible.isNotEmpty)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: false,
              child: Align(
                alignment: alignment,
                child: Padding(
                  padding: margin,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: _crossAxisAlignment,
                    children:
                        visible.map((n) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: spacing),
                            child: _FondeNotificationCard(
                              notification: n,
                              width: notificationWidth,
                              disableZoom: disableZoom,
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  CrossAxisAlignment get _crossAxisAlignment {
    if (alignment.x < 0) return CrossAxisAlignment.start;
    if (alignment.x > 0) return CrossAxisAlignment.end;
    return CrossAxisAlignment.center;
  }
}

/// A single notification card widget.
class _FondeNotificationCard extends ConsumerWidget {
  const _FondeNotificationCard({
    required this.notification,
    required this.width,
    required this.disableZoom,
  });

  final FondeNotification notification;
  final double width;
  final bool disableZoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(fondeEffectiveColorSchemeProvider);
    final accessibilityConfig = ref.watch(fondeAccessibilityConfigProvider);
    final zoomScale = disableZoom ? 1.0 : accessibilityConfig.zoomScale;

    final background = colorScheme.uiAreas.dialog.background;
    final foreground = colorScheme.uiAreas.dialog.foreground;
    final border = colorScheme.base.border;

    final accentColor = _accentColor(colorScheme);

    return SizedBox(
      width: width * zoomScale,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(
              FondeBorderRadiusValues.medium * zoomScale,
            ),
            border: Border.all(color: border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Accent bar on the left
              Container(
                width: 4.0,
                height: double.infinity,
                constraints: const BoxConstraints(minHeight: 48.0),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      FondeBorderRadiusValues.medium * zoomScale,
                    ),
                    bottomLeft: Radius.circular(
                      FondeBorderRadiusValues.medium * zoomScale,
                    ),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.0 * zoomScale,
                    vertical: 10.0 * zoomScale,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (notification.title != null) ...[
                        FondeText(
                          notification.title!,
                          variant: FondeTextVariant.captionText,
                          color: foreground,
                          fontWeight: FontWeight.w600,
                          disableZoom: disableZoom,
                        ),
                        SizedBox(height: 2.0 * zoomScale),
                      ],
                      FondeText(
                        notification.message,
                        variant: FondeTextVariant.smallText,
                        color: foreground.withValues(alpha: 0.85),
                        disableZoom: disableZoom,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              // Dismiss button
              Padding(
                padding: EdgeInsets.all(4.0 * zoomScale),
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 14.0 * zoomScale,
                    color: foreground.withValues(alpha: 0.5),
                  ),
                  onPressed: () {
                    ref
                        .read(fondeNotificationProvider.notifier)
                        .dismiss(notification.id);
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: 24.0 * zoomScale,
                    minHeight: 24.0 * zoomScale,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _accentColor(dynamic colorScheme) {
    switch (notification.type) {
      case FondeNotificationType.success:
        return colorScheme.status.success;
      case FondeNotificationType.warning:
        return colorScheme.status.warning;
      case FondeNotificationType.error:
        return colorScheme.status.error;
      case FondeNotificationType.info:
        return colorScheme.status.info;
    }
  }
}
