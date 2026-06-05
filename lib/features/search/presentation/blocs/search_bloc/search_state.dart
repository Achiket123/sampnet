part of 'search_bloc.dart';

abstract class SearchState {
  const SearchState();
}

/// The default state before any interaction.
class SearchInitial extends SearchState {
  const SearchInitial();
}

/// Emitted while a debounced search is in flight.
/// [previousResults] is non-null when there are stale results to keep visible.
class SearchLoading extends SearchState {
  final String query;
  final SearchResults? previousResults;
  const SearchLoading({required this.query, this.previousResults});
}

/// Emitted when a search completes successfully.
class SearchLoaded extends SearchState {
  final SearchResults results;
  final String query;
  const SearchLoaded({required this.results, required this.query});
}

/// Emitted when a search fails.
class SearchError extends SearchState {
  final String message;
  final String query;
  const SearchError({required this.message, required this.query});
}
