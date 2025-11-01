part of 'validate_employee_bloc.dart';

@immutable
sealed class ValidateEmployeeEvent {}

class ValidateEmployee extends ValidateEmployeeEvent {
  final String token;
  ValidateEmployee({required this.token});
}
