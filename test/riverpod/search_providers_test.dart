// Tests for fondeSearchQueryProvider and fondeSearchFieldManagerProvider.
//
// Uses ProviderContainer directly. Verifies initial query state, updateQuery,
// and clearQuery behaviour.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fonde_ui/fonde_ui_riverpod.dart';

void main() {
  group('Search providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
    });
    group('fondeSearchQueryProvider', () {
      test('initial query is empty string', () {
        final query = container.read(fondeSearchQueryProvider);
        expect(query, '');
      });

      test('updateQuery sets the query', () {
        container.read(fondeSearchQueryProvider.notifier).updateQuery('hello');
        expect(container.read(fondeSearchQueryProvider), 'hello');
      });

      test('updateQuery with null clears the query', () {
        container.read(fondeSearchQueryProvider.notifier).updateQuery('hello');
        container.read(fondeSearchQueryProvider.notifier).updateQuery(null);
        expect(container.read(fondeSearchQueryProvider), '');
      });

      test('clearQuery resets to empty string', () {
        container
            .read(fondeSearchQueryProvider.notifier)
            .updateQuery('search term');
        container.read(fondeSearchQueryProvider.notifier).clearQuery();
        expect(container.read(fondeSearchQueryProvider), '');
      });

      test('query can be updated multiple times', () {
        final notifier = container.read(fondeSearchQueryProvider.notifier);
        notifier.updateQuery('first');
        notifier.updateQuery('second');
        expect(container.read(fondeSearchQueryProvider), 'second');
      });
    });

    group('fondeSearchFieldManagerProvider', () {
      test('manager query matches fondeSearchQueryProvider', () {
        container
            .read(fondeSearchQueryProvider.notifier)
            .updateQuery('test query');
        final manager = container.read(fondeSearchFieldManagerProvider);
        expect(manager.query, 'test query');
      });

      test('manager.updateQuery updates the shared query', () {
        container
            .read(fondeSearchFieldManagerProvider)
            .updateQuery('via manager');
        expect(container.read(fondeSearchQueryProvider), 'via manager');
      });

      test('manager.clearQuery resets the shared query', () {
        container
            .read(fondeSearchQueryProvider.notifier)
            .updateQuery('something');
        container.read(fondeSearchFieldManagerProvider).clearQuery();
        expect(container.read(fondeSearchQueryProvider), '');
      });
    });
  });
}
