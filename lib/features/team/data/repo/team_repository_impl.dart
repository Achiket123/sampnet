import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/team/data/datasources/team_data_source.dart';
import 'package:hackathon/features/team/data/models/team_memory.dart';
import 'package:hackathon/features/team/domain/repo/team_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/globals/models/team_model.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamDataSource dataSource;
  TeamRepositoryImpl({required this.dataSource});
  @override
  Future<Either<ErrorModel, List<Team>>> getTeams(String token) async =>
      dataSource.getTeams(token);

  @override
  Future<Either<ErrorModel, List<Team>>> createTeam(params) {
    return dataSource.createTeam(params);
  }

  @override
  Future<Either<ErrorModel, TeamMemory>> getTeamsById(String token) async =>
      dataSource.getTeamById(token);
  @override
  Future<Either<ErrorModel, int>> deleteTeam(int id) =>
      dataSource.deleteTeam(id);
  @override
  Future<Either<ErrorModel, Team>> updateTeam(int id, Team team) =>
      dataSource.updateTeam(id, team);
}
