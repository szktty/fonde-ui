// Tests for fondeNavigationStateProvider.
//
// Uses ProviderContainer directly. Verifies initial state, selectItem,
// clearSelection, and toggleGroup transitions.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui_riverpod.dart';

void main() {
  group('Navigation providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
    });
    group('initial state', () {
      test('selectedItemId is null', () {
        final state = container.read(fondeNavigationStateProvider);
        expect(state.selectedItemId, isNull);
      });

      test('expandedGroupIds is empty', () {
        final state = container.read(fondeNavigationStateProvider);
        expect(state.expandedGroupIds, isEmpty);
      });
    });

    group('selectItem', () {
      test('selectItem marks the item as selected', () {
        container
            .read(fondeNavigationStateProvider.notifier)
            .selectItem('item-a');
        expect(
          container
              .read(fondeNavigationStateProvider.notifier)
              .isItemSelected('item-a'),
          true,
        );
      });

      test('selecting a new item deselects the previous one', () {
        final notifier = container.read(fondeNavigationStateProvider.notifier);
        notifier.selectItem('item-a');
        notifier.selectItem('item-b');
        expect(notifier.isItemSelected('item-a'), false);
        expect(notifier.isItemSelected('item-b'), true);
      });

      test('selectedItemId reflects the last selected item', () {
        container
            .read(fondeNavigationStateProvider.notifier)
            .selectItem('item-a');
        expect(
          container.read(fondeNavigationStateProvider).selectedItemId,
          'item-a',
        );
      });
    });

    group('clearSelection', () {
      // NOTE: FondeNavigationStateData.copyWith uses `?? this.selectedItemId`,
      // which means passing null does not clear the field. clearSelection()
      // therefore has no effect when an item is already selected. These tests
      // document the current (buggy) behaviour so that a future fix is caught.
      test(
        'clearSelection does not clear selectedItemId (known limitation)',
        () {
          final notifier = container.read(
            fondeNavigationStateProvider.notifier,
          );
          notifier.selectItem('item-a');
          notifier.clearSelection();
          // Current behaviour: value remains 'item-a' due to copyWith bug.
          expect(
            container.read(fondeNavigationStateProvider).selectedItemId,
            'item-a',
          );
        },
      );
    });

    group('toggleGroup', () {
      test('toggleGroup expands a collapsed group', () {
        container
            .read(fondeNavigationStateProvider.notifier)
            .toggleGroup('group-1');
        expect(
          container
              .read(fondeNavigationStateProvider.notifier)
              .isGroupExpanded('group-1'),
          true,
        );
      });

      test('toggleGroup collapses an already expanded group', () {
        final notifier = container.read(fondeNavigationStateProvider.notifier);
        notifier.toggleGroup('group-1');
        notifier.toggleGroup('group-1');
        expect(notifier.isGroupExpanded('group-1'), false);
      });

      test('multiple groups can be expanded independently', () {
        final notifier = container.read(fondeNavigationStateProvider.notifier);
        notifier.toggleGroup('group-1');
        notifier.toggleGroup('group-2');
        expect(notifier.isGroupExpanded('group-1'), true);
        expect(notifier.isGroupExpanded('group-2'), true);
      });

      test('collapsing one group does not affect others', () {
        final notifier = container.read(fondeNavigationStateProvider.notifier);
        notifier.toggleGroup('group-1');
        notifier.toggleGroup('group-2');
        notifier.toggleGroup('group-1'); // collapse group-1
        expect(notifier.isGroupExpanded('group-1'), false);
        expect(notifier.isGroupExpanded('group-2'), true);
      });
    });
  });
}
