import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final int id;
  final int userId;
  final int organisationId;
  final String title;
  final String message;
  final String type;
  final String link;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
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

  bool get isNavigable => link.isNotEmpty;

  NotificationEntity copyWith({
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
    return NotificationEntity(
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

  @override
  List<Object?> get props => [
        id,
        userId,
        organisationId,
        title,
        message,
        type,
        link,
        isRead,
        createdAt,
      ];
}
