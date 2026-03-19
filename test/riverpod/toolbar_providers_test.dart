// Tests for fondeToolbarStateManagerProvider and fondeToolbarActionsProvider.
//
// Uses ProviderContainer directly. Verifies initial state, tool selection,
// and enable/disable transitions.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui_riverpod.dart';

void main() {
  group('Toolbar providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
    });
    group('fondeToolbarStateManagerProvider — initial state', () {
      test('selectedTool is null', () {
        final state = container.read(fondeToolbarStateManagerProvider);
        expect(state.selectedTool, isNull);
      });

      test('enabledTools is empty', () {
        final state = container.read(fondeToolbarStateManagerProvider);
        expect(state.enabledTools, isEmpty);
      });
    });

    group('selectTool', () {
      test('selectTool sets selectedTool', () {
        container
            .read(fondeToolbarStateManagerProvider.notifier)
            .selectTool('zoom');
        expect(
          container.read(fondeToolbarStateManagerProvider).selectedTool,
          'zoom',
        );
      });

      test('selecting a different tool replaces the previous selection', () {
        final notifier = container.read(
          fondeToolbarStateManagerProvider.notifier,
        );
        notifier.selectTool('zoom');
        notifier.selectTool('pan');
        expect(
          container.read(fondeToolbarStateManagerProvider).selectedTool,
          'pan',
        );
      });
    });

    group('enableTool / disableTool', () {
      test('enableTool adds the id to enabledTools', () {
        container
            .read(fondeToolbarStateManagerProvider.notifier)
            .enableTool('cut');
        expect(
          container.read(fondeToolbarStateManagerProvider).enabledTools,
          contains('cut'),
        );
      });

      test('disableTool removes the id from enabledTools', () {
        final notifier = container.read(
          fondeToolbarStateManagerProvider.notifier,
        );
        notifier.enableTool('cut');
        notifier.disableTool('cut');
        expect(
          container.read(fondeToolbarStateManagerProvider).enabledTools,
          isNot(contains('cut')),
        );
      });

      test('disabling one tool does not affect others', () {
        final notifier = container.read(
          fondeToolbarStateManagerProvider.notifier,
        );
        notifier.enableTool('cut');
        notifier.enableTool('copy');
        notifier.disableTool('cut');
        expect(
          container.read(fondeToolbarStateManagerProvider).enabledTools,
          contains('copy'),
        );
      });
    });

    group('fondeToolbarActionsProvider', () {
      test('selectTool via actions updates the state', () {
        container.read(fondeToolbarActionsProvider).selectTool('actions-tool');
        expect(
          container.read(fondeToolbarStateManagerProvider).selectedTool,
          'actions-tool',
        );
      });

      test('enableTool via actions updates the state', () {
        container.read(fondeToolbarActionsProvider).enableTool('actions-tool');
        expect(
          container.read(fondeToolbarStateManagerProvider).enabledTools,
          contains('actions-tool'),
        );
      });

      test('disableTool via actions updates the state', () {
        container.read(fondeToolbarActionsProvider).enableTool('actions-tool');
        container.read(fondeToolbarActionsProvider).disableTool('actions-tool');
        expect(
          container.read(fondeToolbarStateManagerProvider).enabledTools,
          isNot(contains('actions-tool')),
        );
      });
    });
  });
}
