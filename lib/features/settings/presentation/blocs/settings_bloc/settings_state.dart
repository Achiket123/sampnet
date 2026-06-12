import 'package:equatable/equatable.dart';
import 'package:hackathon/features/settings/domain/entities/org_settings_entity.dart';
import 'package:hackathon/features/settings/domain/entities/plan_entity.dart';
import 'package:hackathon/features/settings/domain/entities/role_permissions_entity.dart';
import 'package:hackathon/features/settings/domain/entities/attendance_policy_entity.dart';
import 'package:hackathon/features/settings/domain/entities/leave_policy_entity.dart';
import 'package:hackathon/features/settings/domain/entities/task_type_entity.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsError extends SettingsState {
  final String message;
  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class OrgSettingsLoaded extends SettingsState {
  final OrgSettings settings;
  const OrgSettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

class OrgPlanLoaded extends SettingsState {
  final OrgPlan plan;
  const OrgPlanLoaded(this.plan);

  @override
  List<Object?> get props => [plan];
}

class RolePermissionsLoaded extends SettingsState {
  final List<RolePermissions> permissions;
  const RolePermissionsLoaded(this.permissions);

  @override
  List<Object?> get props => [permissions];
}

class AttendancePolicyLoaded extends SettingsState {
  final AttendancePolicyConfig policy;
  const AttendancePolicyLoaded(this.policy);

  @override
  List<Object?> get props => [policy];
}

class LeavePoliciesLoaded extends SettingsState {
  final List<LeaveTypeConfig> policies;
  const LeavePoliciesLoaded(this.policies);

  @override
  List<Object?> get props => [policies];
}

class TaskTypesLoaded extends SettingsState {
  final List<TaskTypeConfig> taskTypes;
  const TaskTypesLoaded(this.taskTypes);

  @override
  List<Object?> get props => [taskTypes];
}

class ExportDataLoaded extends SettingsState {
  final String data;
  const ExportDataLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class SettingsActionSuccess extends SettingsState {
  final String message;
  const SettingsActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
