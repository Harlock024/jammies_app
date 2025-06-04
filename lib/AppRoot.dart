import 'package:flutter/material.dart';
import 'package:jammies_app/providers/auth_provider.dart';
import 'package:jammies_app/screens/auth/login.dart';
import 'package:jammies_app/screens/greeting.dart';
import 'package:jammies_app/screens/index.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool _checking = true;
  bool _isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final auth = Provider.of<AuthProvider>(context, listen: false);

    _isFirstTime = prefs.getBool('isFirstTime') ?? true;
    await auth.checkLoginStatus();

    setState(() {
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (_checking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_isFirstTime) {
      return GreetingScreen(
        onContinue: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isFirstTime', false);
          setState(() => _isFirstTime = false);
        },
      );
    }

    return auth.isAuthenticated ? const IndexPage() : const LoginScreen();
  }
}
