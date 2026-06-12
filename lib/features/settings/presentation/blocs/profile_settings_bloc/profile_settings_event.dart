import 'package:equatable/equatable.dart';
import 'package:hackathon/features/settings/domain/entities/notification_preferences_entity.dart';

abstract class ProfileSettingsEvent extends Equatable {
  const ProfileSettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileSettingsEvent extends ProfileSettingsEvent {}

class UpdateProfileSettingsEvent extends ProfileSettingsEvent {
  final String firstName;
  final String lastName;
  final String phoneNumber;

  const UpdateProfileSettingsEvent({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [firstName, lastName, phoneNumber];
}

class ChangePasswordSettingsEvent extends ProfileSettingsEvent {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordSettingsEvent({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword];
}

class LoadNotificationPreferencesEvent extends ProfileSettingsEvent {}

class UpdateNotificationPreferencesEvent extends ProfileSettingsEvent {
  final List<NotificationPreferenceEntry> preferences;

  const UpdateNotificationPreferencesEvent(this.preferences);

  @override
  List<Object?> get props => [preferences];
}
