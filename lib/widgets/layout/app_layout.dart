import 'package:flutter/material.dart';
import 'package:jammies_app/models/user.dart';
import 'package:jammies_app/widgets/player/full_player.dart';
import 'package:jammies_app/widgets/player/mini_player.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  final VoidCallback onDrawerTap;
  final VoidCallback onProfileTap;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget? bottomNavigationBar;
  final User user;
  const AppLayout({
    super.key,
    required this.child,
    required this.onDrawerTap,
    required this.onProfileTap,
    required this.scaffoldKey,
    this.bottomNavigationBar,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        backgroundColor: Color(0xFF292929),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF292929)),
              child: InkWell(
                onTap: onProfileTap,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(user.avatarUrl!, width: 48, height: 48),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(user.name, style: TextStyle(color: Colors.white)),
                        Text(
                          "Ver Perfil",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Configuración',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: ClipRRect(
            borderRadius: BorderRadius.circular(24),

            child: Image.network(user.avatarUrl!),
          ),
          onPressed: onDrawerTap,
        ),
      ),
      body: Stack(
        children: [
          child,
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MiniPlayer(
              onTap: () {
                openFullPlayer(context);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

void openFullPlayer(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => PlayerScreen(),
  );
}
