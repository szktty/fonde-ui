import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_providers.g.dart';

/// Provider that manages the current search query.
@riverpod
class FondeSearchQuery extends _$FondeSearchQuery {
  @override
  String build() => '';

  /// Update the search query.
  void updateQuery(String? newQuery) {
    state = newQuery ?? '';
  }

  /// Clear the search query.
  void clearQuery() {
    state = '';
  }
}

/// Provider that manages the state and actions of the search field.
@riverpod
FondeSearchFieldManager fondeSearchFieldManager(Ref ref) {
  return FondeSearchFieldManager(ref);
}

/// Search field manager class.
class FondeSearchFieldManager {
  final Ref _ref;

  FondeSearchFieldManager(this._ref);

  /// The current search query.
  String get query => _ref.read(fondeSearchQueryProvider);

  /// Update the search query.
  void updateQuery(String? newQuery) {
    _ref.read(fondeSearchQueryProvider.notifier).updateQuery(newQuery);
  }

  /// Clear the search query.
  void clearQuery() {
    _ref.read(fondeSearchQueryProvider.notifier).clearQuery();
  }
}
