import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/team/domain/repo/team_repository.dart';
import 'package:hackathon/globals/constants/usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/globals/models/team_model.dart';

class UpdateTeamUsecase implements Usecase<Team, Team> {
  final TeamRepository repository;

  UpdateTeamUsecase(this.repository);

  @override
  Future<Either<ErrorModel, Team>> call(Team params) async {
    return await repository.updateTeam(params.id!, params);
  }
}
