import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import '../../../domain/entities/research_entry_entity.dart';
import '../../../domain/use_cases/fetch_research_list_usecase.dart';

part 'research_list_event.dart';
part 'research_list_state.dart';

class ResearchListBloc extends Bloc<ResearchListEvent, ResearchListState> {
  final FetchResearchListUsecase fetchResearchListUsecase;

  ResearchListBloc({required this.fetchResearchListUsecase}) : super(ResearchListInitial()) {
    on<LoadResearchList>(_onLoadResearchList);
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 500))
          .switchMap(mapper),
    );
    on<FilterByStatus>(_onFilterByStatus);
  }

  Future<void> _onLoadResearchList(LoadResearchList event, Emitter<ResearchListState> emit) async {
    final currentState = state;
    int offset = 0;
    String? status;
    String? query;
    List<ResearchEntryEntity> oldEntries = [];

    if (!event.isRefresh && currentState is ResearchListLoaded) {
      if (currentState.hasReachedMax) return;
      offset = currentState.entries.length;
      status = currentState.statusFilter;
      query = currentState.searchQuery;
      oldEntries = currentState.entries;
    } else {
      emit(ResearchListLoading());
    }

    final result = await fetchResearchListUsecase(
      offset: offset,
      status: status,
      query: query,
    );

    result.fold(
      (error) => emit(ResearchListError(message: error.message)),
      (response) {
        emit(ResearchListLoaded(
          entries: event.isRefresh ? response.items : oldEntries + response.items,
          total: response.total,
          hasReachedMax: (event.isRefresh ? response.items : oldEntries + response.items).length >= response.total,
          statusFilter: status,
          searchQuery: query,
        ));
      },
    );
  }

  Future<void> _onSearchQueryChanged(SearchQueryChanged event, Emitter<ResearchListState> emit) async {
    emit(ResearchListLoading());
    final result = await fetchResearchListUsecase(query: event.query);
    result.fold(
      (error) => emit(ResearchListError(message: error.message)),
      (response) {
        emit(ResearchListLoaded(
          entries: response.items,
          total: response.total,
          hasReachedMax: response.items.length >= response.total,
          searchQuery: event.query,
        ));
      },
    );
  }

  Future<void> _onFilterByStatus(FilterByStatus event, Emitter<ResearchListState> emit) async {
    emit(ResearchListLoading());
    final result = await fetchResearchListUsecase(status: event.status);
    result.fold(
      (error) => emit(ResearchListError(message: error.message)),
      (response) {
        emit(ResearchListLoaded(
          entries: response.items,
          total: response.total,
          hasReachedMax: response.items.length >= response.total,
          statusFilter: event.status,
        ));
      },
    );
  }
}
