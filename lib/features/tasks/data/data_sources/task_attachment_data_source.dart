import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/data/models/task_attachment_model.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/services/api_client.dart';

abstract class TaskAttachmentRemoteDataSource {
  Future<Either<ErrorModel, List<TaskAttachmentModel>>> getTaskAttachments(
      int taskId);
  Future<Either<ErrorModel, TaskAttachmentModel>> addTaskAttachment(
      int taskId, int fileId, String fileName);
  Future<Either<ErrorModel, Unit>> removeTaskAttachment(
      int taskId, int attachmentId);
}

class TaskAttachmentRemoteDataSourceImpl
    implements TaskAttachmentRemoteDataSource {
  final ApiClient apiClient;
  TaskAttachmentRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Either<ErrorModel, List<TaskAttachmentModel>>> getTaskAttachments(
      int taskId) async {
    try {
      final response = await apiClient.get("/tasks/$taskId/attachments/");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List data = jsonDecode(response.body);
        return right(data.map((e) => TaskAttachmentModel.fromJson(e)).toList());
      }
      return left(
          ErrorModel(message: "Failed to fetch attachments: ${response.body}"));
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, TaskAttachmentModel>> addTaskAttachment(
      int taskId, int fileId, String fileName) async {
    try {
      final response = await apiClient.post(
        "/tasks/$taskId/attachments/",
        body: {'file_id': fileId, 'file_name': fileName},
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return right(TaskAttachmentModel.fromJson(jsonDecode(response.body)));
      }
      return left(
          ErrorModel(message: "Failed to add attachment: ${response.body}"));
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, Unit>> removeTaskAttachment(
      int taskId, int attachmentId) async {
    try {
      final response =
          await apiClient.delete("/tasks/$taskId/attachments/$attachmentId");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return right(unit);
      }
      return left(
          ErrorModel(message: "Failed to remove attachment: ${response.body}"));
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }
}
