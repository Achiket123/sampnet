import 'package:bloc/bloc.dart';
import 'package:hackathon/features/tasks/domain/entities/assignee_entity.dart';
import 'package:hackathon/features/tasks/domain/entities/team_entity.dart';
import 'package:hackathon/features/tasks/domain/use_cases/get_emp_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/get_project_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/task_get_team_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:meta/meta.dart';

part 'get_employees_event.dart';
part 'get_employees_state.dart';

class GetEmployeesBloc extends Bloc<GetEmployeesEvent, GetEmployeesState> {
  final GetEmployeesUseCase _getEmployeesUseCase;
  final TaskGetTeamUsecase _getTeamUseCase;
  GetEmployeesBloc(
      {required GetEmployeesUseCase getEmployeesUseCase,
      required GetProjectUseCase getProjectUseCase,
      required TaskGetTeamUsecase getTeamUseCase})
      : _getEmployeesUseCase = getEmployeesUseCase,
        _getTeamUseCase = getTeamUseCase,
        super(GetEmployeesInitial()) {
    on<GetEmployees>((event, emit) async {
      emit(GetEmployeesLoading());
      final result = await _getEmployeesUseCase.call(event.token);
      result.fold((l) => emit(GetEmployeesFailure(error: l)),
          (r) => emit(GetEmployeesSuccess(employees: r)));
    });

    on<GetTeams>((event, emit) async {
      emit(GetEmployeesLoading());
      final result = await _getTeamUseCase.call(event.token);
      result.fold((l) => emit(GetTeamsFailure(error: l)),
          (r) => emit(GetTeamsSuccess(teams: r)));
    });
  }
}
