import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/projects/domain/entities/milestone_entity.dart';
import 'package:hackathon/features/projects/domain/repositories/project_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class UpdateMilestoneUseCase {
  final ProjectRepository repository;

  UpdateMilestoneUseCase({required this.repository});

  Future<Either<ErrorModel, Milestone>> call(Milestone milestone) {
    return repository.updateMilestone(milestone);
  }
}