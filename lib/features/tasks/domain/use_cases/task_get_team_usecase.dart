import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/data/models/team_model.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_team_repository.dart';
  
import 'package:hackathon/globals/constants/usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart'; 

class TaskGetTeamUsecase implements Usecase<List<TeamModel>, String> {
  final TaskTeamRepository teamRepository;
  TaskGetTeamUsecase({required this.teamRepository});
  @override
  Future<Either<ErrorModel, List<TeamModel>>> call(String token) async => teamRepository.getTeams(token);
}
 