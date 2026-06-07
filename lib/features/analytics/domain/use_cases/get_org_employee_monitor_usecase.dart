import 'package:fpdart/fpdart.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/analytics/domain/entities/employee_analytics_entity.dart';
import 'package:hackathon/features/analytics/domain/repositories/analytics_repository.dart';

class GetOrgEmployeeMonitorUseCase {
  final AnalyticsRepository repository;

  GetOrgEmployeeMonitorUseCase(this.repository);

  Future<Either<ErrorModel, List<EmployeeMonitorResponseEntity>>> call(int orgId) async {
    return await repository.getOrgEmployeeMonitor(orgId);
  }
}
