part of 'project_bloc.dart';

@immutable
sealed class ProjectEvent {}

class GetProjectEvent extends ProjectEvent {
  final String token;
  GetProjectEvent({required this.token});
}