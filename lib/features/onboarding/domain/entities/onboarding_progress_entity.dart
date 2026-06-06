class OnboardingProgressEntity {
  final String userId;
  final int organisationId;
  final bool profileCompleted;
  final bool teamJoined;
  final bool taskCreated;
  final bool inviteSent;
  final int currentStep;
  final bool isCompleted;

  OnboardingProgressEntity({
    required this.userId,
    required this.organisationId,
    required this.profileCompleted,
    required this.teamJoined,
    required this.taskCreated,
    required this.inviteSent,
    required this.currentStep,
    required this.isCompleted,
  });
}
