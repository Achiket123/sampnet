
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/constants/strings.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/globals/models/organisation_model.dart';
import 'package:hackathon/globals/models/user_model.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:jwt_io/jwt_io.dart';

abstract class AuthLocalDataSource {
  Future<Either<ErrorModel, void>> saveToken(String token);
  Future<Either<ErrorModel, String>> getToken();
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
  Future<Either<ErrorModel, String>> getToken() async {
    try {
      final token = await hive.box(Strings.authBox).get(Strings.tokenKey);
      if (token == null) {
        return left(ServerError(message: 'Token not found'));
      } else if (JwtToken.isExpired(token)) {
        return left(ServerError(message: 'Token is expired'));
      } else {
        User.organisation = Organisation.fromJson((Map<String, dynamic>.from(
            Hive.box(Strings.authBox).get(Strings.organisationKey))));
        User.user = UserModel.fromJson(JwtToken.payload(token)['user']);
        debugPrint(
          User.organisation.companyName,
        );
        debugPrint(
          User.token,
        );

        return right(token);
      }
    } catch (e) {
      return left(ServerError(message: e.toString()));
    }
  }
}
