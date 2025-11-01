
// Dart Model for Boss
import 'package:hackathon/globals/models/organisation_model.dart';
import 'package:hackathon/globals/models/user_model.dart';

class Boss {
  final int userId;
  final UserModel user;
  final int organisationId;
  final Organisation organisation;
  final DateTime lastLoginAt;

  Boss({
    required this.userId,
    required this.user,
    required this.organisationId,
    required this.organisation,
    required this.lastLoginAt,
  });

  factory Boss.fromJson(Map<String, dynamic> json) {
    return Boss(
      userId: json['user_id'] as int,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      organisationId: json['organisation_id'] as int,
      organisation: Organisation.fromJson(json['organisation'] as Map<String, dynamic>),
      lastLoginAt: DateTime.parse(json['last_login_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user': user.toJson(),
      'organisation_id': organisationId,
      'organisation': organisation.toJson(),
      'last_login_at': lastLoginAt.toIso8601String(),
    };
  }
}