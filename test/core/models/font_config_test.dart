// Tests for FondeFontConfig.
//
// Verifies default field values and that copyWith updates only the specified
// field without affecting the others.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

void main() {
  group('FondeFontConfig', () {
    group('default values', () {
      test('default size is 14.0', () {
        const config = FondeFontConfig(fontFamily: 'Roboto');
        expect(config.size, 14.0);
      });

      test('default weight is FontWeight.w400', () {
        const config = FondeFontConfig(fontFamily: 'Roboto');
        expect(config.weight, FontWeight.w400);
      });

      test('fontFamily is preserved', () {
        const config = FondeFontConfig(fontFamily: 'Roboto');
        expect(config.fontFamily, 'Roboto');
      });
    });

    group('copyWith', () {
      test('updating size does not affect fontFamily', () {
        const config = FondeFontConfig(fontFamily: 'Roboto');
        final updated = config.copyWith(size: 18.0);
        expect(updated.size, 18.0);
        expect(updated.fontFamily, 'Roboto');
      });

      test('updating weight does not affect size', () {
        const config = FondeFontConfig(fontFamily: 'Roboto', size: 16.0);
        final updated = config.copyWith(weight: FontWeight.w700);
        expect(updated.weight, FontWeight.w700);
        expect(updated.size, 16.0);
      });

      test('updating fontFamily does not affect weight', () {
        const config = FondeFontConfig(
          fontFamily: 'Roboto',
          weight: FontWeight.w500,
        );
        final updated = config.copyWith(fontFamily: 'Inter');
        expect(updated.fontFamily, 'Inter');
        expect(updated.weight, FontWeight.w500);
      });

      test('original is not mutated', () {
        const config = FondeFontConfig(fontFamily: 'Roboto', size: 14.0);
        config.copyWith(size: 20.0);
        expect(config.size, 14.0);
      });
    });

    group('equality', () {
      test('two configs with same values are equal', () {
        const a = FondeFontConfig(fontFamily: 'Roboto', size: 14.0);
        const b = FondeFontConfig(fontFamily: 'Roboto', size: 14.0);
        expect(a, b);
      });

      test('configs with different fontFamily are not equal', () {
        const a = FondeFontConfig(fontFamily: 'Roboto');
        const b = FondeFontConfig(fontFamily: 'Inter');
        expect(a, isNot(b));
      });
    });
  });
}
