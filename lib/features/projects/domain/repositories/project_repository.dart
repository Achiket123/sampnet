import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/projects/domain/entities/project_entity.dart';
import 'package:hackathon/features/projects/domain/entities/milestone_entity.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class ProjectRepository {
  Future<Either<ErrorModel, List<Project>>> getProjects();
  Future<Either<ErrorModel, Project>> getProject(int id);
  Future<Either<ErrorModel, Project>> createProject(Project project);
  Future<Either<ErrorModel, Project>> updateProject(Project project);
  Future<Either<ErrorModel, void>> deleteProject(int id);

  Future<Either<ErrorModel, Milestone>> createMilestone(Milestone milestone);
  Future<Either<ErrorModel, Milestone>> updateMilestone(Milestone milestone);
  Future<Either<ErrorModel, void>> deleteMilestone(int projectId, int milestoneId);
}