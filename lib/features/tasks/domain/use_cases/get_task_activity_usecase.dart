import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/domain/entities/task_activity_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class GetTaskActivityUseCase {
  final FetchTaskRepository repository;
  GetTaskActivityUseCase({required this.repository});

  Future<Either<ErrorModel, List<TaskActivityEntity>>> call(String token, String taskId) async {
    return await repository.fetchTaskActivity(token, taskId);
  }
}
