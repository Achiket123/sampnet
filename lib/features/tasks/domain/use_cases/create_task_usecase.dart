import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/domain/entities/task_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_repository.dart';
import 'package:hackathon/globals/constants/usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class CreateTaskUseCase extends Usecase<TaskEntity, CreateTaskParams> {
  final TaskRepository _taskRepository;
  CreateTaskUseCase({required TaskRepository taskRepository}) : _taskRepository = taskRepository;
  @override
  Future<Either<ErrorModel, TaskEntity>> call(CreateTaskParams params) async {
    return await _taskRepository.createTask(params);
  }
}

class CreateTaskParams {
  final String token;
  final TaskEntity task;
  CreateTaskParams({required this.token, required this.task});
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'task': task.toMap(),
    };
  }
}
