part of 'teamid_bloc.dart';

sealed class TeamidState extends Equatable {
  const TeamidState();
  
  @override
  List<Object> get props => [];
}

final class TeamidInitial extends TeamidState {}

class TeamLoadingState extends TeamidState {}
class TeamSuccessState extends TeamidState {
  final TeamMemory teamMemory;
  const TeamSuccessState({required this.teamMemory});
}
class TeamFailureState extends TeamidState {
  final ErrorModel errorModel;
  const TeamFailureState({required this.errorModel});
}