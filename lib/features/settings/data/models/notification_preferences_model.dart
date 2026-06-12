import 'package:hackathon/features/settings/domain/entities/notification_preferences_entity.dart';

class NotificationPreferenceModel extends NotificationPreferenceEntry {
  NotificationPreferenceModel({
    required super.category,
    required super.email,
    required super.push,
    required super.inApp,
  });

  factory NotificationPreferenceModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferenceModel(
      category: json['category'] as String? ?? '',
      email: json['email'] as bool? ?? false,
      push: json['push'] as bool? ?? false,
      inApp: json['in_app'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'email': email,
      'push': push,
      'in_app': inApp,
    };
  }
}
