import 'package:equatable/equatable.dart';
import 'package:hackathon/features/settings/domain/entities/notification_preferences_entity.dart';

abstract class ProfileSettingsState extends Equatable {
  const ProfileSettingsState();

  @override
  List<Object?> get props => [];
}

class ProfileSettingsInitial extends ProfileSettingsState {}

class ProfileSettingsLoading extends ProfileSettingsState {}

class ProfileSettingsError extends ProfileSettingsState {
  final String message;
  const ProfileSettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileLoaded extends ProfileSettingsState {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;

  const ProfileLoaded({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, phoneNumber];
}

class NotificationPreferencesLoaded extends ProfileSettingsState {
  final List<NotificationPreferenceEntry> preferences;
  const NotificationPreferencesLoaded(this.preferences);

  @override
  List<Object?> get props => [preferences];
}

class ProfileActionSuccess extends ProfileSettingsState {
  final String message;
  const ProfileActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
