import 'package:flutter/material.dart';
import 'package:jammies_app/AppRoot.dart';
import 'package:jammies_app/providers/audio_player.dart';
import 'package:jammies_app/providers/auth_provider.dart';
import 'package:jammies_app/providers/queue_controller.dart';
import 'package:jammies_app/providers/user_provider.dart';
import 'package:jammies_app/screens/auth/login.dart';
import 'package:jammies_app/screens/auth/register.dart';
import 'package:jammies_app/screens/greeting.dart';

import 'package:jammies_app/screens/index.dart';
import 'package:jammies_app/screens/settings/settings.dart';
import 'package:jammies_app/services/devices_services.dart';
import 'package:jammies_app/services/ws_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isFirstTime = prefs.getBool('isFirstTime') ?? true;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AudioController()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        Provider(create: (_) => WsServices()),
        Provider<DevicesServices>(create: (_) => DevicesServices()),
        ChangeNotifierProvider(create: (_) => QueueController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jammies App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color.fromARGB(255, 44, 44, 44),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 44, 44, 44),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      builder: (context, child) {
        return child!;
      },
      routes: {
        '/': (context) => AppRoot(),
        '/greeting':
            (context) => GreetingScreen(
              onContinue: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isFirstTime', false);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => RegisterScreen(),
        "/settings": (context) => const SettingsScreen(),
      },
    );
  }
}
