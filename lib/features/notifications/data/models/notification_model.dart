import 'package:hackathon/features/notifications/domain/entities/notification_entity.dart';

class NotificationModel {
  final int id;
  final int userId;
  final int organisationId;
  final String title;
  final String message;
  final String type;
  final String link;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.organisationId,
    required this.title,
    required this.message,
    required this.type,
    required this.link,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      organisationId: json['organisation_id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      type: json['notification_type'] as String? ?? 'general',
      link: json['link'] as String? ?? '',
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'organisation_id': organisationId,
      'title': title,
      'message': message,
      'notification_type': type,
      'link': link,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    int? id,
    int? userId,
    int? organisationId,
    String? title,
    String? message,
    String? type,
    String? link,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      organisationId: organisationId ?? this.organisationId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      link: link ?? this.link,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      userId: userId,
      organisationId: organisationId,
      title: title,
      message: message,
      type: type,
      link: link,
      isRead: isRead,
      createdAt: createdAt,
    );
  }

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      userId: entity.userId,
      organisationId: entity.organisationId,
      title: entity.title,
      message: entity.message,
      type: entity.type,
      link: entity.link,
      isRead: entity.isRead,
      createdAt: entity.createdAt,
    );
  }
}
