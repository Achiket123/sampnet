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

class AttendanceRecordEntity {
  final int? id;
  final int userId;
  final int organisationId;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final int? checkInPhoto;
  final int? checkOutPhoto;
  final int? durationMinutes;

  AttendanceRecordEntity({
    this.id,
    required this.userId,
    required this.organisationId,
    required this.checkInTime,
    required this.checkOutTime,
    this.checkInPhoto,
    this.checkOutPhoto,
    this.durationMinutes,
  });
}

class AttendanceSummaryEntity {
  final int totalDaysPresent;
  final int totalDaysAbsent;
  final String averageCheckInTime;
  final int averageDurationMinutes;
  final double onTimePercentage;

  AttendanceSummaryEntity({
    required this.totalDaysPresent,
    required this.totalDaysAbsent,
    required this.averageCheckInTime,
    required this.averageDurationMinutes,
    required this.onTimePercentage,
  });
}

class AttendanceHistoryEntity {
  final List<AttendanceRecordEntity> records;
  final AttendanceSummaryEntity summary;

  AttendanceHistoryEntity({
    required this.records,
    required this.summary,
  });
}
