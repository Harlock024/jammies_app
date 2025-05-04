import 'package:flutter/material.dart';
import 'package:jammies_app/models/user.dart';

class ProfileActions extends StatelessWidget {
  final User user;

  const ProfileActions({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton(child: Text('Editar Perfil'), onPressed: () {}),
        const SizedBox(height: 12),
      ],
    );
  }
}
