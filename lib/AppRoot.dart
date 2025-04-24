import 'package:flutter/widgets.dart';
import 'package:jammies_app/providers/auth_provider.dart';
import 'package:jammies_app/screens/auth/login.dart';
import 'package:jammies_app/screens/greeting.dart';
import 'package:jammies_app/screens/index.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRoot extends StatelessWidget {
  final bool isFirstTime;
  const AppRoot({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (isFirstTime) {
      return GreetingScreen(
        onContinue: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isFirstTime', true);
          Navigator.pushReplacementNamed(context, '/login');
        },
      );
    }
    return auth.isAuthenticated ? IndexPage() : const LoginScreen();
  }
}
