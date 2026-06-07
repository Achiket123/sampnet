import 'package:equatable/equatable.dart';
import 'package:hackathon/features/employees/domain/entities/employee_entity.dart';

class AnalyticsAttendanceBlockEntity extends Equatable {
  final int presentDays;
  final int absentDays;
  final int totalWorkingDays;
  final double attendanceRate;
  final String averageCheckInTime;
  final int averageDurationMinutes;
  final int lateCheckins;

  const AnalyticsAttendanceBlockEntity({
    required this.presentDays,
    required this.absentDays,
    required this.totalWorkingDays,
    required this.attendanceRate,
    required this.averageCheckInTime,
    required this.averageDurationMinutes,
    required this.lateCheckins,
  });

  @override
  List<Object?> get props => [
        presentDays,
        absentDays,
        totalWorkingDays,
        attendanceRate,
        averageCheckInTime,
        averageDurationMinutes,
        lateCheckins,
      ];
}

class AnalyticsLeaveBlockEntity extends Equatable {
  final int totalLeavesInPeriod;
  final int approved;
  final int pending;
  final int rejected;
  final Map<String, int> leavesByType;

  const AnalyticsLeaveBlockEntity({
    required this.totalLeavesInPeriod,
    required this.approved,
    required this.pending,
    required this.rejected,
    required this.leavesByType,
  });

  @override
  List<Object?> get props => [
        totalLeavesInPeriod,
        approved,
        pending,
        rejected,
        leavesByType,
      ];
}

class AnalyticsTaskBlockEntity extends Equatable {
  final int totalAssigned;
  final int completed;
  final int inProgress;
  final int overdue;
  final double completionRate;

  const AnalyticsTaskBlockEntity({
    required this.totalAssigned,
    required this.completed,
    required this.inProgress,
    required this.overdue,
    required this.completionRate,
  });

  @override
  List<Object?> get props => [
        totalAssigned,
        completed,
        inProgress,
        overdue,
        completionRate,
      ];
}

class EmployeeAnalyticsSummaryEntity extends Equatable {
  final EmployeeEntity employeeInfo;
  final AnalyticsAttendanceBlockEntity attendance;
  final AnalyticsLeaveBlockEntity leave;
  final AnalyticsTaskBlockEntity tasks;

  const EmployeeAnalyticsSummaryEntity({
    required this.employeeInfo,
    required this.attendance,
    required this.leave,
    required this.tasks,
  });

  @override
  List<Object?> get props => [employeeInfo, attendance, leave, tasks];
}

class EmployeeMonitorSnapshotEntity extends Equatable {
  final double attendanceRateThisMonth;
  final int leavesPending;
  final int tasksOverdue;
  final DateTime? lastSeen;
  final String status;

  const EmployeeMonitorSnapshotEntity({
    required this.attendanceRateThisMonth,
    required this.leavesPending,
    required this.tasksOverdue,
    required this.lastSeen,
    required this.status,
  });

  @override
  List<Object?> get props => [
        attendanceRateThisMonth,
        leavesPending,
        tasksOverdue,
        lastSeen,
        status,
      ];
}

class EmployeeMonitorResponseEntity extends Equatable {
  final EmployeeEntity employeeInfo;
  final EmployeeMonitorSnapshotEntity snapshot;

  const EmployeeMonitorResponseEntity({
    required this.employeeInfo,
    required this.snapshot,
  });

  @override
  List<Object?> get props => [employeeInfo, snapshot];
}
