import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/notifications/presentation/blocs/notifications_bloc/notifications_bloc.dart';
import 'package:hackathon/features/notifications/presentation/blocs/notifications_bloc/notifications_event.dart';

class NotificationPreferencesPage extends StatefulWidget {
  static const String routePath = '/notification-preferences';
  static const String routeName = 'notification-preferences';
  const NotificationPreferencesPage({super.key});

  @override
  State<NotificationPreferencesPage> createState() => _NotificationPreferencesPageState();
}

class _NotificationPreferencesPageState extends State<NotificationPreferencesPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<NotificationsBloc>();
    final filter = bloc.typeFilter;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 20, 20),
      appBar: AppBar(
        title: const Text('Notification Preferences'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildPreferenceTile(
            title: 'Task assigned to me',
            subtitle: 'Get notified when someone assigns you a task',
            value: filter.isEnabled('task_assigned'),
            onChanged: (val) => _updatePreference('task_assigned', val),
          ),
          _buildPreferenceTile(
            title: 'Comments on my tasks',
            subtitle: 'Get notified when someone comments on your task',
            value: filter.isEnabled('task_comment'),
            onChanged: (val) => _updatePreference('task_comment', val),
          ),
          _buildPreferenceTile(
            title: 'Task updates',
            subtitle: 'Get notified when a task you are involved in changes',
            value: filter.isEnabled('task_updated'),
            onChanged: (val) => _updatePreference('task_updated', val),
          ),
          const Divider(color: Colors.white10),
          _buildPreferenceTile(
            title: 'Leave request submitted',
            subtitle: 'Get notified when a team member requests leave',
            value: filter.isEnabled('leave_request'),
            onChanged: (val) => _updatePreference('leave_request', val),
          ),
          _buildPreferenceTile(
            title: 'Leave request status',
            subtitle: 'Get notified when your leave is approved or rejected',
            value: filter.isEnabled('leave_approved') || filter.isEnabled('leave_rejected'),
            onChanged: (val) {
              _updatePreference('leave_approved', val);
              _updatePreference('leave_rejected', val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blueAccent,
    );
  }

  void _updatePreference(String type, bool val) async {
    final bloc = context.read<NotificationsBloc>();
    await bloc.typeFilter.setFilter(type, val);
    bloc.add(NotificationsLoadRequested()); // Refresh list with new filters
    setState(() {});
  }
}
