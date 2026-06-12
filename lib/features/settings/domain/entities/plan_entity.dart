class OrgPlan {
  final int? planId;
  final String planName;
  final String planStatus;
  final int maxEmployees;
  final DateTime? planStartDate;
  final DateTime? planEndDate;

  OrgPlan({
    required this.planId,
    required this.planName,
    required this.planStatus,
    required this.maxEmployees,
    this.planStartDate,
    this.planEndDate,
  });
}
