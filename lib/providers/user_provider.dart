import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:jammies_app/models/user.dart';
import 'package:jammies_app/services/user_services.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider with ChangeNotifier {
  final _userServices = UserServices();
  final _storage = const FlutterSecureStorage();

  User? _user;
  User? get user => _user;

  Future<void> fetchUser() async {
    try {
      _user = await _userServices.getProfile();
      await _storage.write(key: "user", value: jsonEncode(_user!.toJson()));
      notifyListeners();
      print('Usuario cargado: $_user');
    } catch (e) {
      print('Excepción al cargar el perfil: $e');
    }
  }

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

// class UserProvider with ChangeNotifier {
//   final _userServices = UserServices();
//   User? _user;
//   User? get user => _user;
//   Future<void> fetchUser() async {
//     try {
//       final user = await _userServices.getProfile();
//       if (user == null) {
//         _user = user;
//         notifyListeners();
//       } else {
//         print('error al cargar user: ${jsonEncode(user)}');
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
// }
