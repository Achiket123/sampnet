import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/services/token_manager.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final TokenManager tokenManager;
  final http.Client client;

  bool _isRefreshing = false;
  Future<void>? _refreshFuture;

  ApiClient({
    required this.baseUrl,
    required this.tokenManager,
    required this.client,
  });

  Map<String, String> _authHeaders({Map<String, String>? extra}) {
    final token = tokenManager.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      if (extra != null) ...extra,
    };
  }

  Map<String, String> authHeaders({Map<String, String>? extra}) =>
      _authHeaders(extra: extra);

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    return _sendWithRetry(() => client.get(
          Uri.parse('$baseUrl$endpoint'),
          headers: _authHeaders(extra: headers),
        ));
  }

  Future<http.StreamedResponse> sendMultipart(
      http.MultipartRequest request) async {
    http.StreamedResponse response = await client.send(request);

    if (response.statusCode == 401) {
      if (_isRefreshing) {
        await _refreshFuture;
      } else {
        _isRefreshing = true;
        _refreshFuture = _refreshToken().whenComplete(() {
          _isRefreshing = false;
          _refreshFuture = null;
        });
        await _refreshFuture;
      }

      final retryRequest = http.MultipartRequest(request.method, request.url)
        ..headers.addAll(authHeaders())
        ..fields.addAll(request.fields)
        ..files.addAll(request.files);

      return client.send(retryRequest);
    }

    return response;
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return _sendWithRetry(() => client.post(
          Uri.parse('$baseUrl$endpoint'),
          headers: _authHeaders(extra: headers),
          body: body != null ? jsonEncode(body) : null,
        ));
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return _sendWithRetry(() => client.put(
          Uri.parse('$baseUrl$endpoint'),
          headers: _authHeaders(extra: headers),
          body: body != null ? jsonEncode(body) : null,
        ));
  }

  Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    return _sendWithRetry(() => client.delete(
          Uri.parse('$baseUrl$endpoint'),
          headers: _authHeaders(extra: headers),
        ));
  }

  Future<http.Response> _sendWithRetry(
      Future<http.Response> Function() request) async {
    final response = await request();

    if (response.statusCode == 401) {
      if (_isRefreshing) {
        await _refreshFuture;
      } else {
        _isRefreshing = true;
        _refreshFuture = _refreshToken().whenComplete(() {
          _isRefreshing = false;
          _refreshFuture = null;
        });
        await _refreshFuture;
      }

      return await request();
    }

    return response;
  }

  Future<void> _refreshToken() async {
    final refreshToken = tokenManager.getRefreshToken();
    if (refreshToken == null) {
      debugPrint('No refresh token available — user must log in again.');
      return;
    }

    try {
      final response = await client.post(
        Uri.parse('$baseUrl${ApiConstants.refresh}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final body = jsonDecode(response.body);
        final newAccessToken = body['access_token'];
        final newRefreshToken = body['refresh_token'];

        if (newAccessToken != null) {
          tokenManager.saveAccessToken(newAccessToken as String);
        }
        if (newRefreshToken != null) {
          tokenManager.saveRefreshToken(newRefreshToken as String);
        }

        debugPrint('Token refreshed successfully.');
      } else {
        debugPrint('Token refresh failed: ${response.statusCode}');
        tokenManager.clearTokens();
      }
    } catch (e) {
      debugPrint('Token refresh error: $e');
      tokenManager.clearTokens();
    }
  }
}
