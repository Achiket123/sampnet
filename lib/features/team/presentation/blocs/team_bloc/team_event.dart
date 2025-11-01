part of 'team_bloc.dart';

@immutable
sealed class TeamEvent {}

class GetTeamEvent extends TeamEvent {
  final String token;
  GetTeamEvent({required this.token});
}

class CreateTeamEvent extends TeamEvent {
  final CreateTeamParam params;
  CreateTeamEvent({required this.params});
}

class DeleteTeamEvent extends TeamEvent {
  final int id;
  DeleteTeamEvent({required this.id});
}

class UpdateTeamEvent extends TeamEvent {
  final int id;
  final Team team;
  UpdateTeamEvent({required this.id, required this.team});
}
