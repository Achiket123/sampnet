import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/projects/data/data_sources/project_remote_data_source.dart';
import 'package:hackathon/features/projects/data/models/project_model.dart';
import 'package:hackathon/features/projects/data/models/milestone_model.dart';
import 'package:hackathon/features/projects/domain/entities/project_entity.dart';
import 'package:hackathon/features/projects/domain/entities/milestone_entity.dart';
import 'package:hackathon/features/projects/domain/repositories/project_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;

  ProjectRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ErrorModel, List<Project>>> getProjects() async {
    try {
      final projects = await remoteDataSource.getProjects();
      return Right(projects);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, Project>> getProject(int id) async {
    try {
      final project = await remoteDataSource.getProject(id);
      return Right(project);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, Project>> createProject(Project project) async {
    try {
      final model = ProjectModel(
        id: project.id,
        name: project.name,
        description: project.description,
        startDate: project.startDate,
        endDate: project.endDate,
        organisationId: project.organisationId,
        teamId: project.teamId,
        createdBy: project.createdBy,
        status: project.status,
        priority: project.priority,
        completionStatus: project.completionStatus,
        milestones: const [],
      );
      final created = await remoteDataSource.createProject(model);
      return Right(created);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, Project>> updateProject(Project project) async {
    try {
      final model = ProjectModel(
        id: project.id,
        name: project.name,
        description: project.description,
        startDate: project.startDate,
        endDate: project.endDate,
        organisationId: project.organisationId,
        teamId: project.teamId,
        createdBy: project.createdBy,
        status: project.status,
        priority: project.priority,
        completionStatus: project.completionStatus,
        milestones: const [],
      );
      final updated = await remoteDataSource.updateProject(model);
      return Right(updated);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> deleteProject(int id) async {
    try {
      await remoteDataSource.deleteProject(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, Milestone>> createMilestone(Milestone milestone) async {
    try {
      final model = MilestoneModel(
        id: milestone.id,
        projectId: milestone.projectId,
        title: milestone.title,
        description: milestone.description,
        dueDate: milestone.dueDate,
        status: milestone.status,
        isOverdue: milestone.isOverdue,
        organisationId: milestone.organisationId,
      );
      final created = await remoteDataSource.createMilestone(model);
      return Right(created);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, Milestone>> updateMilestone(Milestone milestone) async {
    try {
      final model = MilestoneModel(
        id: milestone.id,
        projectId: milestone.projectId,
        title: milestone.title,
        description: milestone.description,
        dueDate: milestone.dueDate,
        status: milestone.status,
        isOverdue: milestone.isOverdue,
        organisationId: milestone.organisationId,
      );
      final updated = await remoteDataSource.updateMilestone(model);
      return Right(updated);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> deleteMilestone(int projectId, int milestoneId) async {
    try {
      await remoteDataSource.deleteMilestone(projectId, milestoneId);
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }
}