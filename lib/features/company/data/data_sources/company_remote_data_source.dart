import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/company/domain/use_cases/register_company_params.dart';
import 'package:hackathon/features/dashboards/data/models/emp_model.dart';
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
          'Authorization': getIt<User>().token!,
        },
        body: jsonEncode(params.toJson()),
      );
      if (response.statusCode >= 200) {
        final data = jsonDecode(response.body);
        Organisation org = Organisation.fromJson(data["organisation"]);
        EmpModel emp = EmpModel.fromJson(data["employee"]);
        getIt<User>().organisation = org;
        getIt<User>().employee = emp;
        await Hive.box(Strings.authBox)
            .put(Strings.organisationKey, data["organisation"]);
        await Hive.box(Strings.authBox)
            .put(Strings.employeeKey, data["employee"]);
        return Right(org);
      } else {
        throw Exception(response.body);
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
          'Authorization': getIt<User>().token!,
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        debugPrint(responseData.toString());
        if (responseData["user"]["organisation"] != null) {
          getIt<User>().organisation =
              Organisation.fromJson(responseData["user"]["organisation"]);
          await Hive.box(Strings.authBox).put(
              Strings.organisationKey, responseData["user"]["organisation"]);
        }

        if (responseData["user"] != null) {
          getIt<User>().employee = EmpModel.fromJson(responseData["user"]);
          await Hive.box(Strings.authBox)
              .put(Strings.employeeKey, responseData["user"]);
        }

        debugPrint("ORGANISATION AND EMPLOYEE DATA FETCHED");
        return right(null);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print(e);
      return left(ErrorModel(message: e.toString()));
    }
  }
}
