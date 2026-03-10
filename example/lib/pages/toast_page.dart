import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import '../widgets/catalog_page.dart';

class ToastPage extends StatefulWidget {
  const ToastPage({super.key});

  @override
  State<ToastPage> createState() => _ToastPageState();
}

class _ToastPageState extends State<ToastPage> {
  final _toastInfoKey = GlobalKey();
  final _toastSuccessKey = GlobalKey();
  final _toastWarningKey = GlobalKey();
  final _toastErrorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      children: [
        CatalogSection(
          title: 'Snack Bar',
          description: 'Snack bar displayed at the bottom of the screen',
          children: [
            CatalogDemo(
              label: 'info',
              child: FondeButton.normal(
                label: 'Show Info',
                onPressed:
                    () => FondeSnackBar.showInfo(
                      context: context,
                      message: 'Operation completed.',
                    ),
              ),
            ),
            CatalogDemo(
              label: 'success',
              child: FondeButton.normal(
                label: 'Show Success',
                onPressed:
                    () => FondeSnackBar.showSuccess(
                      context: context,
                      message: 'Saved successfully.',
                    ),
              ),
            ),
            CatalogDemo(
              label: 'warning',
              child: FondeButton.normal(
                label: 'Show Warning',
                onPressed:
                    () => FondeSnackBar.showWarning(
                      context: context,
                      message: 'Disk space is running low.',
                    ),
              ),
            ),
            CatalogDemo(
              label: 'error',
              child: FondeButton.normal(
                label: 'Show Error',
                onPressed:
                    () => FondeSnackBar.showError(
                      context: context,
                      message: 'Failed to save.',
                    ),
              ),
            ),
            CatalogDemo(
              label: 'With action',
              child: FondeButton.normal(
                label: 'Show with action',
                onPressed:
                    () => FondeSnackBar.show(
                      context: context,
                      message: 'Changes saved.',
                      actionLabel: 'Undo',
                      onActionPressed: () {},
                    ),
              ),
            ),
          ],
        ),
        CatalogSection(
          title: 'Toast',
          description: 'Toast displayed near the button',
          children: [
            CatalogDemo(
              label: 'info',
              child: FondeButton.normal(
                key: _toastInfoKey,
                label: 'Info Toast',
                onPressed:
                    () => FondeToast.show(
                      context: context,
                      targetKey: _toastInfoKey,
                      message: 'This is an info message.',
                      type: FondeToastType.info,
                    ),
              ),
            ),
            CatalogDemo(
              label: 'success',
              child: FondeButton.normal(
                key: _toastSuccessKey,
                label: 'Success Toast',
                onPressed:
                    () => FondeToast.show(
                      context: context,
                      targetKey: _toastSuccessKey,
                      message: 'Operation succeeded.',
                      type: FondeToastType.success,
                    ),
              ),
            ),
            CatalogDemo(
              label: 'warning',
              child: FondeButton.normal(
                key: _toastWarningKey,
                label: 'Warning Toast',
                onPressed:
                    () => FondeToast.show(
                      context: context,
                      targetKey: _toastWarningKey,
                      message: 'Attention required.',
                      type: FondeToastType.warning,
                    ),
              ),
            ),
            CatalogDemo(
              label: 'error',
              child: FondeButton.normal(
                key: _toastErrorKey,
                label: 'Error Toast',
                onPressed:
                    () => FondeToast.show(
                      context: context,
                      targetKey: _toastErrorKey,
                      message: 'An error occurred.',
                      type: FondeToastType.error,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
