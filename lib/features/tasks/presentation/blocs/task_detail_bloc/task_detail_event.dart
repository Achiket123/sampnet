import 'package:equatable/equatable.dart';

sealed class TaskDetailEvent extends Equatable {
  const TaskDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadTaskDetail extends TaskDetailEvent {
  final int taskId;
  const LoadTaskDetail({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class UpdateTaskStatus extends TaskDetailEvent {
  final int taskId;
  final String status;
  const UpdateTaskStatus({required this.taskId, required this.status});

  @override
  List<Object?> get props => [taskId, status];
}

class AddComment extends TaskDetailEvent {
  final String content;
  const AddComment({required this.content});

  @override
  List<Object?> get props => [content];
}

class DeleteComment extends TaskDetailEvent {
  final int commentId;
  const DeleteComment({required this.commentId});

  @override
  List<Object?> get props => [commentId];
}

class AddAttachment extends TaskDetailEvent {
  final int fileId;
  final String fileName;
  const AddAttachment({required this.fileId, required this.fileName});

  @override
  List<Object?> get props => [fileId, fileName];
}

class RemoveAttachment extends TaskDetailEvent {
  final int attachmentId;
  const RemoveAttachment({required this.attachmentId});

  @override
  List<Object?> get props => [attachmentId];
}
