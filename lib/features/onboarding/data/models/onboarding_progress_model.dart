import 'package:flutter/foundation.dart';

class OnboardingProgressModel {
  final String userId;
  final int currentStep;
  final bool isCompleted;

  OnboardingProgressModel({
    required this.userId,
    required this.currentStep,
    required this.isCompleted,
  });

  factory OnboardingProgressModel.fromJson(Map<String, dynamic> json) {
    return OnboardingProgressModel(
      userId: json['userId'],
      currentStep: json['currentStep'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentStep': currentStep,
      'isCompleted': isCompleted,
    };
  }
}
