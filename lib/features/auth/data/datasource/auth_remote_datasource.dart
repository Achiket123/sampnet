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
import 'package:hackathon/services/token_manager.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_io/jwt_io.dart';

abstract class AuthRemoteDataSource {
  Future<Either<ErrorModel, AuthResponseModel>> signIn(SignInParams params);
  Future<Either<ErrorModel, AuthResponseModel>> signUp(SignUpParams params);
  Either<ErrorModel, void> saveToken(String token);
  Either<ErrorModel, String> getToken();
  Future<Either<ErrorModel, AuthResponseModel>> acceptInvite({
    required String token,
    required String password,
  });
  Future<Either<ErrorModel, void>> sendVerificationEmail();
  Future<Either<ErrorModel, void>> verifyEmail(String token);
  Future<Either<ErrorModel, AuthResponseModel>> getMe();
}

class AuthRemoteDataSourceImpl with Strings implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final TokenManager tokenManager;

  AuthRemoteDataSourceImpl({
    required this.apiClient,
    required this.tokenManager,
  });

  // ─── Sign In ──────────────────────────────────────────────────────────────

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

      debugPrint('SignIn Status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return _handleAuthSuccess(response);
      }

      if (response.statusCode == 401) {
        return left(
            ServerError(message: 'Invalid credentials. Please try again.'));
      }

      final errorBody = jsonDecode(response.body);
      return left(ServerError(message: errorBody.toString()));
    } catch (e) {
      debugPrint('SignIn Error: $e');
      return left(AuthError(message: 'An error occurred: ${e.toString()}'));
    }
  }

  // ─── Sign Up ──────────────────────────────────────────────────────────────

  @override
  Future<Either<ErrorModel, AuthResponseModel>> signUp(
      SignUpParams params) async {
    try {
      final response = await apiClient.post(
        ApiConstants.signUp,
        body: params.toMap(),
      );

      debugPrint('SignUp Status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return _handleAuthSuccess(response);
      }

      if (response.statusCode == 401) {
        return left(
            ServerError(message: 'Invalid credentials. Please try again.'));
      }

      final errorBody = jsonDecode(response.body);
      return left(ServerError(message: errorBody.toString()));
    } catch (e) {
      debugPrint('SignUp Error: $e');
      return left(AuthError(message: ErrorMessages.authError));
    }
  }

  // ─── Save / Get Token ─────────────────────────────────────────────────────

  @override
  Either<ErrorModel, void> saveToken(String token) {
    try {
      tokenManager.saveAccessToken(token);
      return right(null);
    } catch (e) {
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Either<ErrorModel, String> getToken() {
    try {
      final accessToken = tokenManager.getAccessToken();
      if (accessToken == null) {
        return left(ServerError(message: 'Token not found'));
      }

      // Rehydrate in-memory state from stored tokens
      final payload = JwtToken.payload(accessToken);
      final userJson = payload['user'];

      getIt<User>().token = accessToken;
      getIt<User>().user = UserModel.fromJson(userJson);

      // Restore organisation if it was saved
      if (userJson['Organisation'] != null) {
        getIt<User>().organisation =
            Organisation.fromJson(Map<String, dynamic>.from(userJson['Organisation']));
      }

      // Restore employee token if present
      final empToken = tokenManager.getEmployeeToken();
      if (empToken != null) {
        getIt<User>().employeeToken = empToken;
        _rehydrateEmployeeFromToken(empToken);
      }

      return right(accessToken);
    } catch (e) {
      debugPrint('getToken error: $e');
      return left(ServerError(message: e.toString()));
    }
  }

  // ─── Shared Auth Success Handler ──────────────────────────────────────────

  /// Called after any successful sign-in or sign-up response.
  /// Reads the access token from the Authorization header and the refresh
  /// token from the JSON body, persists both via TokenManager, then hydrates
  /// the in-memory User singleton and checks employment status.
  Future<Either<ErrorModel, AuthResponseModel>> _handleAuthSuccess(
      http.Response response) async {
    // 1. Access token comes from the Authorization header
    final accessToken = response.headers['authorization'];
    if (accessToken == null) {
      return left(
          ServerError(message: 'Authorization token missing in response headers.'));
    }

    // 2. Refresh token comes from the JSON body
    final body = jsonDecode(response.body);
    final refreshToken = body['refresh_token'] as String?;
    if (refreshToken == null) {
      return left(ServerError(message: 'Refresh token missing in response body.'));
    }

    // 3. Persist both tokens through TokenManager (single source of truth)
    tokenManager.saveAccessToken(accessToken);
    tokenManager.saveRefreshToken(refreshToken);

    // 4. Decode and hydrate in-memory state
    final decodedToken = JwtToken.payload(accessToken);
    debugPrint('Decoded Token Payload: $decodedToken');

    final userModel = UserModel.fromJson(decodedToken['user']);
    getIt<User>().user = userModel;
    getIt<User>().token = accessToken;

    // Clear any stale employee state from a previous session
    getIt<User>().employee = null;
    getIt<User>().employeeToken = null;
    getIt<User>().organisation = null;
    tokenManager.clearEmployeeTokens();

    // 5. Check employment status (sets employee/org on User singleton if found)
    await _checkEmploymentStatus(accessToken, userModel.id);

    return right(AuthResponseModel(
      token: accessToken,
      userModel: userModel,
    ));
  }

  // ─── Employment Status ────────────────────────────────────────────────────

  /// Hits the is-employee endpoint. On success, saves and hydrates the
  /// employee token and organisation. Non-200 responses are non-fatal —
  /// the user is simply not an employee in any org yet.
  Future<void> _checkEmploymentStatus(String accessToken, int userId) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.isEmployee}/$userId',
      );

      if (response.statusCode != 200) {
        debugPrint('isEmployee non-200: ${response.statusCode}');
        return;
      }

      final body = jsonDecode(response.body);
      final empToken = body['token'] as String?;
      final empData = body['data'];

      if (empToken == null || empData == null) return;

      // Persist employee token
      tokenManager.saveEmployeeToken(empToken);
      getIt<User>().employeeToken = empToken;

      // Hydrate employee model from the token payload
      _rehydrateEmployeeFromToken(empToken);

      // Hydrate organisation — backend returns either capitalised or lowercase key
      final orgJson = empData['Organisation'] ?? empData['organisation'];
      if (orgJson != null) {
        final org = Organisation.fromJson(Map<String, dynamic>.from(orgJson));
        getIt<User>().organisation = org;
        tokenManager.saveOrganisation(orgJson);
      }
    } catch (e) {
      debugPrint('Error during isEmployee check: $e');
    }
  }

  /// Decodes the employee JWT and populates [User.employee].
  /// Handles the employee / manager / boss payload key differences.
  void _rehydrateEmployeeFromToken(String empToken) {
    try {
      final empPayload = JwtToken.payload(empToken);
      Map<String, dynamic>? empJson;

      if (empPayload['employee'] != null) {
        empJson = Map<String, dynamic>.from(empPayload['employee']);
      } else if (empPayload['manager'] != null) {
        empJson = Map<String, dynamic>.from(empPayload['manager']);
      } else if (empPayload['boss'] != null) {
        empJson = Map<String, dynamic>.from(empPayload['boss']);
        // Boss records lack these employment fields — provide defaults so
        // EmpModel.fromJson doesn't throw on missing keys
        empJson['type'] = empJson['type'] ?? 'boss';
        empJson['employment_id'] = empJson['employment_id'] ?? 0;
        empJson['salary'] = empJson['salary'] ?? '0';
      }

      if (empJson != null) {
        getIt<User>().employee = EmpModel.fromJson(empJson);
      }
    } catch (e) {
      debugPrint('Failed to rehydrate employee from token: $e');
    }
  }

  @override
  Future<Either<ErrorModel, AuthResponseModel>> acceptInvite({
    required String token,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.acceptInvite,
        body: {
          "token": token,
          "password": password,
        },
      );

      debugPrint('AcceptInvite Status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return _handleAuthSuccess(response);
      }

      final errorBody = jsonDecode(response.body);
      return left(ServerError(message: errorBody['error'] ?? errorBody.toString()));
    } catch (e) {
      debugPrint('AcceptInvite Error: $e');
      return left(AuthError(message: 'An error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ErrorModel, void>> sendVerificationEmail() async {
    try {
      final response = await apiClient.post(
        ApiConstants.sendVerificationEmail,
      );

      debugPrint('SendVerificationEmail Status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return right(null);
      }

      final errorBody = jsonDecode(response.body);
      return left(ServerError(message: errorBody['error'] ?? errorBody.toString()));
    } catch (e) {
      debugPrint('SendVerificationEmail Error: $e');
      return left(AuthError(message: 'An error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ErrorModel, void>> verifyEmail(String token) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.verifyEmail}?token=$token',
      );

      debugPrint('VerifyEmail Status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return right(null);
      }

      final errorBody = jsonDecode(response.body);
      return left(ServerError(message: errorBody['error'] ?? errorBody.toString()));
    } catch (e) {
      debugPrint('VerifyEmail Error: $e');
      return left(AuthError(message: 'An error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ErrorModel, AuthResponseModel>> getMe() async {
    try {
      final response = await apiClient.get(
        ApiConstants.getMe,
      );

      debugPrint('GetMe Status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return _handleAuthSuccess(response);
      }

      final errorBody = jsonDecode(response.body);
      return left(ServerError(message: errorBody['error'] ?? errorBody.toString()));
    } catch (e) {
      debugPrint('GetMe Error: $e');
      return left(AuthError(message: 'An error occurred: ${e.toString()}'));
    }
  }
}