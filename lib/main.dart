import 'package:flutter/material.dart';
import 'package:jammies_app/AppRoot.dart';
import 'package:jammies_app/models/user.dart';
import 'package:jammies_app/providers/audio_player.dart';
import 'package:jammies_app/providers/auth_provider.dart';
import 'package:jammies_app/providers/user_provider.dart';
import 'package:jammies_app/screens/auth/login.dart';
import 'package:jammies_app/screens/auth/register.dart';
import 'package:jammies_app/screens/greeting.dart';

import 'package:jammies_app/screens/index.dart';
import 'package:jammies_app/screens/settings/settings.dart';
import 'package:jammies_app/screens/profile.dart';
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
      ],
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

      // theme: ThemeData(
      //   primarySwatch: Colors.teal,
      //   scaffoldBackgroundColor: const Color.fromARGB(255, 44, 44, 44),
      //   appBarTheme: const AppBarTheme(
      //     backgroundColor: Color.fromARGB(255, 44, 44, 44),
      //     elevation: 0,
      //     iconTheme: IconThemeData(color: Colors.white),
      //     titleTextStyle: TextStyle(
      //       color: Colors.white,
      //       fontSize: 20,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      // ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      builder: (context, child) {
        return child!;
      },
      routes: {
        '/': (context) => AppRoot(isFirstTime: isFirstTime),
        '/greeting':
            (context) => GreetingScreen(
              onContinue: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
        '/login': (context) => const LoginScreen(),
        '/index': (context) => IndexPage(),
        '/register': (context) => RegisterScreen(),
        "/settings": (context) => const SettingsScreen(),
        // "/my-profile":
        //     (context) => ProfileScreen(
        //       user: User(
        //         id: '1',
        //         name: 'Harlock024',
        //         email: 'harlock024@gmail.com',
        //         avatarUrl:
        //             'https://res.cloudinary.com/drdefvojb/image/upload/v1724779733/proyects_uv/k3o6eoted3lma2uzgbme.png',
        //         bio: 'hello how are u i am da water i need help glugluglu',
        //       ),
        //     ),
      },
    );
  }
}
