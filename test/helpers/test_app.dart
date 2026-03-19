// Minimal FondeApp wrapper for widget tests.
//
// Use [buildTestApp] to wrap any widget under test. It provides ProviderScope,
// MaterialApp, and the default fonde_ui theme so tests do not need to repeat
// this boilerplate.
//
// Pass [overrides] to substitute Riverpod providers for a given test case.
// The list is passed directly to [ProviderScope.overrides].

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show Override;

export 'package:riverpod_annotation/riverpod_annotation.dart' show Override;

/// Builds a minimal test harness for widget tests.
///
/// Wraps [child] in [ProviderScope] + [MaterialApp] with the default fonde_ui
/// light theme applied. Pass [overrides] to override specific providers.
Widget buildTestApp({
  required Widget child,
  List<Override> overrides = const [],
  FondeThemeData? theme,
}) {
  final effectiveTheme = theme ?? FondeThemePresets.light;
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: effectiveTheme.toThemeData(),
      home: Scaffold(body: child),
    ),
  );
}
