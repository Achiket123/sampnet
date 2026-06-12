import 'package:hackathon/features/settings/domain/entities/leave_policy_entity.dart';

class LeaveTypeConfigModel extends LeaveTypeConfig {
  LeaveTypeConfigModel({
    super.id,
    required super.leaveType,
    required super.maxDays,
    required super.description,
  });

  factory LeaveTypeConfigModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeConfigModel(
      id: json['id'] as int?,
      leaveType: json['leave_type'] as String? ?? '',
      maxDays: json['max_days'] as int? ?? 0,
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'leave_type': leaveType,
      'max_days': maxDays,
      'description': description,
    };
  }
}
