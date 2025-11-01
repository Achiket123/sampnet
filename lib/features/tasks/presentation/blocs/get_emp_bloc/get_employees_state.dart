part of 'get_employees_bloc.dart';

@immutable
sealed class GetEmployeesState {}

final class GetEmployeesInitial extends GetEmployeesState {}

final class GetEmployeesLoading extends GetEmployeesState {

}

final class GetEmployeesSuccess extends GetEmployeesState {
  final List<AssigneeEntity> employees;
  GetEmployeesSuccess({required this.employees});
}

final class GetEmployeesFailure extends GetEmployeesState {
  final ErrorModel error;
  GetEmployeesFailure({required this.error});
}


final class GetTeamsLoading extends GetEmployeesState {}

final class GetTeamsSuccess extends GetEmployeesState {
  final List<TeamEntity> teams;
  GetTeamsSuccess({required this.teams});
}

final class GetTeamsFailure extends GetEmployeesState {
  final ErrorModel error;
  GetTeamsFailure({required this.error});
}
