part of 'org_analytics_bloc.dart';

abstract class OrgAnalyticsState extends Equatable {
  const OrgAnalyticsState();

  @override
  List<Object?> get props => [];
}

class OrgAnalyticsInitial extends OrgAnalyticsState {}

class OrgAnalyticsLoading extends OrgAnalyticsState {}

class OrgMonitorLoaded extends OrgAnalyticsState {
  final List<EmployeeMonitorResponseEntity> monitorData;

  const OrgMonitorLoaded(this.monitorData);

  @override
  List<Object?> get props => [monitorData];
}

class EmployeeAnalyticsDetailLoaded extends OrgAnalyticsState {
  final EmployeeAnalyticsSummaryEntity summary;

  const EmployeeAnalyticsDetailLoaded(this.summary);

  @override
  List<Object?> get props => [summary];
}

class OrgAnalyticsError extends OrgAnalyticsState {
  final String message;

  const OrgAnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}
