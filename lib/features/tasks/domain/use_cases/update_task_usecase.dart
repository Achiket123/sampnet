import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/domain/entities/task_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_repository.dart';
import 'package:hackathon/globals/constants/usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class UpdateTaskUsecase implements Usecase<List<TaskEntity>, UpdateTaskParams> {
  final UpdateTaskRepository repository;

  UpdateTaskUsecase({required this.repository});
  @override
  Future<Either<ErrorModel, List<TaskEntity>>> call(UpdateTaskParams params) =>
      repository.updateTask(params);
}
