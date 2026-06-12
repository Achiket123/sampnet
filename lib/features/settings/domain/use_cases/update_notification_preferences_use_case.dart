import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/settings/domain/entities/notification_preferences_entity.dart';
import 'package:hackathon/features/settings/domain/repositories/settings_repository.dart';

class UpdateNotificationPreferencesUseCase {
  final SettingsRepository repository;

  UpdateNotificationPreferencesUseCase({required this.repository});

  Future<Either<ErrorModel, void>> call(List<NotificationPreferenceEntry> preferences) {
    return repository.updateNotificationPreferences(preferences);
  }
}
