import 'package:flutter/material.dart';
import 'package:jammies_app/widgets/auth/signup_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SignUpForm(
          onRegister: () {
            Navigator.pushNamed(context, '/login');
          },
        ),
      ),
    );
  }
}
