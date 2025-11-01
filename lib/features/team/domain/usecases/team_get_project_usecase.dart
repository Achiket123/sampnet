import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/team/domain/entities/project_entity.dart';
import 'package:hackathon/features/team/domain/repo/team_project_repo.dart';
import 'package:hackathon/globals/constants/usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class TeamGetProjectUsecase extends Usecase<List<ProjectEntity>, String> {
  final TeamProjectRepo teamProjectRepo;
  TeamGetProjectUsecase(this.teamProjectRepo);
  @override
  Future<Either<ErrorModel, List<ProjectEntity>>> call(String token) async {
   return teamProjectRepo.getProject(token);
  }
}
