import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/analytics/domain/entities/employee_analytics_entity.dart';
import 'package:hackathon/features/analytics/domain/repositories/analytics_repository.dart';

class GetEmployeeAnalyticsUseCase {
  final AnalyticsRepository repository;

  GetEmployeeAnalyticsUseCase(this.repository);

  Future<Either<ErrorModel, EmployeeAnalyticsSummaryEntity>> call(int employeeId, int orgId, String period) async {
    return await repository.getEmployeeAnalytics(employeeId, orgId, period);
  }
}
