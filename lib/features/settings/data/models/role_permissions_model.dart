import 'package:hackathon/features/settings/domain/entities/role_permissions_entity.dart';

class RolePermissionsModel extends RolePermissions {
  RolePermissionsModel({
    required super.role,
    required super.permissions,
  });

  factory RolePermissionsModel.fromJson(Map<String, dynamic> json) {
    final permissionsRaw = json['permissions'] as List<dynamic>? ?? [];
    return RolePermissionsModel(
      role: json['role'] as String? ?? 'employee',
      permissions: permissionsRaw.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'permissions': permissions,
    };
  }
}
