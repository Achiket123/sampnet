import 'package:flutter/foundation.dart';
import '../../domain/entities/onboarding_progress_entity.dart';

class OnboardingProgressModel extends OnboardingProgressEntity {
  OnboardingProgressModel({
    required super.userId,
    required super.organisationId,
    required super.profileCompleted,
    required super.teamJoined,
    required super.taskCreated,
    required super.inviteSent,
    required super.currentStep,
    required super.isCompleted,
    /*
    required this.userId,
    required this.organisationId,
    required this.profileCompleted,
    required this.teamJoined,
    required this.taskCreated,
    required this.inviteSent,
    required this.currentStep,
    required this.isCompleted,
    */
  });

  factory OnboardingProgressModel.fromJson(Map<String, dynamic> json) {
    int currentStep = 0;
    if (json['profileCompleted'] == true) currentStep++;
    if (json['organisationId'] != null && json['organisationId'] != 0) currentStep++;
    if (json['teamJoined'] == true) currentStep++;
    if (json['taskCreated'] == true) currentStep++;
    if (json['inviteSent'] == true) currentStep++;

    return OnboardingProgressModel(
      userId: json['userId'].toString(),
      organisationId: json['organisationId'] ?? 0,
      profileCompleted: json['profileCompleted'] ?? false,
      teamJoined: json['teamJoined'] ?? false,
      taskCreated: json['taskCreated'] ?? false,
      inviteSent: json['inviteSent'] ?? false,
      currentStep: currentStep,
      isCompleted: currentStep >= 5,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': int.tryParse(userId) ?? 0,
      'organisationId': organisationId,
      'profileCompleted': profileCompleted,
      'teamJoined': teamJoined,
      'taskCreated': taskCreated,
      'inviteSent': inviteSent,
    };
  }
}
