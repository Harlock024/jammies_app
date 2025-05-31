import 'package:flutter/material.dart';
import 'package:jammies_app/mocks/mock_album.dart';
import 'package:jammies_app/models/playlist.dart';
import 'package:jammies_app/services/playlist_services.dart';
import 'package:jammies_app/widgets/album/album_card.dart';
import 'package:jammies_app/widgets/playlists/playlist_card.dart';
import 'package:jammies_app/widgets/tracks/track_card.dart';

import 'package:jammies_app/models/track.dart';
import 'package:jammies_app/services/track_services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final PlaylistServices _playlistService = PlaylistServices();
  final TrackService _trackService = TrackService();

  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final isSearching = _query.isNotEmpty;

    final albums =
        isSearching
            ? mockAlbums
                .where(
                  (a) => a.title.toLowerCase().contains(_query.toLowerCase()),
                )
                .toList()
            : mockAlbums;

    final users = <dynamic>[];

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _controller,
            onChanged: (val) => setState(() => _query = val.trim()),
            decoration: InputDecoration(
              hintText: 'Buscar canciones, álbumes...',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey[400]),
              suffixIcon:
                  _query.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      )
                      : null,
            ),
            style: const TextStyle(fontSize: 18),
          ),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Tracks'),
              Tab(text: 'Playlists'),
              Tab(text: 'Álbumes'),
              Tab(text: 'Usuarios'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            /// Tracks Tab (using FutureBuilder)
            FutureBuilder<List<Track>>(
              future: _trackService.fetchTracks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final tracks = snapshot.data ?? [];

                if (tracks.isEmpty) {
                  return const Center(
                    child: Text('No hay canciones disponibles'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tracks.length,
                  itemBuilder: (context, index) {
                    final track = tracks[index];
                    return TrackCard(track: track);
                  },
                );
              },
            ),

            /// Playlists Tab
            FutureBuilder<List<Playlist>>(
              future: _playlistService.fetchPlaylists(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final playlists = snapshot.data ?? [];

                if (playlists.isEmpty) {
                  return const Center(
                    child: Text('No hay playlists disponibles'),
                  );
                }

                return GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1,
                  children:
                      playlists.map((p) => PlaylistCard(playlist: p)).toList(),
                );
              },
            ),

            /// Albums Tab
            GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
              children: albums.map((a) => AlbumCard(album: a)).toList(),
            ),

            /// Users Tab (placeholder)
            users.isEmpty
                ? const Center(child: Text('No users found'))
                : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.avatarUrl),
                      ),
                      title: Text(user.name),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
