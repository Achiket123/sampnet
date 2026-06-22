import 'package:bloc/bloc.dart';
import 'package:hackathon/features/tasks/domain/entities/task_entity.dart';
import 'package:hackathon/features/tasks/domain/use_cases/create_task_usecase.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:meta/meta.dart';

part 'create_task_event.dart';
part 'create_task_state.dart';

class CreateTaskBloc extends Bloc<CreateTaskEvent, CreateTaskState> {
  final CreateTaskUseCase _createTaskUsecase;
  CreateTaskBloc({required CreateTaskUseCase createTaskUsecase})
      : _createTaskUsecase = createTaskUsecase,
        super(CreateTaskInitial()) {
    on<CreateTask>((event, emit) async {
      emit(CreateTaskLoading());
      final result = await _createTaskUsecase.call(event.params);
      result.fold((l) => emit(CreateTaskFailure(error: l)),
          (r) => emit(CreateTaskSuccess(task: r)));
    });
  }
}
