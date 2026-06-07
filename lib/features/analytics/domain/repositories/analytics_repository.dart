import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/analytics/domain/entities/employee_analytics_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class AnalyticsRepository {
  Future<Either<ErrorModel, EmployeeAnalyticsSummaryEntity>> getEmployeeAnalytics(int employeeId, int orgId, String period);
  Future<Either<ErrorModel, List<EmployeeMonitorResponseEntity>>> getOrgEmployeeMonitor(int orgId);
}
