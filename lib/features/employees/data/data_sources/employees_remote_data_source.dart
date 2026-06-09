import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hackathon/features/employees/data/models/add_employee_request_model.dart';
import 'package:hackathon/features/employees/data/models/employee_model.dart';
import 'package:hackathon/features/employees/data/models/make_manager_request_model.dart';
import 'package:hackathon/services/api_client.dart';

abstract class EmployeesRemoteDataSource {
  Future<List<EmployeeModel>> getEmployees(int organisationId);
  Future<EmployeeModel> getEmployeeById(int employeeId);
  Future<void> addEmployee(AddEmployeeRequestModel request);
  Future<void> updateEmployee(int employeeId, EmployeeModel updated);
  Future<void> deleteEmployee(int employeeId);
  Future<List<EmployeeModel>> searchEmployees(String query);
  Future<void> makeManager(MakeManagerRequestModel request);
}

class EmployeesRemoteDataSourceImpl implements EmployeesRemoteDataSource {
  final ApiClient apiClient;

  EmployeesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<EmployeeModel>> getEmployees(int organisationId) async {
    final response = await apiClient.get('/employees/get/$organisationId');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> usersJson = data['users'] ?? [];
      return usersJson.map((json) => EmployeeModel.fromJson(json)).toList();
    } else {
      throw EmployeesFetchException(
          'Failed to fetch employees: ${response.body}');
    }
  }

  @override
  Future<EmployeeModel> getEmployeeById(int employeeId) async {
    debugPrint('getEmployeeById: $employeeId');
    final response = await apiClient.get('/employees/list/$employeeId');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final userJson = data['user'];
      if (userJson == null) throw EmployeeNotFoundException();
      return EmployeeModel.fromJson(userJson);
    } else if (response.statusCode == 404) {
      throw EmployeeNotFoundException();
    } else {
      throw EmployeesFetchException(
          'Failed to fetch employee: ${response.body}');
    }
  }

  @override
  Future<void> addEmployee(AddEmployeeRequestModel request) async {
    final response =
        await apiClient.post('/employees/add', body: request.toJson());

    if (response.statusCode != 200 && response.statusCode != 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      throw AddEmployeeException(
          data['error'] ?? data['message'] ?? 'Failed to add employee');
    }
  }

  @override
  Future<void> updateEmployee(int employeeId, EmployeeModel updated) async {
    final response = await apiClient.put('/employees/update/$employeeId',
        body: updated.toJson());

    if (response.statusCode != 200) {
      throw UpdateEmployeeException(
          'Failed to update employee: ${response.body}');
    }
  }

  @override
  Future<void> deleteEmployee(int employeeId) async {
    final response = await apiClient.delete('/employees/delete/$employeeId');

    if (response.statusCode != 200) {
      throw DeleteEmployeeException(
          'Failed to delete employee: ${response.body}');
    }
  }

  @override
  Future<List<EmployeeModel>> searchEmployees(String query) async {
    final response = await apiClient.get('/employees/search?query=$query');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> usersJson = data['users'] ?? [];
      return usersJson.map((json) => EmployeeModel.fromJson(json)).toList();
    } else {
      throw EmployeesFetchException(
          'Failed to search employees: ${response.body}');
    }
  }

  @override
  Future<void> makeManager(MakeManagerRequestModel request) async {
    final response =
        await apiClient.post('/employees/make-manager', body: request.toJson());

    if (response.statusCode != 200) {
      throw MakeManagerException(
          'Failed to promote to manager: ${response.body}');
    }
  }
}

class EmployeesFetchException implements Exception {
  final String message;
  EmployeesFetchException(this.message);
}

class EmployeeNotFoundException implements Exception {}

class AddEmployeeException implements Exception {
  final String message;
  AddEmployeeException(this.message);
}

class UpdateEmployeeException implements Exception {
  final String message;
  UpdateEmployeeException(this.message);
}

class DeleteEmployeeException implements Exception {
  final String message;
  DeleteEmployeeException(this.message);
}

class MakeManagerException implements Exception {
  final String message;
  MakeManagerException(this.message);
}
