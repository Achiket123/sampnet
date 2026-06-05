import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import '../entities/task_comment_entity.dart';
import '../repositories/task_comment_repository.dart';

class GetTaskCommentsUseCase {
  final TaskCommentRepository repository;
  GetTaskCommentsUseCase({required this.repository});

  Future<Either<ErrorModel, List<TaskCommentEntity>>> call(int taskId) async {
    return await repository.getComments(taskId);
  }
}
