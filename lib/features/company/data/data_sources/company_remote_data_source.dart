import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/company/domain/use_cases/register_company_params.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/constants/strings.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/globals/models/organisation_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

abstract class CompanyRemoteDataSource {
  Future<Either<ErrorModel, Organisation>> registerCompany(
      RegisterCompanyParams params);
  Future<Either<ErrorModel, void>> fetchEmployeeData(String employeeId);
}

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  final http.Client apiClient;

  CompanyRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Either<ErrorModel, Organisation>> registerCompany(
      RegisterCompanyParams params) async {
    try {
      final response = await apiClient.post(
        Uri.parse(ApiConstants.registerOrganisation),
        headers: {
          'Authorization': User.token,
        },
        body: jsonEncode(params.toJson()),
      );
      if (response.statusCode == 200) {
        return Right(Organisation.fromJson(jsonDecode(response.body)));
      } else {
        return Left(ErrorModel(message: response.body));
      }
    } catch (e) {
      print(e);
      return Left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> fetchEmployeeData(String employeeId) async {
    try {
      final response = await apiClient.get(
        Uri.parse("${ApiConstants.getEmployeeById}/$employeeId"),
        headers: {
          'Authorization': User.token,
        },
      );
      if (response.statusCode == 200) {
        User.organisation = Organisation.fromJson(
            jsonDecode(response.body)["user"]["Organisation"]);
        await Hive.box(Strings.authBox).put(Strings.organisationKey,
            jsonDecode(response.body)["user"]["Organisation"]);
        debugPrint(
          "ORGANISATION",
        );

        return right(null);
      } else {
        return Left(ErrorModel(message: response.body));
      }
    } catch (e) {
      print(e);
      return left(ErrorModel(message: e.toString()));
    }
  }
}
