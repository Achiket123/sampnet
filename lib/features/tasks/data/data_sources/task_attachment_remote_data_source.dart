import 'dart:convert';
import 'package:hackathon/services/api_client.dart';

class TaskAttachmentRemoteDataSource {
  final ApiClient apiClient;
  TaskAttachmentRemoteDataSource({required this.apiClient});

  Future<Map<String, dynamic>> postAttachment(int taskId, int fileId, String fileName) async {
    final response = await apiClient.post(
      "/tasks/$taskId/attachments",
      body: {'file_id': fileId, 'file_name': fileName},
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw Exception("Failed to post attachment. Status: ${response.statusCode}");
  }

  Future<List<dynamic>> fetchAttachments(int taskId) async {
    final response = await apiClient.get("/tasks/$taskId/attachments");
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    throw Exception("Failed to fetch attachments. Status: ${response.statusCode}");
  }

  Future<void> removeAttachment(int taskId, int attachmentId) async {
    final response = await apiClient.delete("/tasks/$taskId/attachments/$attachmentId");
    if (response.statusCode == 200) {
      return;
    }
    if (response.statusCode == 403) {
      throw Exception("Ownership failure: You cannot remove this attachment.");
    }
    throw Exception("Failed to remove attachment. Status: ${response.statusCode}");
  }
}
