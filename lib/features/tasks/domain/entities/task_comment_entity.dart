import 'package:equatable/equatable.dart';

class TaskCommentEntity extends Equatable {
  final int id;
  final int taskId;
  final int userId;
  final String userFirstName;
  final String userLastName;
  final String content;
  final DateTime createdAt;

  const TaskCommentEntity({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.userFirstName,
    required this.userLastName,
    required this.content,
    required this.createdAt,
  });

  String get displayName => "$userFirstName $userLastName";

  @override
  List<Object?> get props => [id, taskId, userId, userFirstName, userLastName, content, createdAt];
}
