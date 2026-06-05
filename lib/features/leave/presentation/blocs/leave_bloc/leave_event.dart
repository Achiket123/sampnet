import 'package:equatable/equatable.dart';

abstract class LeaveEvent extends Equatable {
  const LeaveEvent();

  @override
  List<Object?> get props => [];
}

class RequestLeaveEvent extends LeaveEvent {
  final int organisationId;
  final String leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;

  const RequestLeaveEvent({
    required this.organisationId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
  });

  @override
  List<Object?> get props => [organisationId, leaveType, startDate, endDate, reason];
}

class GetMyLeavesEvent extends LeaveEvent {
  final int offset;
  const GetMyLeavesEvent({this.offset = 0});

  @override
  List<Object?> get props => [offset];
}

class GetOrganisationLeavesEvent extends LeaveEvent {
  final int organisationId;
  final String status;
  final int offset;

  const GetOrganisationLeavesEvent({
    required this.organisationId,
    this.status = '',
    this.offset = 0,
  });

  @override
  List<Object?> get props => [organisationId, status, offset];
}

class ApproveLeaveEvent extends LeaveEvent {
  final int leaveId;
  final String? managerNote;

  const ApproveLeaveEvent({required this.leaveId, this.managerNote});

  @override
  List<Object?> get props => [leaveId, managerNote];
}

class RejectLeaveEvent extends LeaveEvent {
  final int leaveId;
  final String? managerNote;

  const RejectLeaveEvent({required this.leaveId, this.managerNote});

  @override
  List<Object?> get props => [leaveId, managerNote];
}

class CancelLeaveEvent extends LeaveEvent {
  final int leaveId;
  const CancelLeaveEvent({required this.leaveId});

  @override
  List<Object?> get props => [leaveId];
}
