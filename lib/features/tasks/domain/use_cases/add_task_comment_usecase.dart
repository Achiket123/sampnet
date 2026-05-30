import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/domain/entities/task_comment_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_comment_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class AddTaskCommentUseCase {
  final TaskCommentRepository repository;
  AddTaskCommentUseCase({required this.repository});

  Future<Either<ErrorModel, TaskCommentEntity>> call(String token, String taskId, String content) async {
    return await repository.addTaskComment(token, taskId, content);
  }
}
