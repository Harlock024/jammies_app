import 'package:flutter/material.dart';
import 'package:jammies_app/providers/auth_provider.dart';
import 'package:jammies_app/widgets/auth/login_form.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoginForm(
          onContinue: () {
            context.read<AuthProvider>().login();
            Navigator.pushReplacementNamed(context, '/index');
          },
        ),
      ),
    );
  }
}
