import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/auth/data/model/auth_model.dart';
import 'package:hackathon/features/auth/domain/usecase/auth_params.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/constants/strings.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/globals/error_handling/error_messages.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/globals/models/organisation_model.dart';
import 'package:hackathon/globals/models/user_model.dart';
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
  final http.Client apiClient;
  AuthRemoteDataSourceImpl({required this.apiClient});
  @override
  Future<Either<ErrorModel, AuthResponseModel>> signIn(
      SignInParams params) async {
    try {
      final response = await apiClient.post(
        Uri.parse(ApiConstants.signIn),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
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
          if (decodedToken['user']['Organisation'] != null) {
            getIt<User>().organisation =
                Organisation.fromJson(decodedToken['user']['Organisation']);
            Hive.box(Strings.authBox)
                .put(Strings.organisationKey, decodedToken['user']['Organisation']);
          } else {
            getIt<User>().organisation = null;
            Hive.box(Strings.authBox).delete(Strings.organisationKey);
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
        Uri.parse(ApiConstants.signUp),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: params.toJson(),
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
}
