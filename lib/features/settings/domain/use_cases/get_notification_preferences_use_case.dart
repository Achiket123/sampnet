import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/settings/domain/entities/notification_preferences_entity.dart';
import 'package:hackathon/features/settings/domain/repositories/settings_repository.dart';

class GetNotificationPreferencesUseCase {
  final SettingsRepository repository;

  GetNotificationPreferencesUseCase({required this.repository});

  Future<Either<ErrorModel, List<NotificationPreferenceEntry>>> call() {
    return repository.getNotificationPreferences();
  }
}
