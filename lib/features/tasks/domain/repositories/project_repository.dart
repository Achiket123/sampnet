import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/domain/entities/project_entity.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class ProjectRepository {
  Future<Either<ErrorModel, List<ProjectEntity>>> getProjects(String token);
}
