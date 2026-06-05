import 'package:equatable/equatable.dart';
import 'package:hackathon/features/employees/domain/entities/employee_entity.dart';

abstract class EmployeeProfileEvent extends Equatable {
  const EmployeeProfileEvent();
  @override
  List<Object?> get props => [];
}

class EmployeeProfileLoadRequested extends EmployeeProfileEvent {
  final int employeeId;
  const EmployeeProfileLoadRequested(this.employeeId);
  @override
  List<Object?> get props => [employeeId];
}

class EmployeeProfileDeleteRequested extends EmployeeProfileEvent {
  final int employeeId;
  const EmployeeProfileDeleteRequested(this.employeeId);
  @override
  List<Object?> get props => [employeeId];
}

abstract class EmployeeProfileState extends Equatable {
  const EmployeeProfileState();
  @override
  List<Object?> get props => [];
}

class EmployeeProfileInitial extends EmployeeProfileState {}
class EmployeeProfileLoading extends EmployeeProfileState {}
class EmployeeProfileLoaded extends EmployeeProfileState {
  final EmployeeEntity employee;
  const EmployeeProfileLoaded(this.employee);
  @override
  List<Object?> get props => [employee];
}
class EmployeeProfileError extends EmployeeProfileState {
  final String message;
  const EmployeeProfileError(this.message);
  @override
  List<Object?> get props => [message];
}

class EmployeeProfileDeleted extends EmployeeProfileState {}
