import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/projects/domain/repositories/project_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class DeleteProjectUseCase {
  final ProjectRepository repository;

  DeleteProjectUseCase({required this.repository});

  Future<Either<ErrorModel, void>> call(int id) {
    return repository.deleteProject(id);
  }
}