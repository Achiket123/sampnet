import '../repositories/task_comment_repository.dart';

class DeleteTaskCommentUseCase {
  final TaskCommentRepository repository;
  DeleteTaskCommentUseCase({required this.repository});

  Future<void> call(int taskId, int commentId) async {
    return await repository.deleteComment(taskId, commentId);
  }
}
