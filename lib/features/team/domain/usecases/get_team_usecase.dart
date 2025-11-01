import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/team/data/models/team_memory.dart';
 
import 'package:hackathon/features/team/domain/repo/team_repository.dart';
import 'package:hackathon/globals/constants/usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/globals/models/team_model.dart';

class GetTeamUseCase implements Usecase<List<Team>, String> {
  final TeamRepository teamRepository;
  GetTeamUseCase({required this.teamRepository});
  @override
  Future<Either<ErrorModel, List<Team>>> call(String token) async => teamRepository.getTeams(token);
}

class GetTeamByIdUseCase implements Usecase<TeamMemory, String> {
  final TeamRepository teamRepository;
  GetTeamByIdUseCase({required this.teamRepository});
  @override
  Future<Either<ErrorModel, TeamMemory>> call(String id) async => teamRepository.getTeamsById(id);
}