import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import '../entities/task_comment_entity.dart';
import '../repositories/task_comment_repository.dart';

class AddTaskCommentUseCase {
  final TaskCommentRepository repository;
  AddTaskCommentUseCase({required this.repository});

  Future<Either<ErrorModel, TaskCommentEntity>> call(int taskId, int userId, String content) async {
    return await repository.addComment(taskId, userId, content);
  }
}
