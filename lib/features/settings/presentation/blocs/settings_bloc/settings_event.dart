import 'package:equatable/equatable.dart';
import 'package:hackathon/features/settings/domain/entities/org_settings_entity.dart';
import 'package:hackathon/features/settings/domain/entities/attendance_policy_entity.dart';
import 'package:hackathon/features/settings/domain/entities/leave_policy_entity.dart';
import 'package:hackathon/features/settings/domain/entities/task_type_entity.dart';
import 'package:hackathon/features/settings/domain/entities/role_permissions_entity.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrgSettingsEvent extends SettingsEvent {}

class UpdateOrgSettingsEvent extends SettingsEvent {
  final OrgSettings settings;
  const UpdateOrgSettingsEvent(this.settings);

  @override
  List<Object?> get props => [settings];
}

class LoadOrgPlanEvent extends SettingsEvent {}

class LoadRolePermissionsEvent extends SettingsEvent {}

class UpdateRolePermissionsEvent extends SettingsEvent {
  final List<RolePermissions> permissions;
  const UpdateRolePermissionsEvent(this.permissions);

  @override
  List<Object?> get props => [permissions];
}

class LoadAttendancePolicyEvent extends SettingsEvent {}

class UpdateAttendancePolicyEvent extends SettingsEvent {
  final AttendancePolicyConfig policy;
  const UpdateAttendancePolicyEvent(this.policy);

  @override
  List<Object?> get props => [policy];
}

class LoadLeavePoliciesEvent extends SettingsEvent {}

class UpdateLeavePoliciesEvent extends SettingsEvent {
  final List<LeaveTypeConfig> policies;
  const UpdateLeavePoliciesEvent(this.policies);

  @override
  List<Object?> get props => [policies];
}

class LoadTaskTypesEvent extends SettingsEvent {}

class CreateTaskTypeEvent extends SettingsEvent {
  final TaskTypeConfig taskType;
  const CreateTaskTypeEvent(this.taskType);

  @override
  List<Object?> get props => [taskType];
}

class UpdateTaskTypeEvent extends SettingsEvent {
  final TaskTypeConfig taskType;
  const UpdateTaskTypeEvent(this.taskType);

  @override
  List<Object?> get props => [taskType];
}

class DeleteTaskTypeEvent extends SettingsEvent {
  final int id;
  const DeleteTaskTypeEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ExportOrgDataEvent extends SettingsEvent {}

class DeleteOrganisationEvent extends SettingsEvent {}
