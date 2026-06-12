class SettingsAccess {
  final Set<String> viewRoles;
  final Set<String> editRoles;

  const SettingsAccess({
    required this.viewRoles,
    required this.editRoles,
  });
}

enum SettingsSection {
  profile,
  security,
  notifications,
  organisation,
  billing,
  rolePermissions,
  attendancePolicy,
  leavePolicy,
  taskTypes,
  dataExport,
  dangerZone,
}

const Map<SettingsSection, SettingsAccess> settingsAccessMap = {
  SettingsSection.profile: SettingsAccess(
    viewRoles: {'employee', 'manager', 'boss'},
    editRoles: {'employee', 'manager', 'boss'},
  ),
  SettingsSection.security: SettingsAccess(
    viewRoles: {'employee', 'manager', 'boss'},
    editRoles: {'employee', 'manager', 'boss'},
  ),
  SettingsSection.notifications: SettingsAccess(
    viewRoles: {'employee', 'manager', 'boss'},
    editRoles: {'employee', 'manager', 'boss'},
  ),
  SettingsSection.organisation: SettingsAccess(
    viewRoles: {'boss', 'manager'},
    editRoles: {'boss'},
  ),
  SettingsSection.billing: SettingsAccess(
    viewRoles: {'boss', 'manager'},
    editRoles: {'boss'},
  ),
  SettingsSection.rolePermissions: SettingsAccess(
    viewRoles: {'boss'},
    editRoles: {'boss'},
  ),
  SettingsSection.attendancePolicy: SettingsAccess(
    viewRoles: {'boss', 'manager'},
    editRoles: {'boss'},
  ),
  SettingsSection.leavePolicy: SettingsAccess(
    viewRoles: {'boss', 'manager'},
    editRoles: {'boss'},
  ),
  SettingsSection.taskTypes: SettingsAccess(
    viewRoles: {'boss', 'manager'},
    editRoles: {'boss', 'manager'},
  ),
  SettingsSection.dataExport: SettingsAccess(
    viewRoles: {'boss'},
    editRoles: {'boss'},
  ),
  SettingsSection.dangerZone: SettingsAccess(
    viewRoles: {'boss'},
    editRoles: {'boss'},
  ),
};

bool canView(SettingsSection section, String role) {
  final access = settingsAccessMap[section];
  if (access == null) return false;
  return access.viewRoles.contains(role);
}

bool canEdit(SettingsSection section, String role) {
  final access = settingsAccessMap[section];
  if (access == null) return false;
  return access.editRoles.contains(role);
}
