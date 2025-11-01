import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/domain/entities/task_entity.dart';
import 'package:hackathon/features/tasks/domain/use_cases/create_task_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/update_task_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class TaskRepository {
  Future<Either<ErrorModel, TaskEntity>> createTask(CreateTaskParams params);
}

abstract class FetchTaskRepository {
  Future<Either<ErrorModel, List<TaskEntity>>> fetchTasks(String token);
  Future<Either<ErrorModel, TaskEntity>> fetchTaskById(String token, String id);
  Future<Either<ErrorModel, List<TaskEntity>>> fetchTasksByOrganisationId(
      String token, String organisationId);
}

abstract class UpdateTaskRepository {
  Future<Either<ErrorModel, List<TaskEntity>>> updateTask(
    UpdateTaskParams params
  );
}
