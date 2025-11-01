import 'package:fpdart/src/either.dart';
import 'package:hackathon/features/team/domain/entities/project_entity.dart';
import 'package:hackathon/features/team/data/datasources/team_project_data_source.dart';
import 'package:hackathon/features/team/domain/repo/team_project_repo.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class TeamProjectRepoImpl implements TeamProjectRepo {
  final TeamProjectDataSource dataSource;
  TeamProjectRepoImpl(this.dataSource);
  @override
  Future<Either<ErrorModel, List<ProjectEntity>>> getProject(String token) {
    return dataSource.getProject(token);
  }
}
