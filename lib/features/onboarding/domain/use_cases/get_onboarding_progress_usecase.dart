import '../entities/onboarding_progress_entity.dart';
import '../repositories/onboarding_repository.dart';

class GetOnboardingProgressUseCase {
  final OnboardingRepository repository;

  GetOnboardingProgressUseCase(this.repository);

  Future<OnboardingProgressEntity> call(String userId) async {
    return await repository.getOnboardingProgress(userId);
  }
}
