import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/data/models/task_model.dart';
import 'package:hackathon/features/tasks/domain/entities/task_entity.dart';
import 'package:hackathon/features/tasks/domain/entities/task_activity_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_repository.dart';
import 'package:hackathon/features/tasks/data/data_sources/task_remote_data_source.dart';
import 'package:hackathon/features/tasks/domain/use_cases/create_task_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/update_task_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource _taskRemoteDataSource;
  TaskRepositoryImpl({required TaskRemoteDataSource taskRemoteDataSource})
      : _taskRemoteDataSource = taskRemoteDataSource;
  @override
  Future<Either<ErrorModel, TaskModel>> createTask(
      CreateTaskParams params) async {
    return await _taskRemoteDataSource.createTask(params);
  }
}

class FetchTaskRepositoryImpl implements FetchTaskRepository {
  final TaskRemoteDataSource _taskRemoteDataSource;
  FetchTaskRepositoryImpl({required TaskRemoteDataSource taskRemoteDataSource})
      : _taskRemoteDataSource = taskRemoteDataSource;
  @override
  Future<Either<ErrorModel, TaskEntity>> fetchTaskById(
      String token, String id) async {
    return await _taskRemoteDataSource.fetchTaskById(token, id);
  }

  @override
  Future<Either<ErrorModel, List<TaskEntity>>> fetchTasks(String token) async {
    return await _taskRemoteDataSource.fetchTasks(token);
  }

  @override
  Future<Either<ErrorModel, List<TaskEntity>>> fetchTasksByOrganisationId(
      String token, String organisationId) {
    return _taskRemoteDataSource.fetchTasksByOrganisationId(
        token, organisationId);
  }

  @override
  Future<Either<ErrorModel, List<TaskActivityEntity>>> fetchTaskActivity(
      String token, String taskId) {
    return _taskRemoteDataSource.fetchTaskActivity(token, taskId);
  }
}

class UpdateTaskRepositoryImpl implements UpdateTaskRepository {
  final UpdateTaskRemoteDataSource remoteDataSource;

  UpdateTaskRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<ErrorModel, List<TaskEntity>>> updateTask(
          UpdateTaskParams params) =>
      remoteDataSource.updateTask(params);

  @override
  Future<Either<ErrorModel, Unit>> deleteTask(String token, String id) =>
      remoteDataSource.deleteTask(token, id);
}
