import '../../../domain/entities/onboarding_progress_entity.dart';

abstract class OnboardingEvent {}

class LoadOnboardingProgress extends OnboardingEvent {
  final String userId;
  LoadOnboardingProgress(this.userId);
}

class UpdateOnboardingStep extends OnboardingEvent {
  final OnboardingProgressEntity progress;
  UpdateOnboardingStep(this.progress);
}
