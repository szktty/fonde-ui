// Minimal FondeApp wrapper for widget tests.
//
// Use [buildTestApp] to wrap any widget under test. It provides FondeApp
// with the default fonde_ui light theme so tests do not need to repeat
// this boilerplate.

import 'package:flutter/material.dart';
import 'package:fonde_ui/fonde_ui.dart';

/// Builds a minimal test harness for widget tests.
///
/// Wraps [child] in [FondeApp] with the default fonde_ui light theme applied.
Widget buildTestApp({required Widget child, FondeThemeData? theme}) {
  return FondeApp(
    title: 'Test',
    initialTheme: theme ?? FondeThemePresets.light,
    home: Scaffold(body: child),
  );
}
