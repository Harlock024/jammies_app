import 'dart:convert';

import 'package:jammies_app/models/user.dart';

import 'package:jammies_app/services/api_client.dart';

class UserServices {
  final _client = ApiClient();

  Future<User?> getProfile() async {
    final response = await _client.get('/user');

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      print('Error al obtener perfil: ${response.statusCode}');
      return null;
    }
  }
}
