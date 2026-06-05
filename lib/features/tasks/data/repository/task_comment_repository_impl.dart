import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/data/data_sources/task_comment_data_source.dart';
import 'package:hackathon/features/tasks/domain/entities/task_comment_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_comment_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class TaskCommentRepositoryImpl implements TaskCommentRepository {
  final TaskCommentRemoteDataSource remoteDataSource;
  TaskCommentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ErrorModel, TaskCommentEntity>> addComment(int taskId, int userId, String content) async {
    final result = await remoteDataSource.addTaskComment(taskId, content);
    return result.map((model) => model.toEntity());
  }

  @override
  Future<Either<ErrorModel, List<TaskCommentEntity>>> getComments(int taskId) async {
    final result = await remoteDataSource.getTaskComments(taskId);
    return result.map((models) => models.map((e) => e.toEntity()).toList());
  }

  @override
  Future<Either<ErrorModel, Unit>> deleteComment(int taskId, int commentId) async {
    return await remoteDataSource.deleteTaskComment(taskId, commentId);
  }
}
