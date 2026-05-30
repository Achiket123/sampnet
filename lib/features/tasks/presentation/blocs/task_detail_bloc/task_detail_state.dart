import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';
import '../../../domain/entities/task_comment_entity.dart';
import '../../../domain/entities/task_attachment_entity.dart';

class TaskDetailState extends Equatable {
  final TaskEntity? task;
  final List<TaskCommentEntity> comments;
  final List<TaskAttachmentEntity> attachments;
  final bool isLoadingTask;
  final bool isLoadingComments;
  final bool isLoadingAttachments;
  final bool isSubmittingComment;
  final bool isUploadingAttachment;
  final String? taskError;
  final String? commentError;
  final String? attachmentError;

  const TaskDetailState({
    this.task,
    this.comments = const [],
    this.attachments = const [],
    this.isLoadingTask = true,
    this.isLoadingComments = true,
    this.isLoadingAttachments = true,
    this.isSubmittingComment = false,
    this.isUploadingAttachment = false,
    this.taskError,
    this.commentError,
    this.attachmentError,
  });

  factory TaskDetailState.initial() => const TaskDetailState();

  TaskDetailState copyWith({
    TaskEntity? task,
    List<TaskCommentEntity>? comments,
    List<TaskAttachmentEntity>? attachments,
    bool? isLoadingTask,
    bool? isLoadingComments,
    bool? isLoadingAttachments,
    bool? isSubmittingComment,
    bool? isUploadingAttachment,
    String? taskError,
    String? commentError,
    String? attachmentError,
    bool clearTaskError = false,
    bool clearCommentError = false,
    bool clearAttachmentError = false,
  }) {
    return TaskDetailState(
      task: task ?? this.task,
      comments: comments ?? this.comments,
      attachments: attachments ?? this.attachments,
      isLoadingTask: isLoadingTask ?? this.isLoadingTask,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      isLoadingAttachments: isLoadingAttachments ?? this.isLoadingAttachments,
      isSubmittingComment: isSubmittingComment ?? this.isSubmittingComment,
      isUploadingAttachment: isUploadingAttachment ?? this.isUploadingAttachment,
      taskError: clearTaskError ? null : (taskError ?? this.taskError),
      commentError: clearCommentError ? null : (commentError ?? this.commentError),
      attachmentError: clearAttachmentError ? null : (attachmentError ?? this.attachmentError),
    );
  }

  @override
  List<Object?> get props => [
        task,
        comments,
        attachments,
        isLoadingTask,
        isLoadingComments,
        isLoadingAttachments,
        isSubmittingComment,
        isUploadingAttachment,
        taskError,
        commentError,
        attachmentError,
      ];
}
