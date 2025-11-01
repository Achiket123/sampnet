part of 'teamid_bloc.dart';

sealed class TeamidEvent extends Equatable {
  const TeamidEvent();

  @override
  List<Object> get props => [];
}

class GetTeamIdEvent extends TeamidEvent {
  final String id;
  const GetTeamIdEvent({required this.id});
}
