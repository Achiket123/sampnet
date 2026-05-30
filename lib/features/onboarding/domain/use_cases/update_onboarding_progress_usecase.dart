import '../entities/onboarding_progress_entity.dart';
import '../repositories/onboarding_repository.dart';

class UpdateOnboardingProgressUseCase {
  final OnboardingRepository repository;

  UpdateOnboardingProgressUseCase(this.repository);

  Future<void> call(OnboardingProgressEntity progress) async {
    return await repository.updateOnboardingProgress(progress);
  }
}
