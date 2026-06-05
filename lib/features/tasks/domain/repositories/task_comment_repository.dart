import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import '../entities/task_comment_entity.dart';

abstract class TaskCommentRepository {
  Future<Either<ErrorModel, TaskCommentEntity>> addComment(int taskId, int userId, String content);
  Future<Either<ErrorModel, List<TaskCommentEntity>>> getComments(int taskId);
  Future<Either<ErrorModel, Unit>> deleteComment(int taskId, int commentId);
}
