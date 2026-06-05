import 'dart:convert';
import 'package:hackathon/features/notifications/data/models/notification_model.dart';
import 'package:hackathon/services/api_client.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications(int offset);
  Future<void> markRead(int notificationId);
  Future<void> markAllRead();
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final ApiClient apiClient;

  NotificationsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<NotificationModel>> getNotifications(int offset) async {
    final response = await apiClient.get('/notifications/?offset=$offset');

    if (response.statusCode >= 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> notificationsJson = data['notifications'] ?? [];
      return notificationsJson
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch notifications: ${response.body}');
    }
  }

  @override
  Future<void> markRead(int notificationId) async {
    final response =
        await apiClient.put('/notifications/$notificationId/read', body: {});

    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read: ${response.body}');
    }
  }

  @override
  Future<void> markAllRead() async {
    final response = await apiClient.put('/notifications/read-all', body: {});

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to mark all notifications as read: ${response.body}');
    }
  }
}
