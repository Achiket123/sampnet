part of 'get_project_bloc.dart';

@immutable
sealed class GetProjectState {}

final class GetProjectInitial extends GetProjectState {}

final class GetProjectsLoading extends GetProjectState {}

final class GetProjectsSuccess extends GetProjectState {
  final List<ProjectEntity> projects;
  GetProjectsSuccess({required this.projects});
}

final class GetProjectsFailure extends GetProjectState {
  final ErrorModel error;
  GetProjectsFailure({required this.error});
}