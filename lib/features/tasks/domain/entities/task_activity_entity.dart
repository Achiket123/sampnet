import 'package:equatable/equatable.dart';

class TaskActivityEntity extends Equatable {
  final String id;
  final String taskId;
  final String userId;
  final String action;
  final String? oldValue;
  final String? newValue;
  final DateTime timestamp;

  const TaskActivityEntity({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.action,
    this.oldValue,
    this.newValue,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, taskId, userId, action, oldValue, newValue, timestamp];
}
