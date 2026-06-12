class LeaveTypeConfig {
  final int? id;
  final String leaveType;
  final int maxDays;
  final String description;

  LeaveTypeConfig({
    this.id,
    required this.leaveType,
    required this.maxDays,
    required this.description,
  });
}
