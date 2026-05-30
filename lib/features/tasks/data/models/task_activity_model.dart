import 'package:hackathon/features/tasks/domain/entities/task_activity_entity.dart';

class TaskActivityModel extends TaskActivityEntity {
  const TaskActivityModel({
    required super.id,
    required super.taskId,
    required super.userId,
    required super.action,
    super.oldValue,
    super.newValue,
    required super.timestamp,
  });

  factory TaskActivityModel.fromJson(Map<String, dynamic> json) {
    return TaskActivityModel(
      id: json['id'].toString(),
      taskId: json['task_id'].toString(),
      userId: json['user_id'].toString(),
      action: json['action'],
      oldValue: json['old_value'],
      newValue: json['new_value'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_id': taskId,
      'user_id': userId,
      'action': action,
      'old_value': oldValue,
      'new_value': newValue,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
