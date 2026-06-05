import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/notifications/domain/entities/notification_entity.dart';
import 'package:hackathon/features/notifications/domain/repositories/notification_repository.dart';
import 'package:hackathon/features/notifications/presentation/blocs/notifications_bloc/notification_type_filter.dart';
import 'package:hackathon/features/notifications/presentation/blocs/notifications_bloc/notifications_event.dart';
import 'package:hackathon/features/notifications/presentation/blocs/notifications_bloc/notifications_state.dart';

import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/services/websocket_service.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationRepository repository;
  final NotificationTypeFilter typeFilter;
  static const int pageSize = 20;
  StreamSubscription? _websocketSubscription;

  NotificationsBloc({
    required this.repository,
    required this.typeFilter,
  }) : super(NotificationsInitial()) {
    on<NotificationsLoadRequested>(_onLoadRequested);
    on<NotificationsMarkReadRequested>(_onMarkReadRequested);
    on<NotificationsMarkAllReadRequested>(_onMarkAllReadRequested);
    on<NotificationsUnreadCountRefreshRequested>(_onUnreadCountRefreshRequested);
    on<NotificationsLoadMoreRequested>(_onLoadMoreRequested);
    on<NotificationReceivedEvent>(_onNotificationReceived);

    _websocketSubscription = getIt<WebsocketService>().notificationStream.listen(
      (notification) {
        add(NotificationReceivedEvent(notification));
      },
    );
  }

  @override
  Future<void> close() {
    _websocketSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadRequested(
    NotificationsLoadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading());
    try {
      await typeFilter.load();
      final notifications = await repository.getNotifications(0);
      final unreadCount = await repository.getUnreadCount();
      
      if (notifications.isEmpty) {
        emit(NotificationsEmpty());
      } else {
        emit(NotificationsLoaded(
          notifications: notifications,
          filteredNotifications: typeFilter.apply(notifications),
          unreadCount: unreadCount,
          hasMore: notifications.length >= pageSize,
        ));
      }
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> _onMarkReadRequested(
    NotificationsMarkReadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      final oldNotifications = List<NotificationEntity>.from(currentState.notifications);
      final oldUnreadCount = currentState.unreadCount;

      // Optimistic update
      final newNotifications = currentState.notifications.map((n) {
        if (n.id == event.notificationId) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();

      emit(currentState.copyWith(
        notifications: newNotifications,
        filteredNotifications: typeFilter.apply(newNotifications),
        unreadCount: oldUnreadCount - 1,
      ));

      try {
        await repository.markRead(event.notificationId);
      } catch (e) {
        // Rollback
        emit(currentState.copyWith(
          notifications: oldNotifications,
          filteredNotifications: typeFilter.apply(oldNotifications),
          unreadCount: oldUnreadCount,
        ));
        // Note: The prompt suggests showing a toast here, 
        // but BLoC shouldn't handle UI. We could emit a temporary error state.
      }
    }
  }

  Future<void> _onMarkAllReadRequested(
    NotificationsMarkAllReadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      final oldNotifications = List<NotificationEntity>.from(currentState.notifications);
      final oldUnreadCount = currentState.unreadCount;

      // Optimistic update
      final newNotifications = currentState.notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();

      emit(currentState.copyWith(
        notifications: newNotifications,
        filteredNotifications: typeFilter.apply(newNotifications),
        unreadCount: 0,
      ));

      try {
        await repository.markAllRead();
      } catch (e) {
        // Rollback
        emit(currentState.copyWith(
          notifications: oldNotifications,
          filteredNotifications: typeFilter.apply(oldNotifications),
          unreadCount: oldUnreadCount,
        ));
      }
    }
  }

  Future<void> _onUnreadCountRefreshRequested(
    NotificationsUnreadCountRefreshRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      final count = await repository.getUnreadCount();
      if (state is NotificationsLoaded) {
        final currentState = state as NotificationsLoaded;
        if (currentState.unreadCount != count) {
          emit(currentState.copyWith(unreadCount: count));
        }
      } else if (state is NotificationsInitial || state is NotificationsEmpty) {
        // Even if not loaded, we can update the count if we have a way to represent it.
        // For now, let's just emit a Loaded state with empty list if count > 0 but state is empty.
        if (count > 0 && state is NotificationsEmpty) {
          add(NotificationsLoadRequested());
        }
      }
    } catch (_) {
      // Fail silently for refresh
    }
  }

  Future<void> _onLoadMoreRequested(
    NotificationsLoadMoreRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      if (currentState.isLoadingMore || !currentState.hasMore) return;

      emit(currentState.copyWith(isLoadingMore: true));

      try {
        final moreNotifications = await repository.getNotifications(event.offset);
        final allNotifications = [...currentState.notifications, ...moreNotifications];
        
        emit(currentState.copyWith(
          notifications: allNotifications,
          filteredNotifications: typeFilter.apply(allNotifications),
          isLoadingMore: false,
          hasMore: moreNotifications.length >= pageSize,
        ));
      } catch (e) {
        emit(NotificationsLoadingMoreFailed(
          notifications: currentState.notifications,
          filteredNotifications: currentState.filteredNotifications,
          unreadCount: currentState.unreadCount,
          errorMessage: e.toString(),
          hasMore: currentState.hasMore,
        ));
      }
    }
  }

  Future<void> _onNotificationReceived(
    NotificationReceivedEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final notification = event.notification;
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;

      // Avoid duplicate notifications in the list
      if (currentState.notifications.any((n) => n.id == notification.id)) {
        return;
      }

      final newNotifications = [notification, ...currentState.notifications];
      emit(currentState.copyWith(
        notifications: newNotifications,
        filteredNotifications: typeFilter.apply(newNotifications),
        unreadCount: currentState.unreadCount + (notification.isRead ? 0 : 1),
      ));
    } else if (state is NotificationsEmpty || state is NotificationsInitial) {
      emit(NotificationsLoaded(
        notifications: [notification],
        filteredNotifications: typeFilter.apply([notification]),
        unreadCount: notification.isRead ? 0 : 1,
        hasMore: false,
      ));
    }
  }
}
