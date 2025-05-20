import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jammies_app/models/token_response.dart';
import 'package:jammies_app/models/user_response.dart';
import 'package:jammies_app/services/api_url.dart';

class AuthServices {
  final _storage = const FlutterSecureStorage();
  final String _baseUrl = "$ApiUrl/auth";

  Future<bool> login(String email, String password) async {
    final url = Uri.parse("$_baseUrl/login");

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('Status code: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final user = UserResponse.fromJson(data['user']);
      final tokens = TokensResponse.fromJson(data['tokensResponse']);

      await _storage.write(key: "accessToken", value: tokens.accessToken);
      await _storage.write(key: "refreshToken", value: tokens.refreshToken);
      await _storage.write(key: "user_username", value: user.username);
      await _storage.write(key: "user_avatar", value: user.avatarUrl);

      return true;
    } else {
      throw Exception(
        "Login failed | Status: ${res.statusCode} | Body: ${res.body}",
      );
    }
  }

  Future<bool> register(String username, String email, String password) async {
    final url = Uri.parse("$_baseUrl/register");
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final user = UserResponse.fromJson(data['user']);
      final tokens = TokensResponse.fromJson(data['tokensResponse']);

      await _storage.write(key: "accessToken", value: tokens.accessToken);
      await _storage.write(key: "refreshToken", value: tokens.refreshToken);
      await _storage.write(key: "user_username", value: user.email);

      return true;
    } else {
      throw Exception("Registration failed");
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<String?> get accessToken async =>
      await _storage.read(key: "accessToken");
}
