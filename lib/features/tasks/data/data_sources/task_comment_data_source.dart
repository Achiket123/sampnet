import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/data/models/task_comment_model.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/services/api_client.dart';

abstract class TaskCommentRemoteDataSource {
  Future<Either<ErrorModel, List<TaskCommentModel>>> getTaskComments(int taskId);
  Future<Either<ErrorModel, TaskCommentModel>> addTaskComment(int taskId, String content);
  Future<Either<ErrorModel, Unit>> deleteTaskComment(int taskId, int commentId);
}

class TaskCommentRemoteDataSourceImpl implements TaskCommentRemoteDataSource {
  final ApiClient apiClient;
  TaskCommentRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Either<ErrorModel, List<TaskCommentModel>>> getTaskComments(int taskId) async {
    try {
      final response = await apiClient.get("/tasks/$taskId/comments");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List data = jsonDecode(response.body);
        return right(data.map((e) => TaskCommentModel.fromJson(e)).toList());
      }
      return left(ErrorModel(message: "Failed to fetch comments: ${response.body}"));
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, TaskCommentModel>> addTaskComment(int taskId, String content) async {
    try {
      final response = await apiClient.post(
        "/tasks/$taskId/comments",
        body: {'content': content},
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return right(TaskCommentModel.fromJson(jsonDecode(response.body)));
      }
      return left(ErrorModel(message: "Failed to add comment: ${response.body}"));
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, Unit>> deleteTaskComment(int taskId, int commentId) async {
    try {
      final response = await apiClient.delete("/tasks/$taskId/comments/$commentId");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return right(unit);
      }
      return left(ErrorModel(message: "Failed to delete comment: ${response.body}"));
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }
}
