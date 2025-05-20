import 'package:flutter/material.dart';
import 'package:jammies_app/models/album.dart';
import 'package:jammies_app/models/track.dart';
import 'package:jammies_app/widgets/tracks/track_card.dart';

class AlbumDetailsScreen extends StatefulWidget {
  final Album album;

  const AlbumDetailsScreen({super.key, required this.album});

  @override
  State<AlbumDetailsScreen> createState() => _AlbumDetailsScreenState();
}

class _AlbumDetailsScreenState extends State<AlbumDetailsScreen> {
  late Album album;
  late List<Track> tracks;

  @override
  void initState() {
    super.initState();
    album = widget.album;

    tracks = [
      Track(
        id: '1',
        title: 'Test Track',
        artist: 'Test Artist',
        duration: 3.20,
        coverUrl:
            'https://i.scdn.co/image/ab67616d0000b27393c50048dce0f88071728c8c',
        audioUrl: '../music/Consume.mp3',
        album: album.title,
      ),
      Track(
        id: '2',
        title: 'Test Track 2',
        artist: 'Test Artist 2',
        duration: 4.20,
        coverUrl:
            'https://i.scdn.co/image/ab67616d0000b27393c50048dce0f88071728c8c',
        audioUrl: '../music/Consume.mp3',
        album: album.title,
      ),
      Track(
        id: '3',
        title: 'Test Track 3',
        artist: 'Test Artist 3',
        duration: 5.20,
        coverUrl:
            'https://i.scdn.co/image/ab67616d0000b27393c50048dce0f88071728c8c',
        audioUrl: '../music/Consume.mp3',
        album: album.title,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(
                  album.coverUrl,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        album.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        album.artist,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
