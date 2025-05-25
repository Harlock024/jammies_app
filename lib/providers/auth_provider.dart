import 'package:flutter/foundation.dart';
import 'package:jammies_app/services/auth_services.dart';

class AuthProvider extends ChangeNotifier {
  final AuthServices _authServices = AuthServices();

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkLoginStatus() async {
    final token = await _authServices.accessToken;

    _isAuthenticated = token != null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      final success = await _authServices.login(email, password);
      _isAuthenticated = success;
      notifyListeners();
      return success;
    } catch (e) {
      print("login erorr: $e");
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      final success = await _authServices.register(username, email, password);
      _isAuthenticated = success;
      notifyListeners();
      return success;
    } catch (e) {
      print("register erorr: $e");
      return false;
    }
  }

  void logout() {
    _authServices.logout();
    _isAuthenticated = false;
    notifyListeners();
  }
}
