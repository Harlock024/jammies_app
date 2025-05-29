import 'package:flutter/material.dart';
import 'package:jammies_app/providers/auth_provider.dart';
import 'package:jammies_app/widgets/auth/signup_form.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SignUpForm(
          onRegister: (username, email, password) async {
            final authProvider = context.read<AuthProvider>();
            final success = await authProvider.register(
              username,
              email,
              password,
            );
            if (success) {
              Navigator.pushNamed(context, '/index');
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Registration failed')));
            }
          },
        ),
      ),
    );
  }
}
