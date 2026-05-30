import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/data/models/task_comment_model.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:http/http.dart' as http;

abstract class TaskCommentRemoteDataSource {
  Future<Either<ErrorModel, List<TaskCommentModel>>> getTaskComments(String token, String taskId);
  Future<Either<ErrorModel, TaskCommentModel>> addTaskComment(String token, String taskId, String content);
}

class TaskCommentRemoteDataSourceImpl implements TaskCommentRemoteDataSource {
  final http.Client client;
  TaskCommentRemoteDataSourceImpl({required this.client});

  @override
  Future<Either<ErrorModel, List<TaskCommentModel>>> getTaskComments(String token, String taskId) async {
    try {
      final url = Uri.parse("${ApiConstants.baseUrl}/task-comments/$taskId");
      final response = await client.get(url, headers: {'Authorization': token});
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List data = jsonDecode(response.body)['comments'];
        return right(data.map((e) => TaskCommentModel.fromJson(e)).toList());
      }
      throw Exception(response.body);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, TaskCommentModel>> addTaskComment(String token, String taskId, String content) async {
    try {
      final url = Uri.parse("${ApiConstants.baseUrl}/task-comments");
      final response = await client.post(
        url,
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
        body: jsonEncode({'task_id': taskId, 'content': content}),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return right(TaskCommentModel.fromJson(jsonDecode(response.body)['comment']));
      }
      throw Exception(response.body);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }
}
