import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/domain/entities/task_comment_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_comment_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class GetTaskCommentsUseCase {
  final TaskCommentRepository repository;
  GetTaskCommentsUseCase({required this.repository});

  Future<Either<ErrorModel, List<TaskCommentEntity>>> call(String token, String taskId) async {
    return await repository.getTaskComments(token, taskId);
  }
}
