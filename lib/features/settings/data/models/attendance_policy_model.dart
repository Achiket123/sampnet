import 'package:hackathon/features/settings/domain/entities/attendance_policy_entity.dart';

class AttendancePolicyModel extends AttendancePolicyConfig {
  AttendancePolicyModel({
    super.id,
    required super.checkInTime,
    required super.checkOutTime,
    required super.gracePeriodMins,
  });

  factory AttendancePolicyModel.fromJson(Map<String, dynamic> json) {
    return AttendancePolicyModel(
      id: json['id'] as int?,
      checkInTime: json['check_in_time'] as String? ?? '09:00',
      checkOutTime: json['check_out_time'] as String? ?? '18:00',
      gracePeriodMins: json['grace_period_mins'] as int? ?? 15,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'grace_period_mins': gracePeriodMins,
    };
  }
}
