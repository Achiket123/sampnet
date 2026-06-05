import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/projects/domain/entities/project_entity.dart';
import 'package:hackathon/features/projects/domain/repositories/project_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class GetProjectDetailUseCase {
  final ProjectRepository repository;

  GetProjectDetailUseCase({required this.repository});

  Future<Either<ErrorModel, Project>> call(int id) {
    return repository.getProject(id);
  }
}