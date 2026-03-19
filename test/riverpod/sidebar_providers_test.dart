// Tests for sidebar visibility and width Riverpod providers.
//
// Uses ProviderContainer directly. Verifies initial visibility, toggle,
// show/hide, and width clamping behaviour.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui_riverpod.dart';

void main() {
  group('Sidebar providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
    });
    group('fondePrimarySidebarStateProvider', () {
      test('initial value is true (visible)', () {
        expect(container.read(fondePrimarySidebarStateProvider), true);
      });

      test('toggle switches true to false', () {
        container.read(fondePrimarySidebarStateProvider.notifier).toggle();
        expect(container.read(fondePrimarySidebarStateProvider), false);
      });

      test('toggle switches false back to true', () {
        final notifier = container.read(
          fondePrimarySidebarStateProvider.notifier,
        );
        notifier.toggle();
        notifier.toggle();
        expect(container.read(fondePrimarySidebarStateProvider), true);
      });

      test('hide sets value to false', () {
        container.read(fondePrimarySidebarStateProvider.notifier).hide();
        expect(container.read(fondePrimarySidebarStateProvider), false);
      });

      test('show sets value to true', () {
        container.read(fondePrimarySidebarStateProvider.notifier).hide();
        container.read(fondePrimarySidebarStateProvider.notifier).show();
        expect(container.read(fondePrimarySidebarStateProvider), true);
      });

      test('setVisible(false) hides the sidebar', () {
        container
            .read(fondePrimarySidebarStateProvider.notifier)
            .setVisible(false);
        expect(container.read(fondePrimarySidebarStateProvider), false);
      });

      test('setVisible(true) shows the sidebar', () {
        container
            .read(fondePrimarySidebarStateProvider.notifier)
            .setVisible(false);
        container
            .read(fondePrimarySidebarStateProvider.notifier)
            .setVisible(true);
        expect(container.read(fondePrimarySidebarStateProvider), true);
      });
    });

    group('fondeSecondarySidebarStateProvider', () {
      test('initial value is false (hidden)', () {
        expect(container.read(fondeSecondarySidebarStateProvider), false);
      });

      test('toggle switches false to true', () {
        container.read(fondeSecondarySidebarStateProvider.notifier).toggle();
        expect(container.read(fondeSecondarySidebarStateProvider), true);
      });

      test('show sets value to true', () {
        container.read(fondeSecondarySidebarStateProvider.notifier).show();
        expect(container.read(fondeSecondarySidebarStateProvider), true);
      });

      test('hide sets value to false', () {
        container.read(fondeSecondarySidebarStateProvider.notifier).show();
        container.read(fondeSecondarySidebarStateProvider.notifier).hide();
        expect(container.read(fondeSecondarySidebarStateProvider), false);
      });
    });

    group('sidebarWidthProvider', () {
      test('setWidth changes the width', () {
        container.read(sidebarWidthProvider.notifier).setWidth(400);
        expect(container.read(sidebarWidthProvider), 400);
      });

      test('setWidth clamps to maxWidth (480)', () {
        container.read(sidebarWidthProvider.notifier).setWidth(9999);
        expect(container.read(sidebarWidthProvider), 480);
      });

      test('setWidth clamps to minWidth (240)', () {
        container.read(sidebarWidthProvider.notifier).setWidth(10);
        expect(container.read(sidebarWidthProvider), 240);
      });

      test('adjustWidth increases the width', () {
        container.read(sidebarWidthProvider.notifier).setWidth(320);
        container.read(sidebarWidthProvider.notifier).adjustWidth(40);
        expect(container.read(sidebarWidthProvider), 360);
      });

      test('adjustWidth clamps at maxWidth', () {
        container.read(sidebarWidthProvider.notifier).setWidth(460);
        container.read(sidebarWidthProvider.notifier).adjustWidth(100);
        expect(container.read(sidebarWidthProvider), 480);
      });
    });

    group('secondarySidebarWidthProvider', () {
      test('setWidth changes the width', () {
        container.read(secondarySidebarWidthProvider.notifier).setWidth(300);
        expect(container.read(secondarySidebarWidthProvider), 300);
      });

      test('setWidth clamps to maxWidth (400)', () {
        container.read(secondarySidebarWidthProvider.notifier).setWidth(9999);
        expect(container.read(secondarySidebarWidthProvider), 400);
      });

      test('setWidth clamps to minWidth (200)', () {
        container.read(secondarySidebarWidthProvider.notifier).setWidth(1);
        expect(container.read(secondarySidebarWidthProvider), 200);
      });
    });
  });
}
