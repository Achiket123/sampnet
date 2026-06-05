import 'package:hackathon/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications(int offset);
  Future<void> markRead(int notificationId);
  Future<void> markAllRead();
  Future<int> getUnreadCount();
}
