import 'package:equatable/equatable.dart';
import 'package:hackathon/features/projects/domain/entities/project_entity.dart';
import 'package:hackathon/features/projects/domain/entities/milestone_entity.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object?> get props => [];
}

class LoadProjectsEvent extends ProjectEvent {}

class LoadProjectDetailEvent extends ProjectEvent {
  final int id;
  const LoadProjectDetailEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateProjectEvent extends ProjectEvent {
  final Project project;
  const CreateProjectEvent(this.project);

  @override
  List<Object?> get props => [project];
}

class UpdateProjectEvent extends ProjectEvent {
  final Project project;
  const UpdateProjectEvent(this.project);

  @override
  List<Object?> get props => [project];
}

class DeleteProjectEvent extends ProjectEvent {
  final int id;
  const DeleteProjectEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateMilestoneEvent extends ProjectEvent {
  final Milestone milestone;
  const CreateMilestoneEvent(this.milestone);

  @override
  List<Object?> get props => [milestone];
}

class UpdateMilestoneEvent extends ProjectEvent {
  final Milestone milestone;
  const UpdateMilestoneEvent(this.milestone);

  @override
  List<Object?> get props => [milestone];
}

class DeleteMilestoneEvent extends ProjectEvent {
  final int projectId;
  final int milestoneId;
  const DeleteMilestoneEvent({required this.projectId, required this.milestoneId});

  @override
  List<Object?> get props => [projectId, milestoneId];
}
