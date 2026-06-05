import 'package:equatable/equatable.dart';
import 'package:hackathon/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationEntity> notifications;
  final List<NotificationEntity> filteredNotifications;
  final int unreadCount;
  final bool isLoadingMore;
  final bool hasMore;

  const NotificationsLoaded({
    required this.notifications,
    required this.filteredNotifications,
    required this.unreadCount,
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  NotificationsLoaded copyWith({
    List<NotificationEntity>? notifications,
    List<NotificationEntity>? filteredNotifications,
    int? unreadCount,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return NotificationsLoaded(
      notifications: notifications ?? this.notifications,
      filteredNotifications: filteredNotifications ?? this.filteredNotifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
        notifications,
        filteredNotifications,
        unreadCount,
        isLoadingMore,
        hasMore,
      ];
}

class NotificationsLoadingMoreFailed extends NotificationsLoaded {
  final String errorMessage;

  const NotificationsLoadingMoreFailed({
    required super.notifications,
    required super.filteredNotifications,
    required super.unreadCount,
    required this.errorMessage,
    super.isLoadingMore = false,
    super.hasMore = true,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        errorMessage,
      ];
}

class NotificationsEmpty extends NotificationsState {}

class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}
