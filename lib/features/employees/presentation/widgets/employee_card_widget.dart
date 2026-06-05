import 'package:flutter/material.dart';
import 'package:hackathon/features/employees/domain/entities/employee_entity.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/services/websocket_service.dart';

import 'package:hackathon/globals/constants/user.dart';

class EmployeeCardWidget extends StatelessWidget {
  final EmployeeEntity employee;
  final String userRole;
  final bool isDeleting;
  final VoidCallback onTap;
  final Function(String action) onAction;

  const EmployeeCardWidget({
    super.key,
    required this.employee,
    required this.userRole,
    this.isDeleting = false,
    required this.onTap,
    required this.onAction,
  });

  Color _getAvatarColor() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];
    return colors[employee.userId % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white10),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: _getAvatarColor(),
              backgroundImage: employee.user.profilePic.isNotEmpty
                  ? NetworkImage(employee.user.profilePic)
                  : null,
              child: employee.user.profilePic.isEmpty
                  ? Text(
                      employee.user.initials,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            ValueListenableBuilder<List<int>>(
              valueListenable: getIt<WebsocketService>().onlineUsersNotifier,
              builder: (context, onlineUsers, _) {
                final isOnline = onlineUsers.contains(employee.userId);
                if (!isOnline) return const SizedBox.shrink();

                return Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color.fromARGB(255, 30, 30, 30), width: 2),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        title: Text(
          employee.user.fullName,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            employee.type.isNotEmpty ? employee.type : employee.user.email,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13),
          ),
        ),
        trailing: isDeleting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : _buildTrailing(context),
      ),
    );
  }

  Widget? _buildTrailing(BuildContext context) {
    final currentUserId = getIt<User>().user?.id;
    final isMe = employee.userId == currentUserId;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isMe)
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.blueAccent),
            onPressed: () => onAction('chat'),
          ),
        if (userRole == 'boss' || userRole == 'manager')
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            onSelected: onAction,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'profile', child: Text('View Profile')),
              if (userRole == 'boss' && employee.roleDisplayLabel != 'Manager')
                const PopupMenuItem(value: 'make_manager', child: Text('Make Manager')),
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              if (userRole == 'boss')
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Remove', style: TextStyle(color: Colors.redAccent)),
                ),
            ],
          ),
      ],
    );
  }
}
