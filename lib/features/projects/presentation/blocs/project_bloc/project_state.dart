import 'package:equatable/equatable.dart';
import 'package:hackathon/features/projects/domain/entities/project_entity.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object?> get props => [];
}

class ProjectInitial extends ProjectState {}

class ProjectLoading extends ProjectState {}

class ProjectsLoaded extends ProjectState {
  final List<Project> projects;
  const ProjectsLoaded(this.projects);

  @override
  List<Object?> get props => [projects];
}

class ProjectDetailLoaded extends ProjectState {
  final Project project;
  const ProjectDetailLoaded(this.project);

  @override
  List<Object?> get props => [project];
}

class ProjectActionSuccess extends ProjectState {
  final String message;
  const ProjectActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ProjectError extends ProjectState {
  final String message;
  const ProjectError(this.message);

  @override
  List<Object?> get props => [message];
}
