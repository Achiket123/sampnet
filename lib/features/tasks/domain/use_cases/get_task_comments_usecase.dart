import '../entities/task_comment_entity.dart';
import '../repositories/task_comment_repository.dart';

class GetTaskCommentsUseCase {
  final TaskCommentRepository repository;
  GetTaskCommentsUseCase({required this.repository});

  Future<List<TaskCommentEntity>> call(int taskId) async {
    return await repository.getComments(taskId);
  }
}
