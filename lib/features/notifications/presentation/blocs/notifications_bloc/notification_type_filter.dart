import 'package:hackathon/features/notifications/domain/entities/notification_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificationTypeFilter {
  static const String _boxName = 'notification_preferences';
  
  static const String _kTaskAssigned = 'task_assigned';
  static const String _kTaskComment = 'task_comment';
  static const String _kTaskUpdated = 'task_updated';
  static const String _kLeaveRequest = 'leave_request';
  static const String _kLeaveApproved = 'leave_approved';
  static const String _kLeaveRejected = 'leave_rejected';

  final Map<String, bool> _filters = {};

  Future<void> load() async {
    final box = await Hive.openBox(_boxName);
    _filters['task_assigned'] = box.get(_kTaskAssigned, defaultValue: true) as bool;
    _filters['task_comment'] = box.get(_kTaskComment, defaultValue: true) as bool;
    _filters['task_updated'] = box.get(_kTaskUpdated, defaultValue: true) as bool;
    _filters['leave_request'] = box.get(_kLeaveRequest, defaultValue: true) as bool;
    _filters['leave_approved'] = box.get(_kLeaveApproved, defaultValue: true) as bool;
    _filters['leave_rejected'] = box.get(_kLeaveRejected, defaultValue: true) as bool;
    _filters['general'] = true; // Always enabled
  }

  List<NotificationEntity> apply(List<NotificationEntity> all) {
    return all.where((n) => _filters[n.type] ?? true).toList();
  }

  Future<void> setFilter(String type, bool enabled) async {
    _filters[type] = enabled;
    final box = await Hive.openBox(_boxName);
    await box.put(type, enabled);
  }

  bool isEnabled(String type) => _filters[type] ?? true;
}
