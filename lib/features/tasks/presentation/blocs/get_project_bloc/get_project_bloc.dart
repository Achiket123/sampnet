import 'package:bloc/bloc.dart';
import 'package:hackathon/features/tasks/domain/entities/project_entity.dart';
import 'package:hackathon/features/tasks/domain/use_cases/get_project_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:meta/meta.dart';

part 'get_project_event.dart';
part 'get_project_state.dart';

class GetProjectBloc extends Bloc<GetProjectEvent, GetProjectState> {
  final GetProjectUseCase _getProjectUseCase;
  GetProjectBloc({required GetProjectUseCase getProjectUseCase}) : 
    _getProjectUseCase = getProjectUseCase,
  super(GetProjectInitial()) {
    on<GetProjectEvent>((event, emit) {
      
      emit(GetProjectsLoading());
    });
    on<GetProjects>((event, emit) async {
      final result = await _getProjectUseCase.call(event.token);
      result.fold((l) => emit(GetProjectsFailure(error: l)), (r) => emit(GetProjectsSuccess(projects: r)));
    });
  }
}
