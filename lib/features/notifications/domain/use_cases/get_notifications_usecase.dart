import '../repositories/notification_repository.dart';
import '../entities/notification_entity.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<NotificationEntity>> call(int offset) {
    return repository.getNotifications(offset);
  }
}
