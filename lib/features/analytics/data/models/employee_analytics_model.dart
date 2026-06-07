import 'package:hackathon/features/analytics/domain/entities/employee_analytics_entity.dart';
import 'package:hackathon/features/employees/data/models/employee_model.dart';

class AnalyticsAttendanceBlockModel extends AnalyticsAttendanceBlockEntity {
  const AnalyticsAttendanceBlockModel({
    required super.presentDays,
    required super.absentDays,
    required super.totalWorkingDays,
    required super.attendanceRate,
    required super.averageCheckInTime,
    required super.averageDurationMinutes,
    required super.lateCheckins,
  });

  factory AnalyticsAttendanceBlockModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsAttendanceBlockModel(
      presentDays: json['present_days'] ?? 0,
      absentDays: json['absent_days'] ?? 0,
      totalWorkingDays: json['total_working_days'] ?? 0,
      attendanceRate: (json['attendance_rate'] ?? 0.0).toDouble(),
      averageCheckInTime: json['average_check_in_time'] ?? "",
      averageDurationMinutes: json['average_duration_minutes'] ?? 0,
      lateCheckins: json['late_checkins'] ?? 0,
    );
  }
}

class AnalyticsLeaveBlockModel extends AnalyticsLeaveBlockEntity {
  const AnalyticsLeaveBlockModel({
    required super.totalLeavesInPeriod,
    required super.approved,
    required super.pending,
    required super.rejected,
    required super.leavesByType,
  });

  factory AnalyticsLeaveBlockModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsLeaveBlockModel(
      totalLeavesInPeriod: json['total_leaves_in_period'] ?? 0,
      approved: json['approved'] ?? 0,
      pending: json['pending'] ?? 0,
      rejected: json['rejected'] ?? 0,
      leavesByType: Map<String, int>.from(json['leaves_by_type'] ?? {}),
    );
  }
}

class AnalyticsTaskBlockModel extends AnalyticsTaskBlockEntity {
  const AnalyticsTaskBlockModel({
    required super.totalAssigned,
    required super.completed,
    required super.inProgress,
    required super.overdue,
    required super.completionRate,
  });

  factory AnalyticsTaskBlockModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsTaskBlockModel(
      totalAssigned: json['total_assigned'] ?? 0,
      completed: json['completed'] ?? 0,
      inProgress: json['in_progress'] ?? 0,
      overdue: json['overdue'] ?? 0,
      completionRate: (json['completion_rate'] ?? 0.0).toDouble(),
    );
  }
}

class EmployeeAnalyticsSummaryModel extends EmployeeAnalyticsSummaryEntity {
  const EmployeeAnalyticsSummaryModel({
    required super.employeeInfo,
    required super.attendance,
    required super.leave,
    required super.tasks,
  });

  factory EmployeeAnalyticsSummaryModel.fromJson(Map<String, dynamic> json) {
    return EmployeeAnalyticsSummaryModel(
      employeeInfo: EmployeeModel.fromJson(json['employee_info'] ?? {}).toEntity(),
      attendance: AnalyticsAttendanceBlockModel.fromJson(json['attendance'] ?? {}),
      leave: AnalyticsLeaveBlockModel.fromJson(json['leave'] ?? {}),
      tasks: AnalyticsTaskBlockModel.fromJson(json['tasks'] ?? {}),
    );
  }
}

class EmployeeMonitorSnapshotModel extends EmployeeMonitorSnapshotEntity {
  const EmployeeMonitorSnapshotModel({
    required super.attendanceRateThisMonth,
    required super.leavesPending,
    required super.tasksOverdue,
    required super.lastSeen,
    required super.status,
  });

  factory EmployeeMonitorSnapshotModel.fromJson(Map<String, dynamic> json) {
    return EmployeeMonitorSnapshotModel(
      attendanceRateThisMonth: (json['attendance_rate_this_month'] ?? 0.0).toDouble(),
      leavesPending: json['leaves_pending'] ?? 0,
      tasksOverdue: json['tasks_overdue'] ?? 0,
      lastSeen: json['last_seen'] == null ? null : DateTime.tryParse(json['last_seen']),
      status: json['status'] ?? 'inactive',
    );
  }
}

class EmployeeMonitorResponseModel extends EmployeeMonitorResponseEntity {
  const EmployeeMonitorResponseModel({
    required super.employeeInfo,
    required super.snapshot,
  });

  factory EmployeeMonitorResponseModel.fromJson(Map<String, dynamic> json) {
    return EmployeeMonitorResponseModel(
      employeeInfo: EmployeeModel.fromJson(json['employee_info'] ?? {}).toEntity(),
      snapshot: EmployeeMonitorSnapshotModel.fromJson(json['snapshot'] ?? {}),
    );
  }
}
