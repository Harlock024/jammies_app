import 'package:flutter/material.dart';
import 'package:jammies_app/models/track.dart';

import "package:jammies_app/screens/home.dart";
import 'package:jammies_app/screens/library.dart';
import 'package:jammies_app/screens/search.dart';
import 'package:jammies_app/widgets/player/full_player.dart';
import 'package:jammies_app/widgets/player/mini_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'App con Tabs', home: IndexPage());
  }
}

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int currentIndex = 0;

  final List<Widget> pages = [HomeScreen(), SearchScreen(), LibraryScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[currentIndex], // página principal
          Positioned(
            left: 0,
            right: 0,
            bottom: 0, // espacio sobre el BottomNavigationBar
            child: MiniPlayer(
              track: Track(
                id: '1',
                title: 'Test Track',
                artist: 'Test Artist',
                album: 'Test Album',
                duration: '3:20',
                coverUrl:
                    'https://i.scdn.co/image/ab67616d0000b27393c50048dce0f88071728c8c',
              ),
              onTap: () => openFullPlayer(context),
            ),
          ),
        ],
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

  void openFullPlayer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => FullPlayerOverlay(
            track: Track(
              id: '1',
              title: 'Test Track',
              artist: 'Test Artist',
              album: 'Test Album',
              duration: '3:20',
              coverUrl:
                  'https://i.scdn.co/image/ab67616d0000b27393c50048dce0f88071728c8c',
            ),
          ),
    );
  }
}
