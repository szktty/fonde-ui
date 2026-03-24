// Convenience extensions on WidgetTester for fonde_ui tests.
//
// [pumpTestApp] builds a widget inside the standard test harness and pumps
// one frame, which is sufficient for most fonde_ui widgets because they use
// Duration.zero animations. Call pumpAndSettle() explicitly for widgets that
// run longer animations (e.g. dialogs).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

import 'test_app.dart';

extension PumpHelpers on WidgetTester {
  /// Builds [child] inside [buildTestApp] and pumps one frame.
  Future<void> pumpTestApp(Widget child, {FondeThemeData? theme}) async {
    await pumpWidget(buildTestApp(child: child, theme: theme));
    await pump();
  }
}
