import 'package:flutter/material.dart';
import 'package:jammies_app/screens/settings/settings_section_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuracion')),
      body: ListView(
        children: const [
          SettingsSectionTile(title: 'General'),
          ListTile(title: Text('Notifications')),
          ListTile(title: Text('Language')),
          ListTile(title: Text('Devices')),
          
          SettingsSectionTile(title: 'Account'),
          ListTile(title: Text('Profile')),
          ListTile(title: Text('Security')),

        ],
      ),
    );
  }
}
