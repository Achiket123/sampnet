import 'package:hackathon/features/settings/domain/entities/plan_entity.dart';

class OrgPlanModel extends OrgPlan {
  OrgPlanModel({
    required super.planId,
    required super.planName,
    required super.planStatus,
    required super.maxEmployees,
    super.planStartDate,
    super.planEndDate,
  });

  factory OrgPlanModel.fromJson(Map<String, dynamic> json) {
    return OrgPlanModel(
      planId: json['plan_id'] as int?,
      planName: json['plan_name'] as String? ?? 'Free Plan',
      planStatus: json['plan_status'] as String? ?? 'active',
      maxEmployees: json['max_employees'] as int? ?? 10,
      planStartDate: json['plan_start_date'] != null
          ? DateTime.tryParse(json['plan_start_date'] as String)
          : null,
      planEndDate: json['plan_end_date'] != null
          ? DateTime.tryParse(json['plan_end_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan_id': planId,
      'plan_name': planName,
      'plan_status': planStatus,
      'max_employees': maxEmployees,
      'plan_start_date': planStartDate?.toIso8601String(),
      'plan_end_date': planEndDate?.toIso8601String(),
    };
  }
}
