import 'package:flutter/material.dart';
import 'package:jammies_app/models/user.dart';
import 'package:jammies_app/widgets/profile/profile_actions.dart';
import 'package:jammies_app/widgets/profile/profile_banner.dart';
import 'package:jammies_app/widgets/profile/profile_content.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil'), centerTitle: true),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              ProfileBanner(user: user),
              const SizedBox(height: 16.0),
              ProfileActions(user: user),
              const SizedBox(height: 16.0),
              ProfileContentTabs(),
            ]),
          ),
        ],
      ),
    );
  }
}
