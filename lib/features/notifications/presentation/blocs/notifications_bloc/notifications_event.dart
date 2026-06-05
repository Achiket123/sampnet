import 'package:equatable/equatable.dart';
import 'package:hackathon/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class NotificationsLoadRequested extends NotificationsEvent {}

class NotificationsMarkReadRequested extends NotificationsEvent {
  final int notificationId;
  const NotificationsMarkReadRequested(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class NotificationsMarkAllReadRequested extends NotificationsEvent {}

class NotificationsUnreadCountRefreshRequested extends NotificationsEvent {}

class NotificationsLoadMoreRequested extends NotificationsEvent {
  final int offset;
  const NotificationsLoadMoreRequested(this.offset);

  @override
  List<Object?> get props => [offset];
}

class NotificationReceivedEvent extends NotificationsEvent {
  final NotificationEntity notification;
  const NotificationReceivedEvent(this.notification);

  @override
  List<Object?> get props => [notification];
}
