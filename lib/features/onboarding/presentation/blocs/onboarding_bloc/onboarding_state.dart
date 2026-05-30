import '../../../domain/entities/onboarding_progress_entity.dart';

abstract class OnboardingState {}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingLoaded extends OnboardingState {
  final OnboardingProgressEntity progress;
  OnboardingLoaded(this.progress);
}

class OnboardingError extends OnboardingState {
  final String message;
  OnboardingError(this.message);
}
