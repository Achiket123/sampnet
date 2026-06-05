import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/projects/domain/use_cases/create_milestone_usecase.dart';
import 'package:hackathon/features/projects/domain/use_cases/create_project_usecase.dart';
import 'package:hackathon/features/projects/domain/use_cases/delete_milestone_usecase.dart';
import 'package:hackathon/features/projects/domain/use_cases/delete_project_usecase.dart';
import 'package:hackathon/features/projects/domain/use_cases/get_project_detail_usecase.dart';
import 'package:hackathon/features/projects/domain/use_cases/get_projects_usecase.dart';
import 'package:hackathon/features/projects/domain/use_cases/update_milestone_usecase.dart';
import 'package:hackathon/features/projects/domain/use_cases/update_project_usecase.dart';
import 'package:hackathon/features/projects/presentation/blocs/project_bloc/project_event.dart';
import 'package:hackathon/features/projects/presentation/blocs/project_bloc/project_state.dart';

class ProjectsBloc extends Bloc<ProjectEvent, ProjectState> {
  final GetProjectsUseCase getProjectsUseCase;
  final GetProjectDetailUseCase getProjectDetailUseCase;
  final CreateProjectUseCase createProjectUseCase;
  final UpdateProjectUseCase updateProjectUseCase;
  final DeleteProjectUseCase deleteProjectUseCase;
  final CreateMilestoneUseCase createMilestoneUseCase;
  final UpdateMilestoneUseCase updateMilestoneUseCase;
  final DeleteMilestoneUseCase deleteMilestoneUseCase;

  ProjectsBloc({
    required this.getProjectsUseCase,
    required this.getProjectDetailUseCase,
    required this.createProjectUseCase,
    required this.updateProjectUseCase,
    required this.deleteProjectUseCase,
    required this.createMilestoneUseCase,
    required this.updateMilestoneUseCase,
    required this.deleteMilestoneUseCase,
  }) : super(ProjectInitial()) {
    on<LoadProjectsEvent>(_onLoadProjects);
    on<LoadProjectDetailEvent>(_onLoadProjectDetail);
    on<CreateProjectEvent>(_onCreateProject);
    on<UpdateProjectEvent>(_onUpdateProject);
    on<DeleteProjectEvent>(_onDeleteProject);
    on<CreateMilestoneEvent>(_onCreateMilestone);
    on<UpdateMilestoneEvent>(_onUpdateMilestone);
    on<DeleteMilestoneEvent>(_onDeleteMilestone);
  }

  Future<void> _onLoadProjects(LoadProjectsEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading());
    final result = await getProjectsUseCase();
    result.fold(
      (failure) => emit(ProjectError(failure.message)),
      (projects) => emit(ProjectsLoaded(projects)),
    );
  }

  Future<void> _onLoadProjectDetail(LoadProjectDetailEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading());
    final result = await getProjectDetailUseCase(event.id);
    result.fold(
      (failure) => emit(ProjectError(failure.message)),
      (project) => emit(ProjectDetailLoaded(project)),
    );
  }

  Future<void> _onCreateProject(CreateProjectEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading());
    final result = await createProjectUseCase(event.project);
    result.fold(
      (failure) => emit(ProjectError(failure.message)),
      (_) => emit(const ProjectActionSuccess("Project created successfully")),
    );
  }

  Future<void> _onUpdateProject(UpdateProjectEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading());
    final result = await updateProjectUseCase(event.project);
    result.fold(
      (failure) => emit(ProjectError(failure.message)),
      (_) => emit(const ProjectActionSuccess("Project updated successfully")),
    );
  }

  Future<void> _onDeleteProject(DeleteProjectEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading());
    final result = await deleteProjectUseCase(event.id);
    result.fold(
      (failure) => emit(ProjectError(failure.message)),
      (_) => emit(const ProjectActionSuccess("Project deleted successfully")),
    );
  }

  Future<void> _onCreateMilestone(CreateMilestoneEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading());
    final result = await createMilestoneUseCase(event.milestone);
    result.fold(
      (failure) => emit(ProjectError(failure.message)),
      (_) => emit(const ProjectActionSuccess("Milestone created successfully")),
    );
  }

  Future<void> _onUpdateMilestone(UpdateMilestoneEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading());
    final result = await updateMilestoneUseCase(event.milestone);
    result.fold(
      (failure) => emit(ProjectError(failure.message)),
      (_) => emit(const ProjectActionSuccess("Milestone updated successfully")),
    );
  }

  Future<void> _onDeleteMilestone(DeleteMilestoneEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading());
    final result = await deleteMilestoneUseCase(
      projectId: event.projectId,
      milestoneId: event.milestoneId,
    );
    result.fold(
      (failure) => emit(ProjectError(failure.message)),
      (_) => emit(const ProjectActionSuccess("Milestone deleted successfully")),
    );
  }
}
