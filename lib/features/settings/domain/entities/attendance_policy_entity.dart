class AttendancePolicyConfig {
  final int? id;
  final String checkInTime;
  final String checkOutTime;
  final int gracePeriodMins;

  AttendancePolicyConfig({
    this.id,
    required this.checkInTime,
    required this.checkOutTime,
    required this.gracePeriodMins,
  });
}
