import 'package:bloc/bloc.dart';
import 'package:hackathon/features/tasks/domain/entities/task_entity.dart';
import 'package:hackathon/features/tasks/domain/use_cases/fetch_task_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/update_task_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:meta/meta.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final FetchTaskUsecase _fetchTasksUsecase;
  final UpdateTaskUsecase _updateTaskUsecase;
  TaskBloc(
      {required FetchTaskUsecase fetchTasksUsecase,
      required UpdateTaskUsecase updateTaskUsecase})
      : _fetchTasksUsecase = fetchTasksUsecase,
        _updateTaskUsecase = updateTaskUsecase,
        super(TaskInitial()) {
    on<TaskEvent>((event, emit) {
      emit(TaskLoading());
    });

    on<FetchTasksEvent>((event, emit) async {
      final result = await _fetchTasksUsecase(event.token);
      result.fold(
          (l) => emit(TaskError(error: l)), (r) => emit(TaskSuccess(tasks: r)));
    });
    on<UpdateTaskEvent>((event, emit) async {
      final result = await _updateTaskUsecase(event.params);
      result.fold(
          (l) => emit(TaskError(error: l)), (r) => emit(TaskSuccess(tasks: r)));
    });
  }
}
