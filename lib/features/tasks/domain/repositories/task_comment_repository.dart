import '../entities/task_comment_entity.dart';

abstract class TaskCommentRepository {
  Future<TaskCommentEntity> addComment(int taskId, int userId, String content);
  Future<List<TaskCommentEntity>> getComments(int taskId);
  Future<void> deleteComment(int taskId, int commentId);
}
