part of 'validate_employee_bloc.dart';

@immutable
sealed class ValidateEmployeeState {}

final class ValidateEmployeeInitial extends ValidateEmployeeState {}

class ValidateEmployeeLoading extends ValidateEmployeeState {}

class ValidateEmployeeSuccess extends ValidateEmployeeState {
  final bool isValid;
  ValidateEmployeeSuccess({required this.isValid});
}

class ValidateEmployeeFailure extends ValidateEmployeeState {
  final ErrorModel error;
  ValidateEmployeeFailure({required this.error});
}
