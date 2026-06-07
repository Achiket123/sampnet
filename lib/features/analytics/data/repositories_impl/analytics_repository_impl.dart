import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/analytics/data/data_sources/analytics_remote_data_source.dart';
import 'package:hackathon/features/analytics/domain/entities/employee_analytics_entity.dart';
import 'package:hackathon/features/analytics/domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;

  AnalyticsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<ErrorModel, EmployeeAnalyticsSummaryEntity>> getEmployeeAnalytics(int employeeId, int orgId, String period) async {
    try {
      final remoteData = await remoteDataSource.getEmployeeAnalytics(employeeId, orgId, period);
      return right(remoteData);
    } catch (e) {
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<EmployeeMonitorResponseEntity>>> getOrgEmployeeMonitor(int orgId) async {
    try {
      final remoteData = await remoteDataSource.getOrgEmployeeMonitor(orgId);
      return right(remoteData);
    } catch (e) {
      return left(ServerError(message: e.toString()));
    }
  }
}
