import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/domain/entities/project_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/project_repository.dart';
import 'package:hackathon/globals/constants/usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class GetProjectUseCase implements Usecase<List<ProjectEntity>, String> {
  final ProjectRepository projectRepository;
  GetProjectUseCase({required this.projectRepository});
  @override
  Future<Either<ErrorModel, List<ProjectEntity>>> call(String token) async => projectRepository.getProjects(token);
}
