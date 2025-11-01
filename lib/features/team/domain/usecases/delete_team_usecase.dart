import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/team/domain/repo/team_repository.dart';
import 'package:hackathon/globals/constants/usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class DeleteTeamUsecase implements Usecase<int, int> {
  final TeamRepository teamRepository;
  DeleteTeamUsecase({required this.teamRepository});
  @override
  Future<Either<ErrorModel, int>> call(int id) {
    return teamRepository.deleteTeam(id);
  }
}
