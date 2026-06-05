import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/features/notifications/domain/entities/notification_entity.dart';
import 'package:hackathon/features/notifications/presentation/blocs/notifications_bloc/notifications_bloc.dart';
import 'package:hackathon/features/notifications/presentation/blocs/notifications_bloc/notifications_event.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationEntity notification;
  const NotificationItemWidget({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<NotificationsBloc>().add(NotificationsMarkReadRequested(notification.id));
        if (notification.isNavigable) {
          context.go(notification.link);
          Navigator.pop(context); // Close panel
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.transparent : Colors.white.withValues(alpha: 0.05),
          border: const Border(bottom: BorderSide(color: Colors.white10, width: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      _formatRelativeTime(notification.createdAt),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case 'task_assigned':
      case 'task_updated':
        iconData = Icons.assignment_outlined;
        iconColor = Colors.blueAccent;
        break;
      case 'task_comment':
        iconData = Icons.comment_outlined;
        iconColor = Colors.orangeAccent;
        break;
      case 'leave_request':
        iconData = Icons.calendar_today_outlined;
        iconColor = Colors.purpleAccent;
        break;
      case 'leave_approved':
        iconData = Icons.check_circle_outline;
        iconColor = Colors.greenAccent;
        break;
      case 'leave_rejected':
        iconData = Icons.cancel_outlined;
        iconColor = Colors.redAccent;
        break;
      default:
        iconData = Icons.notifications_none;
        iconColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: iconColor, size: 20),
    );
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 2) {
      return 'Yesterday';
    } else {
      return '${dateTime.day} ${_getMonthName(dateTime.month)}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
