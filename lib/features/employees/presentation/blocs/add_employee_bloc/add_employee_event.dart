import 'package:equatable/equatable.dart';

abstract class AddEmployeeEvent extends Equatable {
  const AddEmployeeEvent();

  @override
  List<Object?> get props => [];
}

class AddEmployeeFormFirstNameChanged extends AddEmployeeEvent {
  final String value;
  const AddEmployeeFormFirstNameChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class AddEmployeeFormLastNameChanged extends AddEmployeeEvent {
  final String value;
  const AddEmployeeFormLastNameChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class AddEmployeeFormEmailChanged extends AddEmployeeEvent {
  final String value;
  const AddEmployeeFormEmailChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class AddEmployeeFormPhoneChanged extends AddEmployeeEvent {
  final String value;
  const AddEmployeeFormPhoneChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class AddEmployeeFormEmploymentIdChanged extends AddEmployeeEvent {
  final String value;
  const AddEmployeeFormEmploymentIdChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class AddEmployeeSubmitRequested extends AddEmployeeEvent {}

class AddEmployeeFormReset extends AddEmployeeEvent {}
