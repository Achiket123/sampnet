import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class DeleteTaskUseCase {
  final UpdateTaskRepository repository;
  DeleteTaskUseCase({required this.repository});

  Future<Either<ErrorModel, Unit>> call(String token, String id) async {
    return await repository.deleteTask(token, id);
  }
}
