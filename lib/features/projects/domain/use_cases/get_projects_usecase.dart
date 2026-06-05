import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/projects/domain/entities/project_entity.dart';
import 'package:hackathon/features/projects/domain/repositories/project_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class GetProjectsUseCase {
  final ProjectRepository repository;

  GetProjectsUseCase({required this.repository});

  Future<Either<ErrorModel, List<Project>>> call() {
    return repository.getProjects();
  }
}