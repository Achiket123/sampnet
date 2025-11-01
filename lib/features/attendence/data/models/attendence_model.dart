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
