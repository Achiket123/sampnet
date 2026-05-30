import '../entities/onboarding_progress_entity.dart';

abstract class OnboardingRepository {
  Future<OnboardingProgressEntity> getOnboardingProgress(String userId);
  Future<void> updateOnboardingProgress(OnboardingProgressEntity progress);
}
