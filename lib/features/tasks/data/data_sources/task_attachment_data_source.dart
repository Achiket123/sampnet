import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/data/models/task_attachment_model.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:http/http.dart' as http;

abstract class TaskAttachmentRemoteDataSource {
  Future<Either<ErrorModel, List<TaskAttachmentModel>>> getTaskAttachments(String token, String taskId);
  Future<Either<ErrorModel, TaskAttachmentModel>> addTaskAttachment(String token, String taskId, String filePath);
}

class TaskAttachmentRemoteDataSourceImpl implements TaskAttachmentRemoteDataSource {
  final http.Client client;
  TaskAttachmentRemoteDataSourceImpl({required this.client});

  @override
  Future<Either<ErrorModel, List<TaskAttachmentModel>>> getTaskAttachments(String token, String taskId) async {
    try {
      final url = Uri.parse("${ApiConstants.baseUrl}/task-attachments/$taskId");
      final response = await client.get(url, headers: {'Authorization': token});
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List data = jsonDecode(response.body)['attachments'];
        return right(data.map((e) => TaskAttachmentModel.fromJson(e)).toList());
      }
      throw Exception(response.body);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, TaskAttachmentModel>> addTaskAttachment(String token, String taskId, String filePath) async {
    // Note: This would typically be a multipart request
    try {
      final url = Uri.parse("${ApiConstants.baseUrl}/task-attachments");
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = token;
      request.fields['task_id'] = taskId;
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return right(TaskAttachmentModel.fromJson(jsonDecode(response.body)['attachment']));
      }
      throw Exception(response.body);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }
}
