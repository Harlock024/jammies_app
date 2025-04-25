import 'package:flutter/material.dart';
import 'package:jammies_app/mocks/mock_album.dart';
import 'package:jammies_app/mocks/mock_playlist.dart';
import 'package:jammies_app/mocks/mock_track.dart';
import 'package:jammies_app/widgets/album/album_card.dart';
import 'package:jammies_app/widgets/playlists/playlist_card.dart';
import 'package:jammies_app/widgets/tracks/track_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final isSearching = _query.isNotEmpty;

    final tracks =
        isSearching
            ? mockTracks
                .where(
                  (t) => t.title.toLowerCase().contains(_query.toLowerCase()),
                )
                .toList()
            : mockTracks;

    final playlists =
        isSearching
            ? mockPlaylists
                .where(
                  (p) => p.name.toLowerCase().contains(_query.toLowerCase()),
                )
                .toList()
            : mockPlaylists;

    final albums =
        isSearching
            ? mockAlbums
                .where(
                  (a) => a.title.toLowerCase().contains(_query.toLowerCase()),
                )
                .toList()
            : mockAlbums;

    final users = <dynamic>[];

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          onChanged: (val) => setState(() => _query = val.trim()),
          decoration: InputDecoration(
            hintText: 'Buscar canciones, álbumes...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
          style: const TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isSearching)
              Text('Populares', style: Theme.of(context).textTheme.titleLarge),

            if (tracks.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Tracks', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...mockTracks.map((t) => TrackCard(track: t)),
            ],

            if (playlists.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Playlists', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
                children:
                    mockPlaylists
                        .map((p) => PlaylistCard(playlist: p))
                        .toList(),
              ),
            ],

            if (albums.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Álbumes', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
                children: mockAlbums.map((a) => AlbumCard(album: a)).toList(),
              ),
            ],

            if (users.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Usuarios', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...users.map(
                (u) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(u.avatarUrl),
                  ),
                  title: Text(u.name),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
