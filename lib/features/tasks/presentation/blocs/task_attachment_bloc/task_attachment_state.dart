part of 'task_attachment_bloc.dart';

abstract class TaskAttachmentState extends Equatable {
  const TaskAttachmentState();

  @override
  List<Object?> get props => [];
}

class TaskAttachmentInitial extends TaskAttachmentState {}

class TaskAttachmentLoading extends TaskAttachmentState {}

class TaskAttachmentsLoaded extends TaskAttachmentState {
  final List<TaskAttachmentEntity> attachments;

  const TaskAttachmentsLoaded({required this.attachments});

  @override
  List<Object?> get props => [attachments];
}

class TaskAttachmentError extends TaskAttachmentState {
  final ErrorModel error;

  const TaskAttachmentError({required this.error});

  @override
  List<Object?> get props => [error];
}
