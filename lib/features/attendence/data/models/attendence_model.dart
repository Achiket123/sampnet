import 'package:hackathon/features/attendence/domain/entities/attendamce_entity.dart';

class AttendenceModel extends AttendenceEntity {
  AttendenceModel(
      {super.id,
      super.checkinTime,
      super.checkoutTime,
      super.checkInPicture,
      super.checkOutPicture,
      required super.userId,
      required super.organisationId});

  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "check_in_time": checkinTime?.toUtc().toIso8601String(),
      "check_out_time": checkoutTime?.toUtc().toIso8601String(),
      "user_id": userId,
      "check_in_photo": checkInPicture,
      "check_out_photo": checkOutPicture,
      "organisation_id": organisationId,
    };
  }

  factory AttendenceModel.fromJson(Map<String, dynamic> json) {
    return AttendenceModel(
      id: json["ID"],
      checkinTime: json["check_in_time"] == null
          ? null
          : DateTime.parse(json["check_in_time"]),
      checkoutTime: json["check_out_time"] == null
          ? null
          : DateTime.parse(json["check_out_time"]),
      userId: json["user_id"],
      checkInPicture: json["check_in_photo"],
      checkOutPicture: json["check_out_photo"],
      organisationId: json["organisation_id"],
    );
  }
}

class AttendanceRecordModel extends AttendanceRecordEntity {
  AttendanceRecordModel({
    super.id,
    required super.userId,
    required super.organisationId,
    required super.checkInTime,
    required super.checkOutTime,
    super.checkInPhoto,
    super.checkOutPhoto,
    super.durationMinutes,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      id: json["id"] ?? json["ID"],
      userId: json["user_id"],
      organisationId: json["organisation_id"],
      checkInTime: json["check_in_time"] == null ? null : DateTime.parse(json["check_in_time"]),
      checkOutTime: json["check_out_time"] == null ? null : DateTime.parse(json["check_out_time"]),
      checkInPhoto: json["check_in_photo"],
      checkOutPhoto: json["check_out_photo"],
      durationMinutes: json["duration_minutes"],
    );
  }
  
  AttendanceRecordEntity toEntity() {
    return this;
  }
}

class AttendanceSummaryModel extends AttendanceSummaryEntity {
  AttendanceSummaryModel({
    required super.totalDaysPresent,
    required super.totalDaysAbsent,
    required super.averageCheckInTime,
    required super.averageDurationMinutes,
    required super.onTimePercentage,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      totalDaysPresent: json["total_days_present"] ?? 0,
      totalDaysAbsent: json["total_days_absent"] ?? 0,
      averageCheckInTime: json["average_check_in_time"] ?? "",
      averageDurationMinutes: json["average_duration_minutes"] ?? 0,
      onTimePercentage: (json["on_time_percentage"] ?? 0.0).toDouble(),
    );
  }
  
  AttendanceSummaryEntity toEntity() {
    return this;
  }
}

class AttendanceHistoryModel extends AttendanceHistoryEntity {
  AttendanceHistoryModel({
    required super.records,
    required super.summary,
  });

  factory AttendanceHistoryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryModel(
      records: (json["records"] as List?)?.map((e) => AttendanceRecordModel.fromJson(e)).toList() ?? [],
      summary: AttendanceSummaryModel.fromJson(json["summary"] ?? {}),
    );
  }
  
  AttendanceHistoryEntity toEntity() {
    return this;
  }
}
