part of 'search_bloc.dart';

abstract class SearchEvent {
  const SearchEvent();
}

/// Dispatched on every keystroke in the search field.
class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);
}

/// Dispatched when the user taps a type-filter chip.
/// [selectedTypes] is empty to mean "All".
class SearchTypeFilterChanged extends SearchEvent {
  final List<String> selectedTypes;
  const SearchTypeFilterChanged(this.selectedTypes);
}

/// Dispatched when the user clears the search field.
class SearchCleared extends SearchEvent {
  const SearchCleared();
}
