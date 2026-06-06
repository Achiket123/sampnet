import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hackathon/globals/constants/strings.dart';

class ApiClient {
  final http.Client _client;
  final String baseUrl;

  ApiClient({required http.Client client, required this.baseUrl}) : _client = client;

  Map<String, String> _getHeaders() {
    final empToken = Hive.box(Strings.authBox).get(Strings.employeeTokenKey);
    final token = empToken ?? Hive.box(Strings.authBox).get(Strings.tokenKey);
    return {
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
    };
  }

  Future<http.Response> get(String endpoint) async {
    final headers = _getHeaders();
    return await _client.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
  }

  Future<http.Response> post(String endpoint, {dynamic body}) async {
    final headers = _getHeaders();
    return await _client.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> put(String endpoint, {dynamic body}) async {
    final headers = _getHeaders();
    return await _client.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> delete(String endpoint) async {
    final headers = _getHeaders();
    return await _client.delete(Uri.parse('$baseUrl$endpoint'), headers: headers);
  }

  Future<http.StreamedResponse> sendMultipart(http.MultipartRequest request) async {
    final headers = _getHeaders();
    // Content-Type is set by MultipartRequest automatically, don't overwrite it here
    headers.remove('Content-Type');
    request.headers.addAll(headers);
    return await _client.send(request);
  }
}
