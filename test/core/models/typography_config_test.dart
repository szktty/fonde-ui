// Tests for FondeTypographyConfig.
//
// All font fields are nullable — the config can be used as a partial override
// on top of preset defaults. Tests verify copyWith isolation and that
// explicitly set fonts are preserved correctly.

import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

void main() {
  group('FondeTypographyConfig', () {
    group('explicit values are preserved', () {
      test('uiFont set in constructor is readable', () {
        const font = FondeFontConfig(fontFamily: 'Roboto');
        final config = FondeTypographyConfig(uiFont: font);
        expect(config.uiFont, font);
      });

      test('textFont set in constructor is readable', () {
        const font = FondeFontConfig(fontFamily: 'Merriweather');
        final config = FondeTypographyConfig(textFont: font);
        expect(config.textFont, font);
      });

      test('codeBlockFont set in constructor is readable', () {
        const font = FondeFontConfig(fontFamily: 'RobotoMono');
        final config = FondeTypographyConfig(codeBlockFont: font);
        expect(config.codeBlockFont, font);
      });
    });

    group('copyWith', () {
      test('replacing uiFont does not affect textFont', () {
        const originalText = FondeFontConfig(fontFamily: 'Merriweather');
        final original = FondeTypographyConfig(textFont: originalText);
        const newUi = FondeFontConfig(fontFamily: 'Inter');
        final updated = original.copyWith(uiFont: newUi);
        expect(updated.uiFont?.fontFamily, 'Inter');
        expect(updated.textFont?.fontFamily, 'Merriweather');
      });

      test('replacing textFont does not affect uiFont', () {
        const originalUi = FondeFontConfig(fontFamily: 'Roboto');
        final original = FondeTypographyConfig(uiFont: originalUi);
        const newText = FondeFontConfig(fontFamily: 'Merriweather');
        final updated = original.copyWith(textFont: newText);
        expect(updated.textFont?.fontFamily, 'Merriweather');
        expect(updated.uiFont?.fontFamily, 'Roboto');
      });

      test('replacing codeBlockFont does not affect uiFont or textFont', () {
        const originalUi = FondeFontConfig(fontFamily: 'Roboto');
        const originalText = FondeFontConfig(fontFamily: 'Merriweather');
        final original = FondeTypographyConfig(
          uiFont: originalUi,
          textFont: originalText,
        );
        const newCode = FondeFontConfig(fontFamily: 'FiraCode');
        final updated = original.copyWith(codeBlockFont: newCode);
        expect(updated.codeBlockFont?.fontFamily, 'FiraCode');
        expect(updated.uiFont?.fontFamily, 'Roboto');
        expect(updated.textFont?.fontFamily, 'Merriweather');
      });

      test('original is not mutated', () {
        final original = FondeTypographyConfig(
          uiFont: const FondeFontConfig(fontFamily: 'Roboto'),
        );
        original.copyWith(uiFont: const FondeFontConfig(fontFamily: 'Inter'));
        expect(original.uiFont?.fontFamily, 'Roboto');
      });
    });

    group('equality', () {
      test('two configs with same fonts are equal', () {
        const font = FondeFontConfig(fontFamily: 'Roboto');
        final a = FondeTypographyConfig(uiFont: font);
        final b = FondeTypographyConfig(uiFont: font);
        expect(a, b);
      });

      test('configs with different uiFont are not equal', () {
        final a = FondeTypographyConfig(
          uiFont: const FondeFontConfig(fontFamily: 'Roboto'),
        );
        final b = FondeTypographyConfig(
          uiFont: const FondeFontConfig(fontFamily: 'Inter'),
        );
        expect(a, isNot(b));
      });
    });
  });
}
