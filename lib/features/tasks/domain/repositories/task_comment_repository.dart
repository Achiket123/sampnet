import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/domain/entities/task_comment_entity.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class TaskCommentRepository {
  Future<Either<ErrorModel, List<TaskCommentEntity>>> getTaskComments(String token, String taskId);
  Future<Either<ErrorModel, TaskCommentEntity>> addTaskComment(String token, String taskId, String content);
}
