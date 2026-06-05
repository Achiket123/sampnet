import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/notifications/presentation/blocs/notifications_bloc/notifications_bloc.dart';
import 'package:hackathon/features/notifications/presentation/blocs/notifications_bloc/notifications_event.dart';
import 'package:hackathon/features/notifications/presentation/blocs/notifications_bloc/notifications_state.dart';
import 'package:hackathon/features/notifications/presentation/widgets/notification_panel.dart';

class NotificationBellWidget extends StatefulWidget {
  const NotificationBellWidget({super.key});

  @override
  State<NotificationBellWidget> createState() => _NotificationBellWidgetState();
}

class _NotificationBellWidgetState extends State<NotificationBellWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(NotificationsUnreadCountRefreshRequested());
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      context.read<NotificationsBloc>().add(NotificationsUnreadCountRefreshRequested());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      buildWhen: (previous, current) {
        if (current is NotificationsLoaded) {
          if (previous is NotificationsLoaded) {
            return previous.unreadCount != current.unreadCount;
          }
          return true;
        }
        return false;
      },
      builder: (context, state) {
        int unreadCount = 0;
        if (state is NotificationsLoaded) {
          unreadCount = state.unreadCount;
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: Icon(
                unreadCount > 0 ? Icons.notifications : Icons.notifications_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                _showNotificationPanel(context);
              },
            ),
            if (unreadCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    unreadCount > 99 ? '99+' : unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showNotificationPanel(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Notifications',
      pageBuilder: (context, animation, secondaryAnimation) {
        return const NotificationPanel();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
