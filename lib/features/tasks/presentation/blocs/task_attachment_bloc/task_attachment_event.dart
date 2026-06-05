part of 'task_attachment_bloc.dart';

abstract class TaskAttachmentEvent extends Equatable {
  const TaskAttachmentEvent();

  @override
  List<Object?> get props => [];
}

class FetchTaskAttachmentsEvent extends TaskAttachmentEvent {
  final String token;
  final int taskId;

  const FetchTaskAttachmentsEvent({required this.token, required this.taskId});

  @override
  List<Object?> get props => [token, taskId];
}

class AddAttachmentEvent extends TaskAttachmentEvent {
  final int taskId;
  final int fileId;
  final int uploadedBy;
  final String fileName;

  const AddAttachmentEvent({
    required this.taskId,
    required this.fileId,
    required this.uploadedBy,
    required this.fileName,
  });

  @override
  List<Object?> get props => [taskId, fileId, uploadedBy, fileName];
}
