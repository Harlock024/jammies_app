import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:jammies_app/models/user.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  User? _user;
  User? get user => _user;

  Future<void> loadUserFromStorage() async {
    final userJson = await _storage.read(key: "user");
    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson);
        _user = User.fromJson(userMap);
        notifyListeners();
        print('Usuario restaurado desde storage: $_user');
      } catch (e) {
        print('Error al parsear el usuario: $e');
      }
    }
  }
}
