import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/data/models/assignee_model.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:http/http.dart' as http;

abstract class EmployeeDataSource {
  Future<Either<ErrorModel, List<AssigneeModel>>> getEmployees(String token);
}

class EmployeeDataSourceImpl implements EmployeeDataSource {
  final http.Client apiService;
  EmployeeDataSourceImpl({required this.apiService});
  @override
  @override
  Future<Either<ErrorModel, List<AssigneeModel>>> getEmployees(
      String token) async {
    try {
      final url = Uri.parse(ApiConstants.getEmployees);
      final response = await apiService.get(url, headers: {
        'Authorization': token,
      });
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
      print(e);
      return left(ErrorModel(message: 'Something went wrong'));
    }
  }
}
