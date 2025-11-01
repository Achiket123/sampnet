part of 'team_bloc.dart';

@immutable
sealed class TeamState {}

final class TeamInitial extends TeamState {}

class TeamLoadingState extends TeamState {}

class TeamErrorState extends TeamState {
  final ErrorModel error;
  TeamErrorState({required this.error});
}

class TeamSuccessState extends TeamState {
  final List<Team> teams;
  TeamSuccessState({required this.teams});
}
