import 'package:hackathon/globals/constants/strings.dart';
import 'package:hive_flutter/adapters.dart';

class TokenManager with Strings {
  // ─── Access Token ──────────────────────────────────────────────────────────

  String? getAccessToken() =>
      Hive.box(Strings.authBox).get(Strings.tokenKey) as String?;

  void saveAccessToken(String token) =>
      Hive.box(Strings.authBox).put(Strings.tokenKey, token);

  // ─── Refresh Token ─────────────────────────────────────────────────────────

  String? getRefreshToken() =>
      Hive.box(Strings.authBox).get(Strings.refreshTokenKey) as String?;

  void saveRefreshToken(String token) =>
      Hive.box(Strings.authBox).put(Strings.refreshTokenKey, token);

  // ─── Employee Token ────────────────────────────────────────────────────────

  String? getEmployeeToken() =>
      Hive.box(Strings.authBox).get(Strings.employeeTokenKey) as String?;

  void saveEmployeeToken(String token) =>
      Hive.box(Strings.authBox).put(Strings.employeeTokenKey, token);

  void clearEmployeeTokens() {
    Hive.box(Strings.authBox).delete(Strings.employeeTokenKey);
    Hive.box(Strings.authBox).delete(Strings.employeeKey);
    Hive.box(Strings.authBox).delete(Strings.organisationKey);
  }

  // ─── Organisation ──────────────────────────────────────────────────────────

  void saveOrganisation(Map<String, dynamic> orgJson) =>
      Hive.box(Strings.authBox).put(Strings.organisationKey, orgJson);

  // ─── Full Clear (logout) ───────────────────────────────────────────────────

  void clearTokens() {
    Hive.box(Strings.authBox).delete(Strings.tokenKey);
    Hive.box(Strings.authBox).delete(Strings.refreshTokenKey);
    clearEmployeeTokens();
  }
}