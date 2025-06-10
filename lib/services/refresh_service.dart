import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:jammies_app/services/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RefreshService {
  final _storage = const FlutterSecureStorage();

  final String _baseUrl = "$ApiUrl/auth";
  Future<void> refresh() async {
    final uri = Uri.parse("$refresh/refresh");

    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({
        'refreshToken': await _storage.read(key: 'refresh_token'),
      }),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      await _storage.write(key: 'access_token', value: data['accessToken']);
    }
    if (res.statusCode == 401) {
      await _storage.deleteAll();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isFirstTime', true);
    }
  }
}
