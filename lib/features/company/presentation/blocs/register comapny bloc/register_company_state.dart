part of 'register_company_bloc.dart';

@immutable
sealed class RegisterCompanyState {}

final class RegisterCompanyInitial extends RegisterCompanyState {}
final class RegisterCompanyLoading extends RegisterCompanyState {}
final class RegisterCompanySuccess extends RegisterCompanyState {
  final Organisation organisation;
  RegisterCompanySuccess(this.organisation);
}
final class RegisterCompanyFailure extends RegisterCompanyState {
  final String message;
  RegisterCompanyFailure(this.message);
}
final class FetchEmployeeDataSuccess extends RegisterCompanyState {

}
final class FetchEmployeeDataFailure extends RegisterCompanyState {
  final String message;
  FetchEmployeeDataFailure(this.message);
}
