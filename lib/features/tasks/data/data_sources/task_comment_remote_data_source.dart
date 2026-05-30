import 'dart:convert';
import 'package:hackathon/services/api_client.dart';

class TaskCommentRemoteDataSource {
  final ApiClient apiClient;
  TaskCommentRemoteDataSource({required this.apiClient});

  Future<Map<String, dynamic>> postComment(int taskId, String content) async {
    final response = await apiClient.post(
      "/tasks/$taskId/comments",
      body: {'content': content},
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw Exception("Failed to post comment. Status: ${response.statusCode}, Body: ${response.body}");
  }

  Future<List<dynamic>> fetchComments(int taskId) async {
    final response = await apiClient.get("/tasks/$taskId/comments");
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    throw Exception("Failed to fetch comments. Status: ${response.statusCode}");
  }

  Future<void> deleteComment(int taskId, int commentId) async {
    final response = await apiClient.delete("/tasks/$taskId/comments/$commentId");
    if (response.statusCode == 200) {
      return;
    }
    if (response.statusCode == 403) {
      throw Exception("Ownership failure: You cannot delete this comment.");
    }
    throw Exception("Failed to delete comment. Status: ${response.statusCode}");
  }
}
