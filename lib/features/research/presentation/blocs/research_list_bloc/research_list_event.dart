part of 'research_list_bloc.dart';

abstract class ResearchListEvent extends Equatable {
  const ResearchListEvent();

  @override
  List<Object?> get props => [];
}

class LoadResearchList extends ResearchListEvent {
  final bool isRefresh;
  const LoadResearchList({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class SearchQueryChanged extends ResearchListEvent {
  final String query;
  const SearchQueryChanged({required this.query});

  @override
  List<Object?> get props => [query];
}

class FilterByStatus extends ResearchListEvent {
  final String? status;
  const FilterByStatus({this.status});

  @override
  List<Object?> get props => [status];
}
