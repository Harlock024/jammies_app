import 'package:flutter/material.dart';
import 'package:jammies_app/AppRoot.dart';
import 'package:jammies_app/providers/auth_provider.dart';
import 'package:jammies_app/screens/auth/login.dart';
import 'package:jammies_app/screens/auth/register.dart';

import 'package:jammies_app/screens/index.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isFirstTime = prefs.getBool('isFirstTime') ?? true;

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MyApp(isFirstTime: isFirstTime),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  const MyApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jammies App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => AppRoot(isFirstTime: isFirstTime),
        '/login': (context) => const LoginScreen(),
        '/index': (context) => IndexPage(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
