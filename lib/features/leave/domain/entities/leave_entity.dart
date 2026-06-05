import 'package:equatable/equatable.dart';

class Leave extends Equatable {
  final int id;
  final int employeeId;
  final int organisationId;
  final int managerId;
  final String leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;
  final String reason;
  final String status;
  final String managerNote;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Leave({
    required this.id,
    required this.employeeId,
    required this.organisationId,
    required this.managerId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.reason,
    required this.status,
    required this.managerNote,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        employeeId,
        organisationId,
        managerId,
        leaveType,
        startDate,
        endDate,
        totalDays,
        reason,
        status,
        managerNote,
        createdAt,
        updatedAt,
      ];
}
