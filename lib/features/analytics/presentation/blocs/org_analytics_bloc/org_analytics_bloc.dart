import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/analytics/domain/entities/employee_analytics_entity.dart';
import 'package:hackathon/features/analytics/domain/use_cases/get_employee_analytics_usecase.dart';
import 'package:hackathon/features/analytics/domain/use_cases/get_org_employee_monitor_usecase.dart';

part 'org_analytics_event.dart';
part 'org_analytics_state.dart';

class OrgAnalyticsBloc extends Bloc<OrgAnalyticsEvent, OrgAnalyticsState> {
  final GetOrgEmployeeMonitorUseCase getOrgEmployeeMonitorUseCase;
  final GetEmployeeAnalyticsUseCase getEmployeeAnalyticsUseCase;

  OrgAnalyticsBloc({
    required this.getOrgEmployeeMonitorUseCase,
    required this.getEmployeeAnalyticsUseCase,
  }) : super(OrgAnalyticsInitial()) {
    on<LoadOrgAnalyticsMonitor>(_onLoadOrgAnalyticsMonitor);
    on<LoadEmployeeAnalyticsDetail>(_onLoadEmployeeAnalyticsDetail);
  }

  Future<void> _onLoadOrgAnalyticsMonitor(
    LoadOrgAnalyticsMonitor event,
    Emitter<OrgAnalyticsState> emit,
  ) async {
    emit(OrgAnalyticsLoading());
    final result = await getOrgEmployeeMonitorUseCase(event.orgId);
    result.fold(
      (failure) => emit(OrgAnalyticsError(failure.message)),
      (monitorData) => emit(OrgMonitorLoaded(monitorData)),
    );
  }

  Future<void> _onLoadEmployeeAnalyticsDetail(
    LoadEmployeeAnalyticsDetail event,
    Emitter<OrgAnalyticsState> emit,
  ) async {
    emit(OrgAnalyticsLoading());
    final result = await getEmployeeAnalyticsUseCase(
      event.employeeId,
      event.orgId,
      event.period,
    );
    result.fold(
      (failure) => emit(OrgAnalyticsError(failure.message)),
      (summary) => emit(EmployeeAnalyticsDetailLoaded(summary)),
    );
  }
}
