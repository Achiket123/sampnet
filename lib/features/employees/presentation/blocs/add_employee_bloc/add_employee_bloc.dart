import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/employees/domain/repositories/employees_repository.dart';
import 'package:hackathon/features/employees/presentation/blocs/add_employee_bloc/add_employee_event.dart';
import 'package:hackathon/features/employees/presentation/blocs/add_employee_bloc/add_employee_state.dart';

import 'package:hackathon/globals/error_handling/error_model.dart';

class AddEmployeeBloc extends Bloc<AddEmployeeEvent, AddEmployeeState> {
  final EmployeesRepository repository;

  AddEmployeeBloc({required this.repository}) : super(const AddEmployeeState()) {
    on<AddEmployeeFormFirstNameChanged>((event, emit) => emit(state.copyWith(firstName: event.value, firstNameError: null)));
    on<AddEmployeeFormLastNameChanged>((event, emit) => emit(state.copyWith(lastName: event.value, lastNameError: null)));
    on<AddEmployeeFormEmailChanged>((event, emit) => emit(state.copyWith(email: event.value, emailError: null)));
    on<AddEmployeeFormPhoneChanged>((event, emit) => emit(state.copyWith(phoneNumber: event.value, phoneError: null)));
    on<AddEmployeeFormEmploymentIdChanged>((event, emit) => emit(state.copyWith(employmentId: event.value, employmentIdError: null)));
    
    on<AddEmployeeSubmitRequested>(_onSubmitRequested);
    on<AddEmployeeFormReset>((event, emit) => emit(const AddEmployeeState()));
  }

  Future<void> _onSubmitRequested(
    AddEmployeeSubmitRequested event,
    Emitter<AddEmployeeState> emit,
  ) async {
    // Validation
    String? fNameError = state.firstName.isEmpty ? "Required" : null;
    String? lNameError = state.lastName.isEmpty ? "Required" : null;
    String? emailErr = state.email.isEmpty ? "Required" : null;
    if (emailErr == null && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(state.email)) {
      emailErr = "Invalid format";
    }
    String? pError = state.phoneNumber.isEmpty ? "Required" : null;
    String? eIdError = state.employmentId.isEmpty ? "Required" : null;

    if (fNameError != null || lNameError != null || emailErr != null || pError != null || eIdError != null) {
      emit(state.copyWith(
        firstNameError: fNameError,
        lastNameError: lNameError,
        emailError: emailErr,
        phoneError: pError,
        employmentIdError: eIdError,
      ));
      return;
    }

    emit(state.copyWith(status: AddEmployeeStatus.submitting));

    final result = await repository.addEmployee(
      firstName: state.firstName,
      lastName: state.lastName,
      email: state.email,
      phoneNumber: state.phoneNumber,
      employmentId: int.tryParse(state.employmentId) ?? 0,
    );

    result.fold(
      (ErrorModel failure) => emit(state.copyWith(
        status: AddEmployeeStatus.error,
        failureMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: AddEmployeeStatus.submitted)),
    );
  }
}
