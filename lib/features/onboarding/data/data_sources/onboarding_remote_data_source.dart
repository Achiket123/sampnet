import 'dart:convert';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/services/api_client.dart';
import '../models/onboarding_progress_model.dart';
import 'package:flutter/material.dart';

abstract class OnboardingRemoteDataSource {
  Future<OnboardingProgressModel> getOnboardingProgress(String userId);
  Future<void> updateOnboardingProgress(OnboardingProgressModel progress);
}

class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  final ApiClient apiClient;
  OnboardingRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<OnboardingProgressModel> getOnboardingProgress(String userId) async {
    final response = await apiClient.get("${ApiConstants.baseUrl}/onboarding/$userId");
    debugPrint("ONBOARING:: ${response.body}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return OnboardingProgressModel.fromJson(jsonDecode(response.body));
    }
    debugPrint("ONBOARING:: ${response.body}");
    throw Exception("Failed to get onboarding progress: ${response.body}");
  }

  @override
  Future<void> updateOnboardingProgress(OnboardingProgressModel progress) async {
    final response = await apiClient.post("${ApiConstants.baseUrl}/onboarding/update", body: progress.toJson());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    throw Exception("Failed to update onboarding progress: ${response.body}");
  }
}
