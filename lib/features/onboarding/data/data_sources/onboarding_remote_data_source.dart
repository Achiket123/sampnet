import '../models/onboarding_progress_model.dart';

abstract class OnboardingRemoteDataSource {
  Future<OnboardingProgressModel> getOnboardingProgress(String userId);
  Future<void> updateOnboardingProgress(OnboardingProgressModel progress);
}

class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  @override
  Future<OnboardingProgressModel> getOnboardingProgress(String userId) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<void> updateOnboardingProgress(OnboardingProgressModel progress) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }
}
