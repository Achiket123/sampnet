import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/data/models/team_model.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class TaskTeamRepository {
  Future<Either<ErrorModel, List<TeamModel>>> getTeams(String token);
}
