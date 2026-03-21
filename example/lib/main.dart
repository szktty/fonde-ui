import 'package:flutter/widgets.dart';
import 'package:fonde_ui/fonde_ui.dart';

import 'shell/catalog_shell.dart';

void main() {
  runApp(
    const FondeApp(
      title: 'Fonde UI Catalog',
      enableEyeDropper: true,
      home: FondeNotificationOverlay(
        alignment: Alignment.bottomRight,
        child: CatalogShell(),
      ),
    ),
  );
}
