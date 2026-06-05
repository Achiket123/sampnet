import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/employees/domain/repositories/employees_repository.dart';
import 'package:hackathon/features/employees/presentation/blocs/employee_profile_bloc/employee_profile_state.dart';

import 'package:hackathon/globals/error_handling/error_model.dart';

class EmployeeProfileBloc extends Bloc<EmployeeProfileEvent, EmployeeProfileState> {
  final EmployeesRepository repository;

  EmployeeProfileBloc({required this.repository}) : super(EmployeeProfileInitial()) {
    on<EmployeeProfileLoadRequested>(_onLoadRequested);
    on<EmployeeProfileDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onLoadRequested(
    EmployeeProfileLoadRequested event,
    Emitter<EmployeeProfileState> emit,
  ) async {
    emit(EmployeeProfileLoading());
    final result = await repository.getEmployeeById(event.employeeId);
    result.fold(
      (ErrorModel failure) => emit(EmployeeProfileError(failure.message)),
      (employee) => emit(EmployeeProfileLoaded(employee)),
    );
  }

  Future<void> _onDeleteRequested(
    EmployeeProfileDeleteRequested event,
    Emitter<EmployeeProfileState> emit,
  ) async {
    emit(EmployeeProfileLoading());
    final result = await repository.deleteEmployee(event.employeeId);
    result.fold(
      (ErrorModel failure) => emit(EmployeeProfileError(failure.message)),
      (_) => emit(EmployeeProfileDeleted()),
    );
  }
}
