import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/data/models/assignee_model.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/services/api_client.dart';
import 'package:http/http.dart' as http;

import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/user.dart';

abstract class EmployeeDataSource {
  Future<Either<ErrorModel, List<AssigneeModel>>> getEmployees(String token);
}

class EmployeeDataSourceImpl implements EmployeeDataSource {
  final ApiClient apiService;
  EmployeeDataSourceImpl({required this.apiService});
  @override
  @override
  Future<Either<ErrorModel, List<AssigneeModel>>> getEmployees(
      String token) async {
    try {
      final url = ApiConstants.getEmployees;
      final response = await apiService.get(url);
      if (response.statusCode == 200) {
        debugPrint(response.body);
        final decodedData = jsonDecode(response.body);

        final List<dynamic> data = decodedData['users'];

        return right(data
            .map<AssigneeModel>((e) => AssigneeModel.fromJson(e['user']))
            .toList());
      }
      return left(ErrorModel(message: response.body));
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorModel(message: 'Something went wrong'));
    }
  }
}
