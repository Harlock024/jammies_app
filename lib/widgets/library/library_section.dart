import 'package:flutter/material.dart';
import 'package:jammies_app/widgets/tracks/tracks_list.dart';
import 'package:jammies_app/widgets/album/album_card.dart';
import 'package:jammies_app/widgets/playlists/playlist_list.dart';
import 'package:jammies_app/models/library_type.dart'; // donde está el enum LibraryType

class LibrarySection extends StatelessWidget {
  final LibraryType type;

  const LibrarySection({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Tracks'),
              Tab(text: 'Álbumes'),
              Tab(text: 'Playlists'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _TracksTab(type: type),
                _AlbumsTab(type: type),
                _PlaylistsTab(type: type),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TracksTab extends StatelessWidget {
  final LibraryType type;

  const _TracksTab({required this.type});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Tracks ${type == LibraryType.created ? 'creados' : 'guardados'}',
      ),
    );
  }
}

class _AlbumsTab extends StatelessWidget {
  final LibraryType type;

  const _AlbumsTab({required this.type});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Álbumes ${type == LibraryType.created ? 'creados' : 'guardados'}',
      ),
    );
  }
}

class _PlaylistsTab extends StatelessWidget {
  final LibraryType type;

  const _PlaylistsTab({required this.type});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Playlists ${type == LibraryType.created ? 'creadas' : 'guardadas'}',
      ),
    );
  }
}
