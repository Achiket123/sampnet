part of 'research_detail_bloc.dart';

abstract class ResearchDetailState extends Equatable {
  const ResearchDetailState();
  
  @override
  List<Object?> get props => [];
}

class ResearchDetailInitial extends ResearchDetailState {}

class ResearchDetailLoading extends ResearchDetailState {}

class ResearchDetailLoaded extends ResearchDetailState {
  final ResearchEntryEntity entry;
  const ResearchDetailLoaded({required this.entry});

  @override
  List<Object?> get props => [entry];
}

class ResearchDetailError extends ResearchDetailState {
  final String message;
  const ResearchDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ResearchActionSuccess extends ResearchDetailState {
  final String message;
  const ResearchActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
