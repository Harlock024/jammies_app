import 'package:flutter/foundation.dart';
import 'package:jammies_app/models/user.dart';
import 'package:jammies_app/services/user_services.dart';

class UserProvider with ChangeNotifier {
  final _userServices = UserServices();
  User? _user;
  User? get user => _user;
  Future<void> fetchUser() async {
    try {
      final user = await _userServices.getProfile();
      if (user == null) {
        _user = user;
        notifyListeners();
      } else {
        print('Error cargando perfil: ${user.id}');
      }
    } catch (e) {
      print(e);
    }
  }
}
