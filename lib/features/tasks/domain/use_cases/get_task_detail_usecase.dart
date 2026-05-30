import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/domain/entities/task_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class GetTaskDetailUseCase {
  final FetchTaskRepository repository;
  GetTaskDetailUseCase({required this.repository});

  Future<Either<ErrorModel, TaskEntity>> call(String token, String id) async {
    return await repository.fetchTaskById(token, id);
  }
}
