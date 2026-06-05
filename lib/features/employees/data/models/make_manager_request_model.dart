class MakeManagerRequestModel {
  final int userId;
  final int organisationId;
  final String type;
  final String salary;

  const MakeManagerRequestModel({
    required this.userId,
    required this.organisationId,
    required this.type,
    required this.salary,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'organisation_id': organisationId,
      'type': type,
      'salary': salary,
    };
  }
}
