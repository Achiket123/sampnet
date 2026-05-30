part of 'task_attachment_bloc.dart';

abstract class TaskAttachmentEvent extends Equatable {
  const TaskAttachmentEvent();

  @override
  List<Object?> get props => [];
}

class FetchTaskAttachmentsEvent extends TaskAttachmentEvent {
  final String token;
  final String taskId;

  const FetchTaskAttachmentsEvent({required this.token, required this.taskId});

  @override
  List<Object?> get props => [token, taskId];
}

class AddAttachmentEvent extends TaskAttachmentEvent {
  final String token;
  final String taskId;
  final String filePath;

  const AddAttachmentEvent({required this.token, required this.taskId, required this.filePath});

  @override
  List<Object?> get props => [token, taskId, filePath];
}
