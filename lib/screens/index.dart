import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jammies_app/models/user.dart';
import 'package:jammies_app/screens/home.dart';
import 'package:jammies_app/screens/greeting.dart';

import 'package:jammies_app/screens/library.dart';
import 'package:jammies_app/screens/profile.dart';

import 'package:jammies_app/screens/search.dart';
import 'package:jammies_app/screens/upload.dart';
import 'package:jammies_app/widgets/layout/app_layout.dart';
import 'package:jammies_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int currentIndex = 0;
  bool showProfile = false;
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.loadUserFromStorage();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> pages = [
    HomeScreen(),
    SearchScreen(),
    UploadScreen(),
    LibraryScreen(),
    // GreetingScreen(onContinue: onContinue),
  ];

  // static get onContinue => null;

  void openProfile() {
    setState(() {
      showProfile = true;
    });
    _scaffoldKey.currentState?.closeDrawer();
  }

  void goToTab(int index) {
    setState(() {
      showProfile = false;
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;

        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return AppLayout(
          user: user,
          scaffoldKey: _scaffoldKey,
          onDrawerTap: () => _scaffoldKey.currentState?.openDrawer(),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: goToTab,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Buscar",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.upload),
                label: "Upload",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music),
                label: "Biblioteca",
              ),
            ],
          ),
          onProfileTap: openProfile,
          child: showProfile ? ProfileScreen(user: user) : pages[currentIndex],
        );
      },
    );
  }
}
