import 'package:hackathon/features/tasks/data/data_sources/task_comment_remote_data_source.dart';
import 'package:hackathon/features/tasks/data/models/task_comment_model.dart';
import 'package:hackathon/features/tasks/domain/entities/task_comment_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_comment_repository.dart';

class TaskCommentRepositoryImpl implements TaskCommentRepository {
  final TaskCommentRemoteDataSource remoteDataSource;
  TaskCommentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<TaskCommentEntity> addComment(int taskId, int userId, String content) async {
    final result = await remoteDataSource.postComment(taskId, content);
    return TaskCommentModel.fromJson(result).toEntity();
  }

  @override
  Future<List<TaskCommentEntity>> getComments(int taskId) async {
    final result = await remoteDataSource.fetchComments(taskId);
    return result.map((e) => TaskCommentModel.fromJson(e as Map<String, dynamic>).toEntity()).toList();
  }

  @override
  Future<void> deleteComment(int taskId, int commentId) async {
    await remoteDataSource.deleteComment(taskId, commentId);
  }
}
