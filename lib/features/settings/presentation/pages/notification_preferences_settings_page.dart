import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/features/settings/domain/entities/notification_preferences_entity.dart';
import 'package:hackathon/features/settings/presentation/blocs/profile_settings_bloc/profile_settings_bloc.dart';
import 'package:hackathon/features/settings/presentation/blocs/profile_settings_bloc/profile_settings_event.dart';
import 'package:hackathon/features/settings/presentation/blocs/profile_settings_bloc/profile_settings_state.dart';

class NotificationPreferencesSettingsPage extends StatefulWidget {
  const NotificationPreferencesSettingsPage({super.key});

  @override
  State<NotificationPreferencesSettingsPage> createState() => _NotificationPreferencesSettingsPageState();
}

class _NotificationPreferencesSettingsPageState extends State<NotificationPreferencesSettingsPage> {
  List<NotificationPreferenceEntry> _preferences = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileSettingsBloc>()..add(LoadNotificationPreferencesEvent()),
      child: BlocConsumer<ProfileSettingsBloc, ProfileSettingsState>(
        listener: (context, state) {
          if (state is NotificationPreferencesLoaded) {
            setState(() {
              _preferences = List.from(state.preferences);
            });
          } else if (state is ProfileActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ColorPallete.success,
              ),
            );
          } else if (state is ProfileSettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ColorPallete.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is ProfileSettingsLoading;

          return Scaffold(
            backgroundColor: ColorPallete.backgroundPrimary,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notification Settings',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: ColorPallete.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose how and where you want to receive alerts and notifications.',
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorPallete.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: ColorPallete.backgroundSecondary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: ColorPallete.divider),
                    ),
                    child: _preferences.isEmpty && isLoading
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: CircularProgressIndicator(color: ColorPallete.redPrimary),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPreferencesHeader(),
                              const Divider(color: ColorPallete.divider, height: 32),
                              ..._preferences.map((pref) => _buildPreferenceRow(context, pref)),
                              const SizedBox(height: 30),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorPallete.redPrimary,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          context
                                              .read<ProfileSettingsBloc>()
                                              .add(UpdateNotificationPreferencesEvent(_preferences));
                                        },
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(ColorPallete.textPrimary),
                                          ),
                                        )
                                      : const Text(
                                          'Save Preferences',
                                          style: TextStyle(
                                            color: ColorPallete.textPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
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
        },
      ),
    );
  }

  Widget _buildPreferencesHeader() {
    return Row(
      children: const [
        Expanded(
          flex: 4,
          child: Text(
            'Notification Category',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: ColorPallete.textPrimary,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: Text(
              'Email',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorPallete.textPrimary,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: Text(
              'Push',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorPallete.textPrimary,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: Text(
              'In-App',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorPallete.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreferenceRow(BuildContext context, NotificationPreferenceEntry preference) {
    String prettyCategory = preference.category[0].toUpperCase() + preference.category.substring(1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prettyCategory,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: ColorPallete.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage $prettyCategory alerts.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: ColorPallete.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Switch(
                value: preference.email,
                activeColor: ColorPallete.redPrimary,
                onChanged: (val) {
                  final idx = _preferences.indexOf(preference);
                  if (idx != -1) {
                    setState(() {
                      _preferences[idx] = preference.copyWith(email: val);
                    });
                  }
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Switch(
                value: preference.push,
                activeColor: ColorPallete.redPrimary,
                onChanged: (val) {
                  final idx = _preferences.indexOf(preference);
                  if (idx != -1) {
                    setState(() {
                      _preferences[idx] = preference.copyWith(push: val);
                    });
                  }
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Switch(
                value: preference.inApp,
                activeColor: ColorPallete.redPrimary,
                onChanged: (val) {
                  final idx = _preferences.indexOf(preference);
                  if (idx != -1) {
                    setState(() {
                      _preferences[idx] = preference.copyWith(inApp: val);
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
