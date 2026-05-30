import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/data/data_sources/task_comment_data_source.dart';
import 'package:hackathon/features/tasks/domain/entities/task_comment_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_comment_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class TaskCommentRepositoryImpl implements TaskCommentRepository {
  final TaskCommentRemoteDataSource remoteDataSource;
  TaskCommentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ErrorModel, List<TaskCommentEntity>>> getTaskComments(String token, String taskId) async {
    return await remoteDataSource.getTaskComments(token, taskId);
  }

  @override
  Future<Either<ErrorModel, TaskCommentEntity>> addTaskComment(String token, String taskId, String content) async {
    return await remoteDataSource.addTaskComment(token, taskId, content);
  }
}
