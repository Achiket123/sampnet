import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/projects/domain/entities/project_entity.dart';
import 'package:hackathon/features/projects/domain/repositories/project_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class CreateProjectUseCase {
  final ProjectRepository repository;

  CreateProjectUseCase({required this.repository});

  Future<Either<ErrorModel, Project>> call(Project project) {
    return repository.createProject(project);
  }
}