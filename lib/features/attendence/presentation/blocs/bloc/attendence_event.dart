part of 'attendence_bloc.dart';

@immutable
sealed class AttendenceEvent {}

final class AttendenceCheckInEvent extends AttendenceEvent {
  final AttendenceParams params;
  AttendenceCheckInEvent({required this.params});
}

final class AttendenceCheckOutEvent extends AttendenceEvent {
  final AttendenceParams params;
  AttendenceCheckOutEvent({required this.params});
}

final class AttendenceGetEvent extends AttendenceEvent {
  final int userId;
  AttendenceGetEvent({required this.userId});
}
