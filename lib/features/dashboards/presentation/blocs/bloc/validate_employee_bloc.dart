import 'package:bloc/bloc.dart';
import 'package:hackathon/features/dashboards/domain/use_cases/validate_emp_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:meta/meta.dart';

part 'validate_employee_event.dart';
part 'validate_employee_state.dart';

class ValidateEmployeeBloc extends Bloc<ValidateEmployeeEvent, ValidateEmployeeState> {
  final ValidateEmpUsecase _usecase;
  ValidateEmployeeBloc({required ValidateEmpUsecase usecase}) :
  _usecase = usecase,
  super(ValidateEmployeeInitial()) {
    on<ValidateEmployeeEvent>((event, emit) {
      emit(ValidateEmployeeLoading());
      });

      on<ValidateEmployee>((event, emit) async {
        final result = await _usecase(event.token);
        result.fold((l) => emit(ValidateEmployeeFailure(error: l)), (r) => emit(ValidateEmployeeSuccess(isValid: r)));
      });
  }
}
