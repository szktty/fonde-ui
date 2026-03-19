// Tests for FondeAccessibilityConfig.
//
// Verifies default values, copyWith behaviour, JSON round-trip, and that
// extreme scale values do not throw.

import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui.dart';

void main() {
  group('FondeAccessibilityConfig', () {
    group('default values', () {
      test('fontScale is 1.0', () {
        const config = FondeAccessibilityConfig();
        expect(config.fontScale, 1.0);
      });

      test('zoomScale is 1.0', () {
        const config = FondeAccessibilityConfig();
        expect(config.zoomScale, 1.0);
      });

      test('borderScale is 1.0', () {
        const config = FondeAccessibilityConfig();
        expect(config.borderScale, 1.0);
      });

      test('highContrastMode is false', () {
        const config = FondeAccessibilityConfig();
        expect(config.highContrastMode, false);
      });
    });

    group('copyWith', () {
      test('updates only fontScale', () {
        const config = FondeAccessibilityConfig();
        final updated = config.copyWith(fontScale: 1.5);
        expect(updated.fontScale, 1.5);
        expect(updated.zoomScale, 1.0);
        expect(updated.borderScale, 1.0);
        expect(updated.highContrastMode, false);
      });

      test('updates only zoomScale', () {
        const config = FondeAccessibilityConfig();
        final updated = config.copyWith(zoomScale: 2.0);
        expect(updated.zoomScale, 2.0);
        expect(updated.fontScale, 1.0);
      });

      test('updates only borderScale', () {
        const config = FondeAccessibilityConfig();
        final updated = config.copyWith(borderScale: 0.5);
        expect(updated.borderScale, 0.5);
        expect(updated.zoomScale, 1.0);
      });

      test('updates only highContrastMode', () {
        const config = FondeAccessibilityConfig();
        final updated = config.copyWith(highContrastMode: true);
        expect(updated.highContrastMode, true);
        expect(updated.zoomScale, 1.0);
      });

      test('original is not mutated', () {
        const config = FondeAccessibilityConfig();
        config.copyWith(zoomScale: 3.0);
        expect(config.zoomScale, 1.0);
      });
    });

    group('JSON round-trip', () {
      test('default config survives fromJson(toJson())', () {
        const config = FondeAccessibilityConfig();
        final restored = FondeAccessibilityConfig.fromJson(config.toJson());
        expect(restored, config);
      });

      test('non-default values survive fromJson(toJson())', () {
        const config = FondeAccessibilityConfig(
          fontScale: 1.2,
          zoomScale: 1.5,
          borderScale: 2.0,
          highContrastMode: true,
        );
        final restored = FondeAccessibilityConfig.fromJson(config.toJson());
        expect(restored, config);
      });
    });

    group('boundary values', () {
      test('scale of 0.0 does not throw', () {
        expect(
          () => FondeAccessibilityConfig(
            fontScale: 0.0,
            zoomScale: 0.0,
            borderScale: 0.0,
          ),
          returnsNormally,
        );
      });

      test('negative scale does not throw', () {
        expect(
          () => FondeAccessibilityConfig(
            fontScale: -1.0,
            zoomScale: -1.0,
            borderScale: -1.0,
          ),
          returnsNormally,
        );
      });

      test('very large scale does not throw', () {
        expect(
          () => FondeAccessibilityConfig(
            fontScale: 1000.0,
            zoomScale: 1000.0,
            borderScale: 1000.0,
          ),
          returnsNormally,
        );
      });
    });

    group('equality', () {
      test('two configs with same values are equal', () {
        const a = FondeAccessibilityConfig(zoomScale: 1.5);
        const b = FondeAccessibilityConfig(zoomScale: 1.5);
        expect(a, b);
      });

      test('configs with different values are not equal', () {
        const a = FondeAccessibilityConfig(zoomScale: 1.0);
        const b = FondeAccessibilityConfig(zoomScale: 2.0);
        expect(a, isNot(b));
      });
    });
  });
}
