import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/projects/domain/repositories/project_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class DeleteMilestoneUseCase {
  final ProjectRepository repository;

  DeleteMilestoneUseCase({required this.repository});

  Future<Either<ErrorModel, void>> call({required int projectId, required int milestoneId}) {
    return repository.deleteMilestone(projectId, milestoneId);
  }
}
