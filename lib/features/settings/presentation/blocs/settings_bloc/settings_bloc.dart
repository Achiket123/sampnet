import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/settings/domain/use_cases/get_org_settings_use_case.dart';
import 'package:hackathon/features/settings/domain/use_cases/update_org_settings_use_case.dart';
import 'package:hackathon/features/settings/domain/use_cases/get_org_plan_use_case.dart';
import 'package:hackathon/features/settings/domain/use_cases/get_role_permissions_use_case.dart';
import 'package:hackathon/features/settings/domain/use_cases/update_role_permissions_use_case.dart';
import 'package:hackathon/features/settings/domain/use_cases/get_attendance_policy_use_case.dart';
import 'package:hackathon/features/settings/domain/use_cases/update_attendance_policy_use_case.dart';
import 'package:hackathon/features/settings/domain/use_cases/get_leave_policies_use_case.dart';
import 'package:hackathon/features/settings/domain/use_cases/update_leave_policies_use_case.dart';
import 'package:hackathon/features/settings/domain/use_cases/get_task_types_use_case.dart';
import 'package:hackathon/features/settings/domain/use_cases/create_task_type_use_case.dart';
import 'package:hackathon/features/settings/domain/use_cases/update_task_type_use_case.dart';
import 'package:hackathon/features/settings/domain/use_cases/delete_task_type_use_case.dart';
import 'package:hackathon/features/settings/domain/use_cases/export_org_data_use_case.dart';
import 'package:hackathon/features/settings/domain/use_cases/delete_organisation_use_case.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetOrgSettingsUseCase getOrgSettingsUseCase;
  final UpdateOrgSettingsUseCase updateOrgSettingsUseCase;
  final GetOrgPlanUseCase getOrgPlanUseCase;
  final GetRolePermissionsUseCase getRolePermissionsUseCase;
  final UpdateRolePermissionsUseCase updateRolePermissionsUseCase;
  final GetAttendancePolicyUseCase getAttendancePolicyUseCase;
  final UpdateAttendancePolicyUseCase updateAttendancePolicyUseCase;
  final GetLeavePoliciesUseCase getLeavePoliciesUseCase;
  final UpdateLeavePoliciesUseCase updateLeavePoliciesUseCase;
  final GetTaskTypesUseCase getTaskTypesUseCase;
  final CreateTaskTypeUseCase createTaskTypeUseCase;
  final UpdateTaskTypeUseCase updateTaskTypeUseCase;
  final DeleteTaskTypeUseCase deleteTaskTypeUseCase;
  final ExportOrgDataUseCase exportOrgDataUseCase;
  final DeleteOrganisationUseCase deleteOrganisationUseCase;

  SettingsBloc({
    required this.getOrgSettingsUseCase,
    required this.updateOrgSettingsUseCase,
    required this.getOrgPlanUseCase,
    required this.getRolePermissionsUseCase,
    required this.updateRolePermissionsUseCase,
    required this.getAttendancePolicyUseCase,
    required this.updateAttendancePolicyUseCase,
    required this.getLeavePoliciesUseCase,
    required this.updateLeavePoliciesUseCase,
    required this.getTaskTypesUseCase,
    required this.createTaskTypeUseCase,
    required this.updateTaskTypeUseCase,
    required this.deleteTaskTypeUseCase,
    required this.exportOrgDataUseCase,
    required this.deleteOrganisationUseCase,
  }) : super(SettingsInitial()) {
    on<LoadOrgSettingsEvent>(_onLoadOrgSettings);
    on<UpdateOrgSettingsEvent>(_onUpdateOrgSettings);
    on<LoadOrgPlanEvent>(_onLoadOrgPlan);
    on<LoadRolePermissionsEvent>(_onLoadRolePermissions);
    on<UpdateRolePermissionsEvent>(_onUpdateRolePermissions);
    on<LoadAttendancePolicyEvent>(_onLoadAttendancePolicy);
    on<UpdateAttendancePolicyEvent>(_onUpdateAttendancePolicy);
    on<LoadLeavePoliciesEvent>(_onLoadLeavePolicies);
    on<UpdateLeavePoliciesEvent>(_onUpdateLeavePolicies);
    on<LoadTaskTypesEvent>(_onLoadTaskTypes);
    on<CreateTaskTypeEvent>(_onCreateTaskType);
    on<UpdateTaskTypeEvent>(_onUpdateTaskType);
    on<DeleteTaskTypeEvent>(_onDeleteTaskType);
    on<ExportOrgDataEvent>(_onExportOrgData);
    on<DeleteOrganisationEvent>(_onDeleteOrganisation);
  }

  Future<void> _onLoadOrgSettings(LoadOrgSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await getOrgSettingsUseCase();
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (settings) => emit(OrgSettingsLoaded(settings)),
    );
  }

  Future<void> _onUpdateOrgSettings(UpdateOrgSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await updateOrgSettingsUseCase(event.settings);
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (settings) => emit(OrgSettingsLoaded(settings)),
    );
  }

  Future<void> _onLoadOrgPlan(LoadOrgPlanEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await getOrgPlanUseCase();
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (plan) => emit(OrgPlanLoaded(plan)),
    );
  }

  Future<void> _onLoadRolePermissions(LoadRolePermissionsEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await getRolePermissionsUseCase();
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (permissions) => emit(RolePermissionsLoaded(permissions)),
    );
  }

  Future<void> _onUpdateRolePermissions(UpdateRolePermissionsEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await updateRolePermissionsUseCase(event.permissions);
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) => emit(const SettingsActionSuccess("Role permissions updated successfully")),
    );
  }

  Future<void> _onLoadAttendancePolicy(LoadAttendancePolicyEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await getAttendancePolicyUseCase();
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (policy) => emit(AttendancePolicyLoaded(policy)),
    );
  }

  Future<void> _onUpdateAttendancePolicy(UpdateAttendancePolicyEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await updateAttendancePolicyUseCase(event.policy);
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (policy) => emit(AttendancePolicyLoaded(policy)),
    );
  }

  Future<void> _onLoadLeavePolicies(LoadLeavePoliciesEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await getLeavePoliciesUseCase();
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (policies) => emit(LeavePoliciesLoaded(policies)),
    );
  }

  Future<void> _onUpdateLeavePolicies(UpdateLeavePoliciesEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await updateLeavePoliciesUseCase(event.policies);
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) => emit(const SettingsActionSuccess("Leave policies updated successfully")),
    );
  }

  Future<void> _onLoadTaskTypes(LoadTaskTypesEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await getTaskTypesUseCase();
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (taskTypes) => emit(TaskTypesLoaded(taskTypes)),
    );
  }

  Future<void> _onCreateTaskType(CreateTaskTypeEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await createTaskTypeUseCase(event.taskType);
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) => add(LoadTaskTypesEvent()),
    );
  }

  Future<void> _onUpdateTaskType(UpdateTaskTypeEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await updateTaskTypeUseCase(event.taskType);
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) => add(LoadTaskTypesEvent()),
    );
  }

  Future<void> _onDeleteTaskType(DeleteTaskTypeEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await deleteTaskTypeUseCase(event.id);
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) => add(LoadTaskTypesEvent()),
    );
  }

  Future<void> _onExportOrgData(ExportOrgDataEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await exportOrgDataUseCase();
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (data) => emit(ExportDataLoaded(data)),
    );
  }

  Future<void> _onDeleteOrganisation(DeleteOrganisationEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await deleteOrganisationUseCase();
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) => emit(const SettingsActionSuccess("Organisation deleted successfully")),
    );
  }
}
