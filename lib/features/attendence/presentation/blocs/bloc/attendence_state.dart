part of 'attendence_bloc.dart';

@immutable
sealed class AttendenceState {}

final class AttendenceInitial extends AttendenceState {}

final class AttendenceLoading extends AttendenceState {}

final class AttendenceSuccess extends AttendenceState {
  final String message;
  final AttendenceEntity attendenceEntity;
  AttendenceSuccess({required this.message,required this.attendenceEntity});
}

final class AttendenceFailure extends AttendenceState {
  final ErrorModel errorModel;
  AttendenceFailure({required this.errorModel});
}

final class AttendenceGetSuccess extends AttendenceState {
  final AttendenceEntity attendenceEntity;
  AttendenceGetSuccess({required this.attendenceEntity});
}
