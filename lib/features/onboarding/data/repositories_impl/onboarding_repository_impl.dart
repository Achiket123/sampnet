import '../../domain/entities/onboarding_progress_entity.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../data_sources/onboarding_remote_data_source.dart';
import '../models/onboarding_progress_model.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource remoteDataSource;

  OnboardingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<OnboardingProgressEntity> getOnboardingProgress(String userId) async {
    final model = await remoteDataSource.getOnboardingProgress(userId);
    return OnboardingProgressEntity(
      userId: model.userId,
      currentStep: model.currentStep,
      isCompleted: model.isCompleted,
      organisationId: model.organisationId,
      profileCompleted: model.profileCompleted,
      teamJoined: model.teamJoined,
      taskCreated: model.taskCreated,
      inviteSent: model.inviteSent,
    );
  }

  @override
  Future<void> updateOnboardingProgress(OnboardingProgressEntity progress) async {
    final model = OnboardingProgressModel(
      userId: progress.userId,
      currentStep: progress.currentStep,
      isCompleted: progress.isCompleted,
      organisationId: progress.organisationId,
      profileCompleted: progress.profileCompleted,
      teamJoined: progress.teamJoined,
      taskCreated: progress.taskCreated,
      inviteSent: progress.inviteSent,
    );
    await remoteDataSource.updateOnboardingProgress(model);
  }
}
