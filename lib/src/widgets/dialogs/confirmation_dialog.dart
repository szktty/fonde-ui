import 'package:flutter/material.dart';
import '../spacing/fonde_spacing.dart';
import '../widgets/fonde_button.dart';
import '../widgets/fonde_dialog.dart';
import '../typography/fonde_text.dart';

/// Confirmation dialog
///
/// Used when confirmation/cancel action is required from the user.
class FondeConfirmationDialog extends StatelessWidget {
  /// Constructor
  const FondeConfirmationDialog({
    super.key,
    required this.message,
    required this.warningItems,
    this.onConfirm,
    this.onCancel,
    this.confirmLabel = 'Execute',
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
  });

  /// Warning message
  final String message;

  /// List of warning items
  final List<String> warningItems;

  /// Callback when confirm button is pressed
  final VoidCallback? onConfirm;

  /// Callback when cancel button is pressed
  final VoidCallback? onCancel;

  /// Label for confirm button
  final String confirmLabel;

  /// Label for cancel button
  final String cancelLabel;

  /// Whether this is a destructive operation
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return FondeDialog(
      minWidth: 400,
      maxWidth: 600,
      showDivider: false,
      footer: Padding(
        padding: const EdgeInsets.all(FondeSpacingValues.xl),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FondeButton.cancel(
              label: cancelLabel,
              onPressed: () {
                Navigator.of(context).pop(false);
                onCancel?.call();
              },
            ),
            const SizedBox(width: 12),
            isDestructive
                ? FondeButton.destructive(
                  label: confirmLabel,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    onConfirm?.call();
                  },
                )
                : FondeButton.primary(
                  label: confirmLabel,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    onConfirm?.call();
                  },
                ),
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon area (left side)
          Column(
            children: [
              const SizedBox(height: 4), // Adjust icon to align with title
              Icon(Icons.warning_amber_rounded, size: 24, color: Colors.orange),
            ],
          ),

          const SizedBox(width: 16),

          // Content area (right side)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Message
                FondeText(message, variant: FondeTextVariant.bodyText),

                const SizedBox(height: 12),

                // Warning items list
                ...warningItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: FondeText(item, variant: FondeTextVariant.bodyText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper function to show confirmation dialog
Future<bool?> showFondeConfirmationDialog(
  BuildContext context, {
  required String message,
  required List<String> warningItems,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  String confirmLabel = 'Execute',
  String cancelLabel = 'Cancel',
  bool isDestructive = false,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => FondeConfirmationDialog(
          message: message,
          warningItems: warningItems,
          onConfirm: onConfirm,
          onCancel: onCancel,
          confirmLabel: confirmLabel,
          cancelLabel: cancelLabel,
          isDestructive: isDestructive,
        ),
  );
}
