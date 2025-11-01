import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/data/data_sources/project_data_source.dart';
import 'package:hackathon/features/tasks/data/models/project_model.dart';
import 'package:hackathon/features/tasks/domain/repositories/project_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectDataSource dataSource;
  ProjectRepositoryImpl({required this.dataSource});
  @override
  Future<Either<ErrorModel, List<ProjectModel>>> getProjects(String token) async => dataSource.getProjects(token);
}
