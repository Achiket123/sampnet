class AttendenceParams {
  final DateTime dateTime;
  final int userId;
  final int? id;
  final int picture;
  final int organisationId;
  AttendenceParams(
      {required this.dateTime,
      required this.userId,
      required this.picture,
      required this.organisationId,
      this.id});
}
