import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hackathon/features/tasks/domain/entities/task_comment_entity.dart';
import 'package:hackathon/features/tasks/domain/use_cases/get_task_comments_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/add_task_comment_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

part 'task_comment_event.dart';
part 'task_comment_state.dart';

class TaskCommentBloc extends Bloc<TaskCommentEvent, TaskCommentState> {
  final GetTaskCommentsUseCase _getTaskCommentsUseCase;
  final AddTaskCommentUseCase _addTaskCommentUseCase;

  TaskCommentBloc({
    required GetTaskCommentsUseCase getTaskCommentsUseCase,
    required AddTaskCommentUseCase addTaskCommentUseCase,
  })  : _getTaskCommentsUseCase = getTaskCommentsUseCase,
        _addTaskCommentUseCase = addTaskCommentUseCase,
        super(TaskCommentInitial()) {
    on<FetchTaskCommentsEvent>((event, emit) async {
      emit(TaskCommentLoading());
      final result = await _getTaskCommentsUseCase(event.taskId);
      result.fold(
        (l) => emit(TaskCommentError(error: l)),
        (r) => emit(TaskCommentsLoaded(comments: r)),
      );
    });

    on<AddCommentEvent>((event, emit) async {
      final result = await _addTaskCommentUseCase(event.taskId, event.userId, event.content);
      result.fold(
        (l) => emit(TaskCommentError(error: l)),
        (r) {
          if (state is TaskCommentsLoaded) {
            final updatedComments = List<TaskCommentEntity>.from((state as TaskCommentsLoaded).comments)..add(r);
            emit(TaskCommentsLoaded(comments: updatedComments));
          } else {
            emit(TaskCommentsLoaded(comments: [r]));
          }
        },
      );
    });
  }
}
