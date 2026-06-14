import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/services/api_client.dart';
import 'package:hackathon/features/settings/data/models/org_settings_model.dart';
import 'package:hackathon/features/settings/data/models/plan_model.dart';
import 'package:hackathon/features/settings/data/models/role_permissions_model.dart';
import 'package:hackathon/features/settings/data/models/attendance_policy_model.dart';
import 'package:hackathon/features/settings/data/models/leave_policy_model.dart';
import 'package:hackathon/features/settings/data/models/task_type_model.dart';
import 'package:hackathon/features/settings/data/models/notification_preferences_model.dart';

abstract class SettingsRemoteDataSource {
  Future<OrgSettingsModel> getOrgSettings();
  Future<OrgSettingsModel> updateOrgSettings(OrgSettingsModel settings);
  
  Future<OrgPlanModel> getOrgPlan();
  
  Future<List<RolePermissionsModel>> getRolePermissions();
  Future<void> updateRolePermissions(List<RolePermissionsModel> permissions);
  
  Future<AttendancePolicyModel> getAttendancePolicy();
  Future<AttendancePolicyModel> updateAttendancePolicy(AttendancePolicyModel policy);
  
  Future<List<LeaveTypeConfigModel>> getLeavePolicies();
  Future<void> updateLeavePolicies(List<LeaveTypeConfigModel> policies);
  
  Future<List<TaskTypeConfigModel>> getTaskTypes();
  Future<TaskTypeConfigModel> createTaskType(TaskTypeConfigModel taskType);
  Future<TaskTypeConfigModel> updateTaskType(TaskTypeConfigModel taskType);
  Future<void> deleteTaskType(int id);
  
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<void> updateProfile(String firstName, String lastName, String phoneNumber, {String? profilePicFileId});
  
  Future<List<NotificationPreferenceModel>> getNotificationPreferences();
  Future<void> updateNotificationPreferences(List<NotificationPreferenceModel> preferences);
  
  Future<String> exportOrgData();
  Future<void> deleteOrganisation();
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final ApiClient apiClient;

  SettingsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<OrgSettingsModel> getOrgSettings() async {
    final response = await apiClient.get('${ApiConstants.settingsOrganisation}');
    if (response.statusCode == 200) {
      return OrgSettingsModel.fromJson(jsonDecode(response.body)['organisation']);
    }
    throw Exception('Failed to load organisation settings: ${response.body}');
  }

  @override
  Future<OrgSettingsModel> updateOrgSettings(OrgSettingsModel settings) async {
    final response = await apiClient.put(
      '${ApiConstants.settingsOrganisation}',
      body: settings.toJson(),
    );
    if (response.statusCode == 200) {
      return OrgSettingsModel.fromJson(jsonDecode(response.body)['organisation']);
    }
    throw Exception('Failed to update organisation settings: ${response.body}');
  }

  @override
  Future<OrgPlanModel> getOrgPlan() async {
    final response = await apiClient.get('${ApiConstants.settingsPlan}');
    if (response.statusCode == 200) {
      return OrgPlanModel.fromJson(jsonDecode(response.body)['plan']);
    }
    throw Exception('Failed to load organisation plan: ${response.body}');
  }

  @override
  Future<List<RolePermissionsModel>> getRolePermissions() async {
    final response = await apiClient.get('${ApiConstants.settingsRolePermissions}');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['role_permissions'];
      return data.map((json) => RolePermissionsModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load role permissions: ${response.body}');
  }

  @override
  Future<void> updateRolePermissions(List<RolePermissionsModel> permissions) async {
    final response = await apiClient.put(
      '${ApiConstants.settingsRolePermissions}',
      body: {
        'role_permissions': permissions.map((p) => p.toJson()).toList(),
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update role permissions: ${response.body}');
    }
  }

  @override
  Future<AttendancePolicyModel> getAttendancePolicy() async {
    final response = await apiClient.get('${ApiConstants.settingsAttendancePolicy}');
    if (response.statusCode == 200) {
      return AttendancePolicyModel.fromJson(jsonDecode(response.body)['attendance_policy']);
    }
    throw Exception('Failed to load attendance policy: ${response.body}');
  }

  @override
  Future<AttendancePolicyModel> updateAttendancePolicy(AttendancePolicyModel policy) async {
    final response = await apiClient.put(
      '${ApiConstants.settingsAttendancePolicy}',
      body: policy.toJson(),
    );
    if (response.statusCode == 200) {
      return AttendancePolicyModel.fromJson(jsonDecode(response.body)['attendance_policy']);
    }
    throw Exception('Failed to update attendance policy: ${response.body}');
  }

  @override
  Future<List<LeaveTypeConfigModel>> getLeavePolicies() async {
    final response = await apiClient.get('${ApiConstants.settingsLeavePolicy}');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['leave_policies'];
      return data.map((json) => LeaveTypeConfigModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load leave policies: ${response.body}');
  }

  @override
  Future<void> updateLeavePolicies(List<LeaveTypeConfigModel> policies) async {
    final response = await apiClient.put(
      '${ApiConstants.settingsLeavePolicy}',
      body: {
        'leave_policies': policies.map((p) => p.toJson()).toList(),
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update leave policies: ${response.body}');
    }
  }

  @override
  Future<List<TaskTypeConfigModel>> getTaskTypes() async {
    final response = await apiClient.get('${ApiConstants.settingsTaskTypes}');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['task_types'];
      return data.map((json) => TaskTypeConfigModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load task types: ${response.body}');
  }

  @override
  Future<TaskTypeConfigModel> createTaskType(TaskTypeConfigModel taskType) async {
    final response = await apiClient.post(
      '${ApiConstants.settingsTaskTypes}',
      body: taskType.toJson(),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return TaskTypeConfigModel.fromJson(jsonDecode(response.body)['task_type']);
    }
    throw Exception('Failed to create task type: ${response.body}');
  }

  @override
  Future<TaskTypeConfigModel> updateTaskType(TaskTypeConfigModel taskType) async {
    final response = await apiClient.put(
      '${ApiConstants.settingsTaskTypes}/${taskType.id}',
      body: taskType.toJson(),
    );
    if (response.statusCode == 200) {
      return TaskTypeConfigModel.fromJson(jsonDecode(response.body)['task_type']);
    }
    throw Exception('Failed to update task type: ${response.body}');
  }

  @override
  Future<void> deleteTaskType(int id) async {
    final response = await apiClient.delete(
      '${ApiConstants.settingsTaskTypes}/$id',
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task type: ${response.body}');
    }
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    final response = await apiClient.put(
      '${ApiConstants.settingsChangePassword}',
      body: {
        'old_password': oldPassword,
        'new_password': newPassword,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to change password: ${response.body}');
    }
  }

  @override
  Future<void> updateProfile(String firstName, String lastName, String phoneNumber, {String? profilePicFileId}) async {
    final response = await apiClient.put(
      '${ApiConstants.settingsProfile}',
      body: {
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
        if (profilePicFileId != null) 'profile_id': profilePicFileId,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }

  @override
  Future<List<NotificationPreferenceModel>> getNotificationPreferences() async {
    final response = await apiClient.get('${ApiConstants.settingsNotificationPreferences}');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['notification_preferences'];
      return data.map((json) => NotificationPreferenceModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load notification preferences: ${response.body}');
  }

  @override
  Future<void> updateNotificationPreferences(List<NotificationPreferenceModel> preferences) async {
    final response = await apiClient.put(
      '${ApiConstants.settingsNotificationPreferences}',
      body: {
        'notification_preferences': preferences.map((p) => p.toJson()).toList(),
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update notification preferences: ${response.body}');
    }
  }

  @override
  Future<String> exportOrgData() async {
    final response = await apiClient.get('${ApiConstants.settingsExport}');
    if (response.statusCode == 200) {
      return response.body;
    }
    throw Exception('Failed to export organisation data: ${response.body}');
  }

  @override
  Future<void> deleteOrganisation() async {
    final response = await apiClient.delete(
      '${ApiConstants.settingsOrganisation}',
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete organisation: ${response.body}');
    }
  }
}
