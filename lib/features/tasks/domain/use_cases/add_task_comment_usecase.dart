import '../entities/task_comment_entity.dart';
import '../repositories/task_comment_repository.dart';

class AddTaskCommentUseCase {
  final TaskCommentRepository repository;
  AddTaskCommentUseCase({required this.repository});

  Future<TaskCommentEntity> call(int taskId, int userId, String content) async {
    return await repository.addComment(taskId, userId, content);
  }
}
