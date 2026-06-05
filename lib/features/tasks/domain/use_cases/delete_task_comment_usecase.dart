import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import '../repositories/task_comment_repository.dart';

class DeleteTaskCommentUseCase {
  final TaskCommentRepository repository;
  DeleteTaskCommentUseCase({required this.repository});

  Future<Either<ErrorModel, Unit>> call(int taskId, int commentId) async {
    return await repository.deleteComment(taskId, commentId);
  }
}
