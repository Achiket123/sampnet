import 'package:hackathon/features/leave/domain/entities/leave_entity.dart';

class LeaveModel extends Leave {
  const LeaveModel({
    required super.id,
    required super.employeeId,
    required super.organisationId,
    required super.managerId,
    required super.leaveType,
    required super.startDate,
    required super.endDate,
    required super.totalDays,
    required super.reason,
    required super.status,
    required super.managerNote,
    required super.createdAt,
    required super.updatedAt,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['id'] ?? 0,
      employeeId: json['employee_id'] ?? 0,
      organisationId: json['organisation_id'] ?? 0,
      managerId: json['manager_id'] ?? 0,
      leaveType: json['leave_type'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      totalDays: json['total_days'] ?? 0,
      reason: json['reason'] ?? '',
      status: json['status'] ?? 'pending',
      managerNote: json['manager_note'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organisation_id': organisationId,
      'leave_type': leaveType,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'reason': reason,
    };
  }
}
