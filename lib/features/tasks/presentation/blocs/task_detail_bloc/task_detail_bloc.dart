import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hackathon/features/tasks/domain/entities/task_entity.dart';
import 'package:hackathon/features/tasks/domain/use_cases/get_task_detail_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/delete_task_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

part 'task_detail_event.dart';
part 'task_detail_state.dart';

class TaskDetailBloc extends Bloc<TaskDetailEvent, TaskDetailState> {
  final GetTaskDetailUseCase _getTaskDetailUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;

  TaskDetailBloc({
    required GetTaskDetailUseCase getTaskDetailUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
  })  : _getTaskDetailUseCase = getTaskDetailUseCase,
        _deleteTaskUseCase = deleteTaskUseCase,
        super(TaskDetailInitial()) {
    on<FetchTaskDetailEvent>((event, emit) async {
      emit(TaskDetailLoading());
      final result = await _getTaskDetailUseCase(event.token, event.id);
      result.fold(
        (l) => emit(TaskDetailError(error: l)),
        (r) => emit(TaskDetailLoaded(task: r)),
      );
    });

    on<DeleteTaskEvent>((event, emit) async {
      emit(TaskDetailLoading());
      final result = await _deleteTaskUseCase(event.token, event.id);
      result.fold(
        (l) => emit(TaskDetailError(error: l)),
        (_) => emit(TaskDeleted()),
      );
    });
  }
}
