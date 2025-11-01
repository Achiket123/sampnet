part of 'project_bloc.dart';

@immutable
sealed class ProjectState {}

final class ProjectInitial extends ProjectState {}

class ProjectLoadingState extends ProjectState {}
class ProjectErrorState extends ProjectState {
  final ErrorModel error;
  ProjectErrorState({required this.error});
}
class ProjectSuccessState extends ProjectState {
  final List<ProjectEntity> projects;
  ProjectSuccessState({required this.projects});
}