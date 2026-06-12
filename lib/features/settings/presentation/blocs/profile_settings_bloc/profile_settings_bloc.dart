import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/features/auth/domain/entity/user_entity.dart';
import 'package:hackathon/features/settings/domain/use_cases/update_profile_use_case.dart';
import 'package:hackathon/features/settings/domain/use_cases/change_password_use_case.dart';
import 'package:hackathon/features/settings/domain/use_cases/get_notification_preferences_use_case.dart';
import 'package:hackathon/features/settings/domain/use_cases/update_notification_preferences_use_case.dart';
import 'profile_settings_event.dart';
import 'profile_settings_state.dart';

class ProfileSettingsBloc extends Bloc<ProfileSettingsEvent, ProfileSettingsState> {
  final UpdateProfileUseCase updateProfileUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final GetNotificationPreferencesUseCase getNotificationPreferencesUseCase;
  final UpdateNotificationPreferencesUseCase updateNotificationPreferencesUseCase;

  ProfileSettingsBloc({
    required this.updateProfileUseCase,
    required this.changePasswordUseCase,
    required this.getNotificationPreferencesUseCase,
    required this.updateNotificationPreferencesUseCase,
  }) : super(ProfileSettingsInitial()) {
    on<LoadProfileSettingsEvent>(_onLoadProfile);
    on<UpdateProfileSettingsEvent>(_onUpdateProfile);
    on<ChangePasswordSettingsEvent>(_onChangePassword);
    on<LoadNotificationPreferencesEvent>(_onLoadNotificationPreferences);
    on<UpdateNotificationPreferencesEvent>(_onUpdateNotificationPreferences);
  }

  void _onLoadProfile(LoadProfileSettingsEvent event, Emitter<ProfileSettingsState> emit) {
    final userContainer = getIt<User>();
    if (userContainer.user != null) {
      final u = userContainer.user!;
      emit(ProfileLoaded(
        firstName: u.firstName,
        lastName: u.lastName,
        email: u.email,
        phoneNumber: u.phoneNumber,
      ));
    } else {
      emit(const ProfileSettingsError("User not logged in"));
    }
  }

  Future<void> _onUpdateProfile(UpdateProfileSettingsEvent event, Emitter<ProfileSettingsState> emit) async {
    emit(ProfileSettingsLoading());
    final result = await updateProfileUseCase(event.firstName, event.lastName, event.phoneNumber);
    result.fold(
      (failure) => emit(ProfileSettingsError(failure.message)),
      (_) {
        // Update global user singleton
        final userContainer = getIt<User>();
        if (userContainer.user != null) {
          final u = userContainer.user!;
          userContainer.user = UserEntity(
            id: u.id,
            firstName: event.firstName,
            lastName: event.lastName,
            email: u.email,
            phoneNumber: event.phoneNumber,
            isVerified: u.isVerified,
            hashedPassword: u.hashedPassword,
            profilePic: u.profilePic,
            city: u.city,
            country: u.country,
            lastLoginAt: u.lastLoginAt,
          );
        }
        emit(const ProfileActionSuccess("Profile updated successfully"));
        add(LoadProfileSettingsEvent());
      },
    );
  }

  Future<void> _onChangePassword(ChangePasswordSettingsEvent event, Emitter<ProfileSettingsState> emit) async {
    emit(ProfileSettingsLoading());
    final result = await changePasswordUseCase(event.oldPassword, event.newPassword);
    result.fold(
      (failure) => emit(ProfileSettingsError(failure.message)),
      (_) => emit(const ProfileActionSuccess("Password changed successfully")),
    );
  }

  Future<void> _onLoadNotificationPreferences(LoadNotificationPreferencesEvent event, Emitter<ProfileSettingsState> emit) async {
    emit(ProfileSettingsLoading());
    final result = await getNotificationPreferencesUseCase();
    result.fold(
      (failure) => emit(ProfileSettingsError(failure.message)),
      (preferences) => emit(NotificationPreferencesLoaded(preferences)),
    );
  }

  Future<void> _onUpdateNotificationPreferences(UpdateNotificationPreferencesEvent event, Emitter<ProfileSettingsState> emit) async {
    emit(ProfileSettingsLoading());
    final result = await updateNotificationPreferencesUseCase(event.preferences);
    result.fold(
      (failure) => emit(ProfileSettingsError(failure.message)),
      (_) => emit(const ProfileActionSuccess("Notification preferences updated successfully")),
    );
  }
}
