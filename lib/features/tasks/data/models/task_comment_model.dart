import 'package:hackathon/features/tasks/domain/entities/task_comment_entity.dart';

class TaskCommentModel extends TaskCommentEntity {
  const TaskCommentModel({
    required super.id,
    required super.taskId,
    required super.userId,
    required super.content,
    required super.createdAt,
  });

  factory TaskCommentModel.fromJson(Map<String, dynamic> json) {
    return TaskCommentModel(
      id: json['id'].toString(),
      taskId: json['task_id'].toString(),
      userId: json['user_id'].toString(),
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_id': taskId,
      'user_id': userId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
