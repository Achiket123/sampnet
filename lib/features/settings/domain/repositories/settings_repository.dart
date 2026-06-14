import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/settings/domain/entities/org_settings_entity.dart';
import 'package:hackathon/features/settings/domain/entities/plan_entity.dart';
import 'package:hackathon/features/settings/domain/entities/role_permissions_entity.dart';
import 'package:hackathon/features/settings/domain/entities/attendance_policy_entity.dart';
import 'package:hackathon/features/settings/domain/entities/leave_policy_entity.dart';
import 'package:hackathon/features/settings/domain/entities/task_type_entity.dart';
import 'package:hackathon/features/settings/domain/entities/notification_preferences_entity.dart';

abstract class SettingsRepository {
  Future<Either<ErrorModel, OrgSettings>> getOrgSettings();
  Future<Either<ErrorModel, OrgSettings>> updateOrgSettings(OrgSettings settings);

  Future<Either<ErrorModel, OrgPlan>> getOrgPlan();

  Future<Either<ErrorModel, List<RolePermissions>>> getRolePermissions();
  Future<Either<ErrorModel, void>> updateRolePermissions(List<RolePermissions> permissions);

  Future<Either<ErrorModel, AttendancePolicyConfig>> getAttendancePolicy();
  Future<Either<ErrorModel, AttendancePolicyConfig>> updateAttendancePolicy(AttendancePolicyConfig policy);

  Future<Either<ErrorModel, List<LeaveTypeConfig>>> getLeavePolicies();
  Future<Either<ErrorModel, void>> updateLeavePolicies(List<LeaveTypeConfig> policies);

  Future<Either<ErrorModel, List<TaskTypeConfig>>> getTaskTypes();
  Future<Either<ErrorModel, TaskTypeConfig>> createTaskType(TaskTypeConfig taskType);
  Future<Either<ErrorModel, TaskTypeConfig>> updateTaskType(TaskTypeConfig taskType);
  Future<Either<ErrorModel, void>> deleteTaskType(int id);

  Future<Either<ErrorModel, void>> changePassword(String oldPassword, String newPassword);
  Future<Either<ErrorModel, void>> updateProfile(String firstName, String lastName, String phoneNumber, {String? profilePicFileId});

  Future<Either<ErrorModel, List<NotificationPreferenceEntry>>> getNotificationPreferences();
  Future<Either<ErrorModel, void>> updateNotificationPreferences(List<NotificationPreferenceEntry> preferences);

  Future<Either<ErrorModel, String>> exportOrgData();
  Future<Either<ErrorModel, void>> deleteOrganisation();
}
