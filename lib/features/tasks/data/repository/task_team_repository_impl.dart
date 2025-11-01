import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/data/data_sources/task_team_data_source.dart';
import 'package:hackathon/features/tasks/data/models/team_model.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_team_repository.dart'; 
import 'package:hackathon/globals/error_handling/error_model.dart';

class TaskTeamRepositoryImpl implements TaskTeamRepository {
  final TaskTeamDataSource dataSource;
  TaskTeamRepositoryImpl({required this.dataSource});
  @override
  Future<Either<ErrorModel, List<TeamModel>>> getTeams(String token) async => dataSource.getTeams(token);
}
