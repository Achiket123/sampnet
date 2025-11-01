part of 'get_project_bloc.dart';

@immutable
sealed class GetProjectEvent {}

class GetProjects extends GetProjectEvent {
  final String token;
   GetProjects({required this.token});
}

