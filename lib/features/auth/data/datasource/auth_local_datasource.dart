import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/strings.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/globals/models/organisation_model.dart';
import 'package:hackathon/globals/models/user_model.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:jwt_io/jwt_io.dart';

abstract class AuthLocalDataSource {
  Future<Either<ErrorModel, void>> saveToken(String token);
  Either<ErrorModel, String> getToken();
}

class AuthLocalDataSourceImpl with Strings implements AuthLocalDataSource {
  final HiveInterface hive;
  AuthLocalDataSourceImpl({required this.hive});
  @override
  Future<Either<ErrorModel, void>> saveToken(String token) async {
    try {
      await hive.box(Strings.authBox).put(Strings.tokenKey, token);
      return right(null);
    } catch (e) {
      return left(ServerError(message: e.toString()));
    }
  }

  @override
  Either<ErrorModel, String> getToken() {
    try {
      final token =
          hive.box(Strings.authBox).get(Strings.tokenKey, defaultValue: null);
      debugPrint("TOKEN: ${token}");
      if (token == null) {
        return left(ServerError(message: 'Token not found'));
      } else if (JwtToken.isExpired(token)) {
        debugPrint("Token is expired, returning to let router/client refresh.");
        try {
          getIt<User>().user =
              UserModel.fromJson(JwtToken.payload(token)['user']);
          getIt<User>().token = token;
        } catch (_) {}
        return right(token);
      } else {
        debugPrint(JwtToken.payload(token).toString());

        getIt<User>().user =
            UserModel.fromJson(JwtToken.payload(token)['user']);
        getIt<User>().token = token;
        debugPrint(
          getIt<User>().token,
        );

        return right(token);
      }
    } catch (e) {
      debugPrint(e.toString());
      return left(ServerError(message: e.toString()));
    }
  }
}
