part of 'org_analytics_bloc.dart';

abstract class OrgAnalyticsEvent extends Equatable {
  const OrgAnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrgAnalyticsMonitor extends OrgAnalyticsEvent {
  final int orgId;

  const LoadOrgAnalyticsMonitor(this.orgId);

  @override
  List<Object?> get props => [orgId];
}

class LoadEmployeeAnalyticsDetail extends OrgAnalyticsEvent {
  final int employeeId;
  final int orgId;
  final String period;

  const LoadEmployeeAnalyticsDetail({
    required this.employeeId,
    required this.orgId,
    this.period = 'month',
  });

  @override
  List<Object?> get props => [employeeId, orgId, period];
}
