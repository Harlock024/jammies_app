import 'package:flutter/material.dart';
import 'package:jammies_app/models/user.dart';
import 'package:jammies_app/screens/home.dart';
import 'package:jammies_app/screens/greeting.dart';

import 'package:jammies_app/screens/library.dart';
import 'package:jammies_app/screens/profile.dart';


import 'package:jammies_app/screens/search.dart';
import 'package:jammies_app/screens/upload.dart';
import 'package:jammies_app/widgets/layout/app_layout.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int currentIndex = 0;
  bool showProfile = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final user = User(
    id: "1",
    name: 'Harlock024',
    email: 'harlock024@gmail.com',
    avatarUrl:
        "https://res.cloudinary.com/drdefvojb/image/upload/v1724779733/proyects_uv/k3o6eoted3lma2uzgbme.png",
  );

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
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Buscar"),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: "Upload"),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: "Biblioteca",
          ),
        ],
      ),
      onProfileTap: openProfile,
      child: showProfile ? ProfileScreen(user: user) : pages[currentIndex],
    );
  }
}
