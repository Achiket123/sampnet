class OnboardingProgressEntity {
  final String userId;
  final int currentStep;
  final bool isCompleted;

  OnboardingProgressEntity({
    required this.userId,
    required this.currentStep,
    required this.isCompleted,
  });
}
