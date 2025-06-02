import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jammies_app/services/api_url.dart';

class ApiClient {
  final _storage = const FlutterSecureStorage();
  final String _baseUrl = ApiUrl;

  Future<Map<String, String>> _authHeaders() async {
    final token = await _storage.read(key: 'accessToken');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(String endpoint) async {
    final headers = await _authHeaders();
    return http.get(Uri.parse('$_baseUrl$endpoint'), headers: headers);
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final headers = await _authHeaders();
    return http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> postMultipart(
    String endpoint, {
    required Map<String, String> fields,
    http.MultipartFile? file,
  }) async {
    final headers = await _authHeaders();
    final uri = Uri.parse('$_baseUrl$endpoint');
    final request = http.MultipartRequest('POST', uri);

    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    if (file != null) {
      request.files.add(file);
    }

    request.headers.addAll(headers);

    final streamedResponse = await request.send();
    return http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final headers = await _authHeaders();
    return http.put(
      Uri.parse('$_baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String endpoint) async {
    final headers = await _authHeaders();
    return http.delete(Uri.parse('$_baseUrl$endpoint'), headers: headers);
  }
}
