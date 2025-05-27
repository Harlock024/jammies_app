import 'package:flutter/material.dart';
import 'package:jammies_app/mocks/mock_user.dart';
import 'package:jammies_app/models/playlist.dart';
import 'package:jammies_app/models/track.dart';
import 'package:jammies_app/widgets/tracks/track_card.dart';

class PlaylistDetailsScreen extends StatefulWidget {
  final String playlistId;

  const PlaylistDetailsScreen({super.key, required this.playlistId});

  @override
  State<PlaylistDetailsScreen> createState() => _PlaylistDetailsScreenState();
}

class _PlaylistDetailsScreenState extends State<PlaylistDetailsScreen> {
  late Playlist playlist;
  late List<Track> tracks;

  @override
  void initState() {
    super.initState();

    // Datos mock para la playlist
    playlist = Playlist(
      id: widget.playlistId,
      name: 'My Playlist',
      createdBy: mockUsers[0],
      userId: mockUsers[0].id,
      description: 'My favorite songs',
      coverUrl:
          'https://i.pinimg.com/736x/27/b1/05/27b105523f4f52ce94aaa04056121b9a.jpg',
      trackCount: 10,
    );

    // Datos mock para los tracks
    tracks = [
      Track(
        id: '1',
        title: 'Test Track',
        artist: 'Test Artist',
        duration: 3.20,
        coverUrl:
            'https://i.scdn.co/image/ab67616d0000b27393c50048dce0f88071728c8c',
        album: "Test Album",
      ),
      Track(
        id: '2',
        title: 'Test Track 2',
        artist: 'Test Artist 2',
        duration: 4.20,
        coverUrl:
            'https://i.scdn.co/image/ab67616d0000b27393c50048dce0f88071728c8c',
        album: "Test Album 2",
      ),
      Track(
        id: '3',
        title: 'Test Track 3',
        artist: 'Test Artist 3',
        duration: 5.20,
        coverUrl:
            'https://i.scdn.co/image/ab67616d0000b27393c50048dce0f88071728c8c',
        album: "Test Album 3",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      playlist.coverUrl != null
                          ? Image.network(
                            playlist.coverUrl!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                          : Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.music_note, size: 40),
                          ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playlist.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Por ${playlist.createdBy.name}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${playlist.trackCount} canciones',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (playlist.description != null &&
                playlist.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(playlist.description!),
            ],
            const SizedBox(height: 24),
            Text('Tracks', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Column(
              children: tracks.map((track) => TrackCard(track: track)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
