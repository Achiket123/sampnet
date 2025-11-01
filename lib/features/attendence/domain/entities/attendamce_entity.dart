class AttendenceEntity {
  final int? id;
  final DateTime? checkinTime;
  final DateTime? checkoutTime;
  final int userId;
  final int? checkInPicture;
  final int? checkOutPicture;
  final int organisationId;

  AttendenceEntity({
    this.id,
    required this.checkinTime,
    required this.checkoutTime,
    required this.userId,
    required this.checkInPicture,
    required this.checkOutPicture,
    required this.organisationId,
  });
}
