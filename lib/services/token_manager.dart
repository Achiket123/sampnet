import 'package:hackathon/globals/constants/strings.dart';
import 'package:hive_flutter/adapters.dart';

class TokenManager with Strings {
  String? getAccessToken() {
    return Hive.box(Strings.authBox).get(Strings.tokenKey);
  }

  void saveAccessToken(String token) {
    Hive.box(Strings.authBox).put(Strings.tokenKey, token);
  }

  String? getRefreshToken() {
    return Hive.box(Strings.authBox).get(Strings.refreshTokenKey);
  }

  void saveRefreshToken(String token) {
    Hive.box(Strings.authBox).put(Strings.refreshTokenKey, token);
  }

  void clearTokens() {
    Hive.box(Strings.authBox).delete(Strings.tokenKey);
    Hive.box(Strings.authBox).delete(Strings.refreshTokenKey);
  }
}
