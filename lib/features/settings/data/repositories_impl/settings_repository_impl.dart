import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/settings/data/data_sources/settings_remote_data_source.dart';
import 'package:hackathon/features/settings/data/models/org_settings_model.dart';
import 'package:hackathon/features/settings/data/models/role_permissions_model.dart';
import 'package:hackathon/features/settings/data/models/attendance_policy_model.dart';
import 'package:hackathon/features/settings/data/models/leave_policy_model.dart';
import 'package:hackathon/features/settings/data/models/task_type_model.dart';
import 'package:hackathon/features/settings/data/models/notification_preferences_model.dart';
import 'package:hackathon/features/settings/domain/entities/org_settings_entity.dart';
import 'package:hackathon/features/settings/domain/entities/plan_entity.dart';
import 'package:hackathon/features/settings/domain/entities/role_permissions_entity.dart';
import 'package:hackathon/features/settings/domain/entities/attendance_policy_entity.dart';
import 'package:hackathon/features/settings/domain/entities/leave_policy_entity.dart';
import 'package:hackathon/features/settings/domain/entities/task_type_entity.dart';
import 'package:hackathon/features/settings/domain/entities/notification_preferences_entity.dart';
import 'package:hackathon/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;

  SettingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ErrorModel, OrgSettings>> getOrgSettings() async {
    try {
      final res = await remoteDataSource.getOrgSettings();
      return right(res);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, OrgSettings>> updateOrgSettings(OrgSettings settings) async {
    try {
      final model = OrgSettingsModel(
        id: settings.id,
        companyName: settings.companyName,
        companyCode: settings.companyCode,
        primaryContactName: settings.primaryContactName,
        primaryEmail: settings.primaryEmail,
        phoneNumber: settings.phoneNumber,
        officeAddress: settings.officeAddress,
        city: settings.city,
        state: settings.state,
        postalCode: settings.postalCode,
        country: settings.country,
        companyLogo: settings.companyLogo,
        industry: settings.industry,
        billingAddress: settings.billingAddress,
        companySize: settings.companySize,
      );
      final res = await remoteDataSource.updateOrgSettings(model);
      return right(res);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, OrgPlan>> getOrgPlan() async {
    try {
      final res = await remoteDataSource.getOrgPlan();
      return right(res);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<RolePermissions>>> getRolePermissions() async {
    try {
      final res = await remoteDataSource.getRolePermissions();
      return right(res);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> updateRolePermissions(List<RolePermissions> permissions) async {
    try {
      final models = permissions.map((p) => RolePermissionsModel(
        role: p.role,
        permissions: p.permissions,
      )).toList();
      await remoteDataSource.updateRolePermissions(models);
      return right(null);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, AttendancePolicyConfig>> getAttendancePolicy() async {
    try {
      final res = await remoteDataSource.getAttendancePolicy();
      return right(res);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, AttendancePolicyConfig>> updateAttendancePolicy(AttendancePolicyConfig policy) async {
    try {
      final model = AttendancePolicyModel(
        id: policy.id,
        checkInTime: policy.checkInTime,
        checkOutTime: policy.checkOutTime,
        gracePeriodMins: policy.gracePeriodMins,
      );
      final res = await remoteDataSource.updateAttendancePolicy(model);
      return right(res);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<LeaveTypeConfig>>> getLeavePolicies() async {
    try {
      final res = await remoteDataSource.getLeavePolicies();
      return right(res);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> updateLeavePolicies(List<LeaveTypeConfig> policies) async {
    try {
      final models = policies.map((p) => LeaveTypeConfigModel(
        id: p.id,
        leaveType: p.leaveType,
        maxDays: p.maxDays,
        description: p.description,
      )).toList();
      await remoteDataSource.updateLeavePolicies(models);
      return right(null);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<TaskTypeConfig>>> getTaskTypes() async {
    try {
      final res = await remoteDataSource.getTaskTypes();
      return right(res);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, TaskTypeConfig>> createTaskType(TaskTypeConfig taskType) async {
    try {
      final model = TaskTypeConfigModel(
        id: taskType.id,
        name: taskType.name,
        description: taskType.description,
      );
      final res = await remoteDataSource.createTaskType(model);
      return right(res);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, TaskTypeConfig>> updateTaskType(TaskTypeConfig taskType) async {
    try {
      final model = TaskTypeConfigModel(
        id: taskType.id,
        name: taskType.name,
        description: taskType.description,
      );
      final res = await remoteDataSource.updateTaskType(model);
      return right(res);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> deleteTaskType(int id) async {
    try {
      await remoteDataSource.deleteTaskType(id);
      return right(null);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> changePassword(String oldPassword, String newPassword) async {
    try {
      await remoteDataSource.changePassword(oldPassword, newPassword);
      return right(null);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> updateProfile(String firstName, String lastName, String phoneNumber) async {
    try {
      await remoteDataSource.updateProfile(firstName, lastName, phoneNumber);
      return right(null);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<NotificationPreferenceEntry>>> getNotificationPreferences() async {
    try {
      final res = await remoteDataSource.getNotificationPreferences();
      return right(res);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> updateNotificationPreferences(List<NotificationPreferenceEntry> preferences) async {
    try {
      final models = preferences.map((p) => NotificationPreferenceModel(
        category: p.category,
        email: p.email,
        push: p.push,
        inApp: p.inApp,
      )).toList();
      await remoteDataSource.updateNotificationPreferences(models);
      return right(null);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, String>> exportOrgData() async {
    try {
      final res = await remoteDataSource.exportOrgData();
      return right(res);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> deleteOrganisation() async {
    try {
      await remoteDataSource.deleteOrganisation();
      return right(null);
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }
}
