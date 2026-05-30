import 'package:equatable/equatable.dart';

class TaskCommentEntity extends Equatable {
  final String id;
  final String taskId;
  final String userId;
  final String content;
  final DateTime createdAt;

  const TaskCommentEntity({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, taskId, userId, content, createdAt];
}
