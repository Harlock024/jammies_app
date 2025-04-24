import 'package:flutter/material.dart';
import 'package:jammies_app/models/user.dart';

import 'package:jammies_app/screens/home.dart';
import 'package:jammies_app/screens/search.dart';
import 'package:jammies_app/screens/library.dart';
import 'package:jammies_app/widgets/layout/app_layout.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final user = User(
    id: "1",
    name: 'Harlock024',
    email: 'harlock024@gmail.com',
    avatarUrl:
        "https://res.cloudinary.com/drdefvojb/image/upload/v1724779733/proyects_uv/k3o6eoted3lma2uzgbme.png",
  );

  final List<Widget> pages = [HomeScreen(), SearchScreen(), LibraryScreen()];

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      scaffoldKey: _scaffoldKey,
      onDrawerTap: () => _scaffoldKey.currentState?.openDrawer(),
      child: pages[currentIndex],
      user: User(
        id: "1",
        name: 'Harlock024',
        email: 'harlock024@gmail.com',
        avatarUrl:
            "https://res.cloudinary.com/drdefvojb/image/upload/v1724779733/proyects_uv/k3o6eoted3lma2uzgbme.png",
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
