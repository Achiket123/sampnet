import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/tasks/domain/use_cases/fetch_task_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/update_task_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/add_task_comment_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/get_task_comments_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/delete_task_comment_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/add_task_attachment_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/get_task_attachments_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/remove_task_attachment_usecase.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_repository.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'task_detail_event.dart';
import 'task_detail_state.dart';

class TaskDetailBloc extends Bloc<TaskDetailEvent, TaskDetailState> {
  final FetchTaskByIdUsecase getTaskUsecase;
  final UpdateTaskUsecase updateTaskUsecase;
  final AddTaskCommentUseCase addTaskCommentUsecase;
  final GetTaskCommentsUseCase getTaskCommentsUsecase;
  final DeleteTaskCommentUseCase deleteTaskCommentUsecase;
  final AddTaskAttachmentUseCase addTaskAttachmentUsecase;
  final GetTaskAttachmentsUseCase getTaskAttachmentsUsecase;
  final RemoveTaskAttachmentUseCase removeTaskAttachmentUsecase;

  TaskDetailBloc({
    required this.getTaskUsecase,
    required this.updateTaskUsecase,
    required this.addTaskCommentUsecase,
    required this.getTaskCommentsUsecase,
    required this.deleteTaskCommentUsecase,
    required this.addTaskAttachmentUsecase,
    required this.getTaskAttachmentsUsecase,
    required this.removeTaskAttachmentUsecase,
  }) : super(TaskDetailState.initial()) {
    on<LoadTaskDetail>(_onLoadTaskDetail);
    on<UpdateTaskStatus>(_onUpdateTaskStatus);
    on<AddComment>(_onAddComment);
    on<DeleteComment>(_onDeleteComment);
    on<AddAttachment>(_onAddAttachment);
    on<RemoveAttachment>(_onRemoveAttachment);
  }

  Future<void> _onLoadTaskDetail(LoadTaskDetail event, Emitter<TaskDetailState> emit) async {
    emit(state.copyWith(isLoadingTask: true, isLoadingComments: true, isLoadingAttachments: true));
    final token = getIt<User>().token!;
    
    try {
      final results = await Future.wait([
        getTaskUsecase.call(FetchTaskByIdParams(token, event.taskId.toString())),
        getTaskCommentsUsecase.call(event.taskId),
        getTaskAttachmentsUsecase.call(event.taskId),
      ]);

      final taskResult = results[0];
      final commentsResult = results[1];
      final attachmentsResult = results[2];

      emit(state.copyWith(
        isLoadingTask: false,
        isLoadingComments: false,
        isLoadingAttachments: false,
        task: taskResult.fold((l) {
          throw Exception(l.message);
        }, (r) => r),
        comments: commentsResult as dynamic,
        attachments: attachmentsResult as dynamic,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingTask: false,
        isLoadingComments: false,
        isLoadingAttachments: false,
        taskError: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateTaskStatus(UpdateTaskStatus event, Emitter<TaskDetailState> emit) async {
    try {
      final result = await updateTaskUsecase.call(UpdateTaskParams(id: event.taskId, status: event.status));
      result.fold(
        (l) => emit(state.copyWith(taskError: l.message)),
        (r) {
          final updatedTask = r.firstWhere((element) => element.id == event.taskId);
          emit(state.copyWith(task: updatedTask, clearTaskError: true));
        },
      );
    } catch (e) {
      emit(state.copyWith(taskError: e.toString()));
    }
  }

  Future<void> _onAddComment(AddComment event, Emitter<TaskDetailState> emit) async {
    if (event.content.trim().isEmpty || state.task == null) return;
    
    emit(state.copyWith(isSubmittingComment: true, clearCommentError: true));
    final userId = getIt<User>().user!.id;

    try {
      final result = await addTaskCommentUsecase.call(state.task!.id!, userId, event.content);
      emit(state.copyWith(
        isSubmittingComment: false,
        comments: [...state.comments, result],
      ));
    } catch (e) {
      emit(state.copyWith(isSubmittingComment: false, commentError: e.toString()));
    }
  }

  Future<void> _onDeleteComment(DeleteComment event, Emitter<TaskDetailState> emit) async {
    if (state.task == null) return;
    
    try {
      await deleteTaskCommentUsecase.call(state.task!.id!, event.commentId);
      emit(state.copyWith(
        comments: state.comments.where((c) => c.id != event.commentId).toList(),
        clearCommentError: true,
      ));
    } catch (e) {
      emit(state.copyWith(commentError: e.toString()));
    }
  }

  Future<void> _onAddAttachment(AddAttachment event, Emitter<TaskDetailState> emit) async {
    if (state.task == null) return;
    
    emit(state.copyWith(isUploadingAttachment: true, clearAttachmentError: true));
    final userId = getIt<User>().user!.id;

    try {
      final result = await addTaskAttachmentUsecase.call(state.task!.id!, event.fileId, userId, event.fileName);
      emit(state.copyWith(
        isUploadingAttachment: false,
        attachments: [...state.attachments, result],
      ));
    } catch (e) {
      emit(state.copyWith(isUploadingAttachment: false, attachmentError: e.toString()));
    }
  }

  Future<void> _onRemoveAttachment(RemoveAttachment event, Emitter<TaskDetailState> emit) async {
    if (state.task == null) return;

    try {
      await removeTaskAttachmentUsecase.call(state.task!.id!, event.attachmentId);
      emit(state.copyWith(
        attachments: state.attachments.where((a) => a.id != event.attachmentId).toList(),
        clearAttachmentError: true,
      ));
    } catch (e) {
      emit(state.copyWith(attachmentError: e.toString()));
    }
  }
}
