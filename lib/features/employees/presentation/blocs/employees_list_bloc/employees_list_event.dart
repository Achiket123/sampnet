import 'package:equatable/equatable.dart';

abstract class EmployeesListEvent extends Equatable {
  const EmployeesListEvent();

  @override
  List<Object?> get props => [];
}

class EmployeesListLoadRequested extends EmployeesListEvent {
  final int organisationId;
  const EmployeesListLoadRequested(this.organisationId);

  @override
  List<Object?> get props => [organisationId];
}

class EmployeesSearchQueryChanged extends EmployeesListEvent {
  final String query;
  const EmployeesSearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class EmployeesSearchCleared extends EmployeesListEvent {}

class EmployeeDeleteRequested extends EmployeesListEvent {
  final int employeeId;
  const EmployeeDeleteRequested(this.employeeId);

  @override
  List<Object?> get props => [employeeId];
}

class EmployeeMakeManagerRequested extends EmployeesListEvent {
  final int employeeId;
  final int organisationId;
  final String type;
  final String salary;

  const EmployeeMakeManagerRequested({
    required this.employeeId,
    required this.organisationId,
    required this.type,
    required this.salary,
  });

  @override
  List<Object?> get props => [employeeId, organisationId, type, salary];
}

class EmployeesListRefreshRequested extends EmployeesListEvent {
  final int organisationId;
  const EmployeesListRefreshRequested(this.organisationId);

  @override
  List<Object?> get props => [organisationId];
}

class EmployeeUpdateRequested extends EmployeesListEvent {
  final int employeeId;
  final String type;
  final String salary;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? profilePic;

  const EmployeeUpdateRequested({
    required this.employeeId,
    required this.type,
    required this.salary,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.profilePic,
  });

  @override
  List<Object?> get props => [employeeId, type, salary, firstName, lastName, phoneNumber, profilePic];
}
