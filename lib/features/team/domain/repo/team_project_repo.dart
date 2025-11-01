import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/team/domain/entities/project_entity.dart';
import 'package:hackathon/globals/error_handling/error_model.dart'; 

abstract class TeamProjectRepo {
  Future<Either<ErrorModel, List<ProjectEntity>>> getProject(String token);
}