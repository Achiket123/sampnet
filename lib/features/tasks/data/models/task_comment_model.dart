import '../../domain/entities/task_comment_entity.dart';

class TaskCommentModel extends TaskCommentEntity {
  const TaskCommentModel({
    required super.id,
    required super.taskId,
    required super.userId,
    required super.userFirstName,
    required super.userLastName,
    required super.content,
    required super.createdAt,
  });

  factory TaskCommentModel.fromJson(Map<String, dynamic> json) {
    return TaskCommentModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
      taskId: json['task_id'] is String ? int.parse(json['task_id']) : json['task_id'] as int,
      userId: json['user_id'] is String ? int.parse(json['user_id']) : json['user_id'] as int,
      userFirstName: json['user_first_name'] ?? '',
      userLastName: json['user_last_name'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  TaskCommentEntity toEntity() {
    return TaskCommentEntity(
      id: id,
      taskId: taskId,
      userId: userId,
      userFirstName: userFirstName,
      userLastName: userLastName,
      content: content,
      createdAt: createdAt,
    );
  }
}
