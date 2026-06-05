import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/search/domain/entities/search_entity.dart';
import 'package:hackathon/features/search/domain/use_cases/global_search_usecase.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GlobalSearchUsecase searchUsecase;

  Timer? _debounce;
  List<String> _activeTypes = [];
  String _lastQuery = '';

  static const _debounceDuration = Duration(milliseconds: 400);

  SearchBloc({required this.searchUsecase}) : super(const SearchInitial()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchTypeFilterChanged>(_onTypeFilterChanged);
    on<SearchCleared>(_onCleared);
    on<_RunSearch>(_runSearch);
  }

  void _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) {
    _lastQuery = event.query;

    // Cancel any pending debounce timer.
    _debounce?.cancel();

    if (event.query.trim().length < 2) {
      emit(const SearchInitial());
      return;
    }

    // Carry previous results through the loading state to avoid a blank flash.
    final previous = state is SearchLoaded
        ? (state as SearchLoaded).results
        : state is SearchLoading
            ? (state as SearchLoading).previousResults
            : null;

    emit(SearchLoading(query: event.query, previousResults: previous));

    _debounce = Timer(_debounceDuration, () {
      add(_RunSearch(query: event.query, types: _activeTypes));
    });
  }

  void _onTypeFilterChanged(
      SearchTypeFilterChanged event, Emitter<SearchState> emit) {
    _activeTypes = event.selectedTypes;

    // Re-run immediately with the last query if it is valid.
    if (_lastQuery.trim().length >= 2) {
      add(_RunSearch(query: _lastQuery, types: _activeTypes));
    }
  }

  void _onCleared(SearchCleared event, Emitter<SearchState> emit) {
    _debounce?.cancel();
    _lastQuery = '';
    emit(const SearchInitial());
  }

  // Internal event fired by the debounce timer.
  Future<void> _runSearch(
      _RunSearch event, Emitter<SearchState> emit) async {
    final result = await searchUsecase(
      query: event.query,
      types: event.types,
    );
    result.fold(
      (failure) => emit(SearchError(message: failure.message, query: event.query)),
      (results) => emit(SearchLoaded(results: results, query: event.query)),
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}

// Private internal event – only ever emitted by the BLoC itself.
class _RunSearch extends SearchEvent {
  final String query;
  final List<String> types;
  const _RunSearch({required this.query, required this.types});
}
