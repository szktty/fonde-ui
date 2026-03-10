import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../internal.dart';
import 'lucide_icon_theme.dart';

/// The effective icon theme to use in components.
///
/// Returns the theme set via [fondeActiveIconThemeProvider] if one has been set,
/// otherwise falls back to [fondeDefaultIconTheme].
///
/// Components should watch this provider instead of writing
/// `ref.watch(fondeActiveIconThemeProvider) ?? lucideIconTheme` directly.
final fondeDefaultIconThemeProvider = Provider<FondeIconTheme>((ref) {
  return ref.watch(fondeActiveIconThemeProvider) ?? fondeDefaultIconTheme;
});
