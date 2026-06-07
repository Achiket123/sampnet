import 'dart:convert';
import 'package:hackathon/features/analytics/data/models/employee_analytics_model.dart';
import 'package:hackathon/services/api_client.dart';

abstract class AnalyticsRemoteDataSource {
  Future<EmployeeAnalyticsSummaryModel> getEmployeeAnalytics(int employeeId, int orgId, String period);
  Future<List<EmployeeMonitorResponseModel>> getOrgEmployeeMonitor(int orgId);
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  final ApiClient apiClient;

  AnalyticsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<EmployeeAnalyticsSummaryModel> getEmployeeAnalytics(int employeeId, int orgId, String period) async {
    final response = await apiClient.get(
      '/analytics/employee/$employeeId?organisation_id=$orgId&period=$period',
    );

    if (response.statusCode == 200) {
      return EmployeeAnalyticsSummaryModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch employee analytics: ${response.body}');
    }
  }

  @override
  Future<List<EmployeeMonitorResponseModel>> getOrgEmployeeMonitor(int orgId) async {
    final response = await apiClient.get(
      '/analytics/organisation/$orgId/employees',
    );

    if (response.statusCode == 200) {
      final List decodedJson = json.decode(response.body);
      return decodedJson.map((e) => EmployeeMonitorResponseModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch org employee monitor: ${response.body}');
    }
  }
}