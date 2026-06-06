part of 'research_list_bloc.dart';

abstract class ResearchListState extends Equatable {
  const ResearchListState();

  @override
  List<Object?> get props => [];
}

class ResearchListInitial extends ResearchListState {}

class ResearchListLoading extends ResearchListState {}

class ResearchListLoaded extends ResearchListState {
  final List<ResearchEntryEntity> entries;
  final int total;
  final bool hasReachedMax;
  final String? statusFilter;
  final String? searchQuery;

  const ResearchListLoaded({
    required this.entries,
    required this.total,
    required this.hasReachedMax,
    this.statusFilter,
    this.searchQuery,
  });

  @override
  List<Object?> get props =>
      [entries, total, hasReachedMax, statusFilter, searchQuery];

  ResearchListLoaded copyWith({
    List<ResearchEntryEntity>? entries,
    int? total,
    bool? hasReachedMax,
    String? statusFilter,
    String? searchQuery,
  }) {
    return ResearchListLoaded(
      entries: entries ?? this.entries,
      total: total ?? this.total,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      statusFilter: statusFilter ?? this.statusFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ResearchListError extends ResearchListState {
  final String message;
  const ResearchListError({required this.message});

  @override
  List<Object?> get props => [message];
}
