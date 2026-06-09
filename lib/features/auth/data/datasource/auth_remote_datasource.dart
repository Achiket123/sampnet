import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/auth/data/model/auth_model.dart';
import 'package:hackathon/features/auth/domain/usecase/auth_params.dart';
import 'package:hackathon/features/dashboards/data/models/emp_model.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/constants/strings.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/globals/error_handling/error_messages.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/globals/models/organisation_model.dart';
import 'package:hackathon/globals/models/user_model.dart';
import 'package:hackathon/services/api_client.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_io/jwt_io.dart';

abstract class AuthRemoteDataSource {
  Future<Either<ErrorModel, AuthResponseModel>> signIn(SignInParams params);
  Future<Either<ErrorModel, AuthResponseModel>> signUp(SignUpParams params);
  Either<ErrorModel, void> saveToken(String token);
  Either<ErrorModel, String> getToken();
}

class AuthRemoteDataSourceImpl with Strings implements AuthRemoteDataSource {
  final ApiClient apiClient;
  AuthRemoteDataSourceImpl({required this.apiClient});
  @override
  Future<Either<ErrorModel, AuthResponseModel>> signIn(
      SignInParams params) async {
    try {
      final response = await apiClient.post(
        ApiConstants.signIn,
        body: {
          "email": params.email,
          "password": params.hashedPassword,
        },
      );

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Headers: ${response.headers}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final token = response.headers['authorization'];

        if (token != null) {
          final decodedToken = JwtToken.payload(token);
          debugPrint('Decoded Token Payload: $decodedToken');
          Hive.box(Strings.authBox).put(Strings.tokenKey, token);
          UserModel user = UserModel.fromJson(decodedToken['user']);
          getIt<User>().user = user;
          getIt<User>().token = token;
          getIt<User>().employee = null;
          getIt<User>().employeeToken = null;
          Hive.box(Strings.authBox).delete(Strings.employeeTokenKey);
          Hive.box(Strings.authBox).delete(Strings.employeeKey);

          // Call is-employee endpoint to check employment status
          final isEmployee = await this.isEmployee(token, user.id);

          if (isEmployee) {
            // isEmployee is handling the logic here
          }

          return right(
            AuthResponseModel(
                token: token,
                userModel: UserModel.fromJson(decodedToken['user'])),
          );
        } else {
          return left(ServerError(
              message: 'Authorization token missing in response headers.'));
        }
      } else if (response.statusCode == 401) {
        return left(
            ServerError(message: 'Invalid credentials. Please try again.'));
      }

      final errorBody = jsonDecode(response.body);
      return left(ServerError(message: errorBody.toString()));
    } catch (e) {
      debugPrint('Sign-In Error: ${e.toString()}');
      return left(AuthError(message: 'An error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ErrorModel, AuthResponseModel>> signUp(
      SignUpParams params) async {
    try {
      final response = await apiClient.post(
        ApiConstants.signUp,
        body: params.toMap(),
      );

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Headers: ${response.headers}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final token = response.headers['authorization'];

        if (token != null) {
          final decodedToken = JwtToken.payload(token);
          debugPrint('Decoded Token Payload: $decodedToken');
          Hive.box(Strings.authBox).put(Strings.tokenKey, token);
          UserModel user = UserModel.fromJson(decodedToken['user']);
          getIt<User>().user = user;
          getIt<User>().token = token;
          getIt<User>().employee = null;
          getIt<User>().employeeToken = null;
          getIt<User>().organisation = null;
          Hive.box(Strings.authBox).delete(Strings.employeeTokenKey);
          Hive.box(Strings.authBox).delete(Strings.employeeKey);
          Hive.box(Strings.authBox).delete(Strings.organisationKey);
          final isEmployee = await this.isEmployee(token, user.id);

          if (isEmployee) {
            // isEmployee is handling the logic here
          }

          return right(AuthResponseModel(
              token: token,
              userModel: UserModel.fromJson(decodedToken['user'])));
        } else {
          return left(ServerError(
              message: 'Authorization token missing in response headers.'));
        }
      } else if (response.statusCode == 401) {
        return left(
            ServerError(message: 'Invalid credentials. Please try again.'));
      }

      final errorBody = jsonDecode(response.body);
      return left(ServerError(message: errorBody.toString()));
    } catch (e) {
      debugPrint('Sign-Up Error: ${e.toString()}');
      return left(AuthError(message: ErrorMessages.authError));
    }
  }

  @override
  Either<ErrorModel, void> saveToken(String token) {
    try {
      Hive.box(Strings.authBox).put(Strings.tokenKey, token);
      return right(null);
    } catch (e) {
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Either<ErrorModel, String> getToken() {
    try {
      final token = Hive.box(Strings.authBox).get(Strings.tokenKey);
      if (token == null) {
        return left(ServerError(message: 'Token not found'));
      }
      getIt<User>().token = token;
      getIt<User>().user = UserModel.fromJson(JwtToken.payload(token)['user']);
      getIt<User>().organisation = Organisation.fromJson(
          JwtToken.payload(token)['user']['Organisation']);

      return right(token);
    } catch (e) {
      debugPrint(e.toString());
      return left(ServerError(message: e.toString()));
    }
  }

  Future<bool> isEmployee(String token, int userId) async {
    try {
      final isEmployeeResponse = await apiClient.get(
        '${ApiConstants.isEmployee}/$userId',
      );

      if (isEmployeeResponse.statusCode == 200) {
        final body = jsonDecode(isEmployeeResponse.body);
        final empToken = body['token'];
        final empData = body['data'];

        if (empToken != null && empData != null) {
          Hive.box(Strings.authBox).put(Strings.employeeTokenKey, empToken);
          Hive.box(Strings.authBox).put(Strings.employeeKey, empData);
          getIt<User>().employeeToken = empToken;

          // Handle decoding of employee/manager/boss
          final empPayload = JwtToken.payload(empToken);
          Map<String, dynamic>? empJson;
          if (empPayload['employee'] != null) {
            empJson = Map<String, dynamic>.from(empPayload['employee']);
          } else if (empPayload['manager'] != null) {
            empJson = Map<String, dynamic>.from(empPayload['manager']);
          } else if (empPayload['boss'] != null) {
            empJson = Map<String, dynamic>.from(empPayload['boss']);
            empJson['type'] = 'boss';
            empJson['employment_id'] = 0;
            empJson['salary'] = '0';
          }

          if (empData['Organisation'] != null) {
            final org = Organisation.fromJson(
                Map<String, dynamic>.from(empData['Organisation']));
            getIt<User>().organisation = org;
            Hive.box(Strings.authBox)
                .put(Strings.organisationKey, empData['Organisation']);
          } else if (empData['organisation'] != null) {
            final org = Organisation.fromJson(
                Map<String, dynamic>.from(empData['organisation']));
            getIt<User>().organisation = org;
            Hive.box(Strings.authBox)
                .put(Strings.organisationKey, empData['organisation']);
          }

          if (empJson != null) {
            getIt<User>().employee = EmpModel.fromJson(empJson);
          }
          return true;
        }
        return false;
      } else {
        debugPrint(
            'isEmployee check returned non-200: ${isEmployeeResponse.statusCode}');
        Hive.box(Strings.authBox).delete(Strings.organisationKey);
        getIt<User>().organisation = null;
        return false;
      }
    } catch (e) {
      debugPrint('Error during isEmployee validation: $e');
      Hive.box(Strings.authBox).delete(Strings.organisationKey);
      getIt<User>().organisation = null;
      return false;
    }
  }
}
