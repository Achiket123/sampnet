part of 'get_employees_bloc.dart';

@immutable
sealed class GetEmployeesEvent {
  const GetEmployeesEvent();  
}

class GetEmployees extends GetEmployeesEvent {
  final String token;
  const GetEmployees({required this.token});
}

class GetTeams extends GetEmployeesEvent {
  final String token;
  const GetTeams({required this.token});
}
