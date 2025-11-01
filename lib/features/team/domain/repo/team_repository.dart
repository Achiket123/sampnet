import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/team/data/models/team_memory.dart';
import 'package:hackathon/features/team/domain/usecases/create_team_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/globals/models/team_model.dart';

abstract class TeamRepository {
  Future<Either<ErrorModel, List<Team>>> getTeams(String token);
  Future<Either<ErrorModel, List<Team>>> createTeam(CreateTeamParam params);
  Future<Either<ErrorModel, TeamMemory>> getTeamsById(String token);
  Future<Either<ErrorModel, int>> deleteTeam(int id);
  Future<Either<ErrorModel, Team>> updateTeam(int id, Team team);
}
