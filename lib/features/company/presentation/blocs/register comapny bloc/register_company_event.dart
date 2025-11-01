part of 'register_company_bloc.dart';

@immutable
sealed class RegisterCompanyEvent {}

class RegisterCompany extends RegisterCompanyEvent {
  final RegisterCompanyParams params;
  RegisterCompany(this.params);
}

class FetchEmployeeData extends RegisterCompanyEvent {
  final String employeeId;
  FetchEmployeeData(this.employeeId);
}
