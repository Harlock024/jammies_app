import 'package:flutter/material.dart';
import 'package:jammies_app/models/user.dart';

class ProfileBanner extends StatelessWidget {
  final User user;

  const ProfileBanner({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(
            user.avatarUrl ??
                'https://ui-avatars.com/api/?name=${user.name}&background=0D8ABC&color=fff',
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.username!,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(user.email, style: TextStyle(color: Colors.grey[600])),
        if (user.bio != null && user.bio!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            user.bio!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ],
    );
  }
}
