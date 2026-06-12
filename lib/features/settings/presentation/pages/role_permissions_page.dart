import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/features/settings/domain/entities/role_permissions_entity.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_bloc.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_event.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_state.dart';

class RolePermissionsPage extends StatefulWidget {
  const RolePermissionsPage({super.key});

  @override
  State<RolePermissionsPage> createState() => _RolePermissionsPageState();
}

class _RolePermissionsPageState extends State<RolePermissionsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _roles = ['employee', 'manager', 'boss'];
  final List<String> _allPermissions = [
    'view_profile',
    'edit_profile',
    'request_leave',
    'approve_leave',
    'check_in',
    'check_out',
    'view_organisation_settings',
    'edit_organisation_settings',
    'manage_roles',
    'view_billing',
    'delete_organisation'
  ];

  final Map<String, List<String>> _rolePermissionsMap = {
    'employee': [],
    'manager': [],
    'boss': [],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _roles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsBloc>()..add(LoadRolePermissionsEvent()),
      child: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is RolePermissionsLoaded) {
            setState(() {
              for (var rp in state.permissions) {
                if (_rolePermissionsMap.containsKey(rp.role)) {
                  _rolePermissionsMap[rp.role] = List.from(rp.permissions);
                }
              }
            });
          } else if (state is SettingsActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ColorPallete.success,
              ),
            );
          } else if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ColorPallete.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is SettingsLoading;

          return Scaffold(
            backgroundColor: ColorPallete.backgroundPrimary,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Role & Permissions',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: ColorPallete.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Define granular access control and permissions for default organizational roles.',
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorPallete.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: ColorPallete.backgroundSecondary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: ColorPallete.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TabBar(
                          controller: _tabController,
                          indicatorColor: ColorPallete.redPrimary,
                          labelColor: ColorPallete.textPrimary,
                          unselectedLabelColor: ColorPallete.textSecondary,
                          dividerColor: ColorPallete.divider,
                          tabs: _roles.map((role) => Tab(text: role.toUpperCase())).toList(),
                        ),
                        SizedBox(
                          height: 450,
                          child: TabBarView(
                            controller: _tabController,
                            children: _roles.map((role) {
                              final currentPerms = _rolePermissionsMap[role] ?? [];
                              return _buildPermissionsList(context, role, currentPerms, isLoading);
                            }).toList(),
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

  Widget _buildPermissionsList(
    BuildContext context,
    String role,
    List<String> currentPerms,
    bool isLoading,
  ) {
    if (isLoading && currentPerms.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: ColorPallete.redPrimary));
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _allPermissions.length,
              itemBuilder: (context, index) {
                final perm = _allPermissions[index];
                final bool hasPerm = currentPerms.contains(perm);
                final String prettyPermName = perm.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');

                return SwitchListTile(
                  title: Text(
                    prettyPermName,
                    style: const TextStyle(color: ColorPallete.textPrimary, fontSize: 15),
                  ),
                  subtitle: Text(
                    'Allows users with the "$role" role to perform $prettyPermName operations.',
                    style: const TextStyle(color: ColorPallete.textSecondary, fontSize: 12),
                  ),
                  value: hasPerm,
                  activeColor: ColorPallete.redPrimary,
                  onChanged: (val) {
                    setState(() {
                      if (val) {
                        _rolePermissionsMap[role]!.add(perm);
                      } else {
                        _rolePermissionsMap[role]!.remove(perm);
                      }
                    });
                  },
                );
              },
            ),
          ),
          const Divider(color: ColorPallete.divider, height: 24),
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
                      context.read<SettingsBloc>().add(
                            UpdateRolePermissionsEvent([
                              RolePermissions(
                                role: role,
                                permissions: _rolePermissionsMap[role]!,
                              ),
                            ]),
                          );
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
                      'Save Permissions',
                      style: TextStyle(
                        color: ColorPallete.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
