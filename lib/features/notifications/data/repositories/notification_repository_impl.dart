import 'package:hackathon/features/notifications/data/data_sources/notifications_remote_data_source.dart';
import 'package:hackathon/features/notifications/domain/entities/notification_entity.dart';
import 'package:hackathon/features/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationsRemoteDataSource remoteDataSource;
  
  List<NotificationEntity> _cache = [];
  bool _isDirty = true;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NotificationEntity>> getNotifications(int offset) async {
    if (offset == 0 && !_isDirty) {
      return _cache;
    }

    final models = await remoteDataSource.getNotifications(offset);
    final entities = models.map((m) => m.toEntity()).toList();

    if (offset == 0) {
      _cache = entities;
      _isDirty = false;
    } else {
      // Append to cache for pagination if needed, but the prompt says 
      // getUnreadCount uses offset 0 or cached list.
      // For simplicity, we only cache the first page for the badge count.
      _cache.addAll(entities);
    }

    return entities;
  }

  @override
  Future<void> markRead(int notificationId) async {
    // Optimistic update
    final index = _cache.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _cache[index] = _cache[index].copyWith(isRead: true);
    }
    _isDirty = true;
    await remoteDataSource.markRead(notificationId);
  }

  @override
  Future<void> markAllRead() async {
    // Optimistic update
    _cache = _cache.map((n) => n.copyWith(isRead: true)).toList();
    _isDirty = true;
    await remoteDataSource.markAllRead();
  }

  @override
  Future<int> getUnreadCount() async {
    if (_isDirty) {
      await getNotifications(0);
    }
    return _cache.where((n) => !n.isRead).length;
  }
}
