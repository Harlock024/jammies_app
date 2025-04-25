import 'package:flutter/material.dart';
import 'package:jammies_app/models/user.dart';
import 'package:jammies_app/screens/home.dart';
import 'package:jammies_app/screens/search.dart';
import 'package:jammies_app/screens/library.dart';
import 'package:jammies_app/widgets/navigation/tabs_button.dart';

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
    return TabbedLayout(
      currentIndex: currentIndex,
      onTabChange: (i) => setState(() => currentIndex = i),
      pages: pages,
      scaffoldKey: _scaffoldKey,
      user: user,
    );
  }
}
