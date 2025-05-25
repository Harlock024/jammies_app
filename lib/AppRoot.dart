import 'package:flutter/material.dart';
import 'package:jammies_app/providers/auth_provider.dart';
import 'package:jammies_app/screens/auth/login.dart';
import 'package:jammies_app/screens/greeting.dart';
import 'package:jammies_app/screens/index.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRoot extends StatefulWidget {
  final bool isFirstTime;
  const AppRoot({super.key, required this.isFirstTime});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool _checkingAuth = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.checkLoginStatus();
    setState(() {
      _checkingAuth = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (_checkingAuth) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (widget.isFirstTime) {
      return GreetingScreen(
        onContinue: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isFirstTime', false);
          Navigator.pushReplacementNamed(context, '/login');
        },
      );
    }

    return auth.isAuthenticated ? IndexPage() : const LoginScreen();
  }
}
