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
          onContinue: (email, password) async {
            final authProvider = context.read<AuthProvider>();
            final succces = await authProvider.login(email, password);
            if (succces) {
              Navigator.pushReplacementNamed(context, '/index');
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Login fallido')));
            }
          },
        ),
      ),
    );
  }
}
