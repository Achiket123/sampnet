
// Dart Model for Manager
import 'package:hackathon/globals/models/organisation_model.dart';
import 'package:hackathon/globals/models/user_model.dart';

class Manager {
  final int userId;
  final UserModel user;
  final int employmentId;
  final int organisationId;
  final Organisation organisation;
  final String type;
  final String salary;
  final DateTime lastLoginAt;

  Manager({
    required this.userId,
    required this.user,
    required this.employmentId,
    required this.organisationId,
    required this.organisation,
    required this.type,
    required this.salary,
    required this.lastLoginAt,
  });

  factory Manager.fromJson(Map<String, dynamic> json) {
    return Manager(
      userId: json['user_id'] as int,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      employmentId: json['employment_id'] as int,
      organisationId: json['organisation_id'] as int,
      organisation: Organisation.fromJson(json['organisation'] as Map<String, dynamic>),
      type: json['type'] as String,
      salary: json['salary'] as String,
      lastLoginAt: DateTime.parse(json['last_login_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user': user.toJson(),
      'employment_id': employmentId,
      'organisation_id': organisationId,
      'organisation': organisation.toJson(),
      'type': type,
      'salary': salary,
      'last_login_at': lastLoginAt.toIso8601String(),
    };
  }
}