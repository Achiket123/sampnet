import 'package:flutter/material.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/settings_permissions.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/widgets/role_guard_widget.dart';

// Import sub-pages
import 'package:hackathon/features/settings/presentation/pages/profile_settings_page.dart';
import 'package:hackathon/features/settings/presentation/pages/security_settings_page.dart';
import 'package:hackathon/features/settings/presentation/pages/notification_preferences_settings_page.dart';
import 'package:hackathon/features/settings/presentation/pages/organisation_settings_page.dart';
import 'package:hackathon/features/settings/presentation/pages/billing_settings_page.dart';
import 'package:hackathon/features/settings/presentation/pages/role_permissions_page.dart';
import 'package:hackathon/features/settings/presentation/pages/attendance_policy_page.dart';
import 'package:hackathon/features/settings/presentation/pages/leave_policy_config_page.dart';
import 'package:hackathon/features/settings/presentation/pages/task_type_config_page.dart';
import 'package:hackathon/features/settings/presentation/pages/data_export_page.dart';
import 'package:hackathon/features/settings/presentation/pages/danger_zone_page.dart';
import 'package:hackathon/features/settings/presentation/widgets/settings_nav_item.dart';

class SettingsShellPage extends StatefulWidget {
  static const String routePath = '/settings';
  const SettingsShellPage({super.key});

  @override
  State<SettingsShellPage> createState() => _SettingsShellPageState();
}

class _SettingsShellPageState extends State<SettingsShellPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SettingsSection _currentSection = SettingsSection.profile;

  final Map<SettingsSection, _SettingsSectionData> _sectionData = {
    SettingsSection.profile: _SettingsSectionData(
      icon: Icons.person_outline,
      title: 'Profile Settings',
      page: const ProfileSettingsPage(),
    ),
    SettingsSection.security: _SettingsSectionData(
      icon: Icons.lock_outline,
      title: 'Security',
      page: const SecuritySettingsPage(),
    ),
    SettingsSection.notifications: _SettingsSectionData(
      icon: Icons.notifications_none_outlined,
      title: 'Notifications',
      page: const NotificationPreferencesSettingsPage(),
    ),
    SettingsSection.organisation: _SettingsSectionData(
      icon: Icons.business_outlined,
      title: 'Organisation details',
      page: const OrganisationSettingsPage(),
    ),
    SettingsSection.billing: _SettingsSectionData(
      icon: Icons.credit_card_outlined,
      title: 'Billing & Plans',
      page: const BillingSettingsPage(),
    ),
    SettingsSection.rolePermissions: _SettingsSectionData(
      icon: Icons.admin_panel_settings_outlined,
      title: 'Role Permissions',
      page: const RolePermissionsPage(),
    ),
    SettingsSection.attendancePolicy: _SettingsSectionData(
      icon: Icons.access_time_outlined,
      title: 'Attendance Policy',
      page: const AttendancePolicyPage(),
    ),
    SettingsSection.leavePolicy: _SettingsSectionData(
      icon: Icons.beach_access_outlined,
      title: 'Leave Policy',
      page: const LeavePolicyConfigPage(),
    ),
    SettingsSection.taskTypes: _SettingsSectionData(
      icon: Icons.assignment_outlined,
      title: 'Task Types',
      page: const TaskTypeConfigPage(),
    ),
    SettingsSection.dataExport: _SettingsSectionData(
      icon: Icons.download_outlined,
      title: 'Data Export',
      page: const DataExportPage(),
    ),
    SettingsSection.dangerZone: _SettingsSectionData(
      icon: Icons.report_problem_outlined,
      title: 'Danger Zone',
      page: const DangerZonePage(),
    ),
  };

  @override
  Widget build(BuildContext context) {
    final String userRole = getIt<User>().role;
    final List<SettingsSection> visibleSections = SettingsSection.values
        .where((section) => canView(section, userRole))
        .toList();

    // Ensure currently selected section is viewable, fallback to profile
    if (!visibleSections.contains(_currentSection)) {
      _currentSection = visibleSections.first;
    }

    final double width = MediaQuery.of(context).size.width;
    final bool isDesktop = width > 850;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorPallete.backgroundPrimary,
            ColorPallete.backgroundSecondary,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: isDesktop
            ? null
            : AppBar(
                backgroundColor: ColorPallete.backgroundSecondary,
                elevation: 0,
                title: Text(
                  _sectionData[_currentSection]?.title ?? 'Settings',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorPallete.textPrimary,
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.menu, color: ColorPallete.textPrimary),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
              ),
        drawer: isDesktop
            ? null
            : Drawer(
                backgroundColor: ColorPallete.backgroundSecondary,
                child: Column(
                  children: [
                    const SizedBox(height: 48),
                    const Text(
                      'SETTINGS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorPallete.redPrimary,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const Divider(color: ColorPallete.divider, height: 32),
                    Expanded(
                      child: ListView(
                        children: visibleSections.map((section) {
                          final data = _sectionData[section]!;
                          return SettingsNavItem(
                            icon: data.icon,
                            title: data.title,
                            section: section,
                            isSelected: _currentSection == section,
                            onTap: () {
                              setState(() {
                                _currentSection = section;
                              });
                              Navigator.pop(context); // Close drawer
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
        body: Row(
          children: [
            if (isDesktop) ...[
              // Left desktop sidebar
              Container(
                width: 280,
                decoration: const BoxDecoration(
                  color: ColorPallete.backgroundSecondary,
                  border: Border(
                    right: BorderSide(color: ColorPallete.divider),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: ColorPallete.textPrimary),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'SETTINGS',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ColorPallete.textPrimary,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: ColorPallete.divider, height: 1),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: visibleSections.map((section) {
                          final data = _sectionData[section]!;
                          return SettingsNavItem(
                            icon: data.icon,
                            title: data.title,
                            section: section,
                            isSelected: _currentSection == section,
                            onTap: () {
                              setState(() {
                                _currentSection = section;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Main content area
            Expanded(
              child: RoleGuardWidget(
                section: _currentSection,
                child: _sectionData[_currentSection]!.page,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSectionData {
  final IconData icon;
  final String title;
  final Widget page;

  const _SettingsSectionData({
    required this.icon,
    required this.title,
    required this.page,
  });
}
