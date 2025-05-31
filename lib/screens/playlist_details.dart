import 'package:flutter/material.dart';
import 'package:jammies_app/models/playlist.dart';
import 'package:jammies_app/models/track.dart';
import 'package:jammies_app/services/playlist_services.dart';
import 'package:jammies_app/widgets/tracks/track_card.dart';

class PlaylistDetailsScreen extends StatefulWidget {
  final Playlist playlist;

  const PlaylistDetailsScreen({super.key, required this.playlist});

  @override
  State<PlaylistDetailsScreen> createState() => _PlaylistDetailsScreenState();
}

class _PlaylistDetailsScreenState extends State<PlaylistDetailsScreen> {
  final PlaylistServices _playlistServices = PlaylistServices();

  List<Track> tracks = [];

  Future<void> _fetchTracks() async {
    tracks = await _playlistServices.fetchTracksInPlaylist(widget.playlist.id);
    setState(() {
      tracks = tracks;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTracks();
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
                      widget.playlist.coverUrl != null
                          ? Image.network(
                            widget.playlist.coverUrl!,
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
                        widget.playlist.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Por ${widget.playlist.createdBy}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
            if (widget.playlist.description != null &&
                widget.playlist.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(widget.playlist.description!, selectionColor: Colors.white),
            ],
            const SizedBox(height: 24),
            Text('Tracks', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Column(
              children:
                  tracks.map((track) {
                    return TrackCard(
                      track: track,
                      playlistId: widget.playlist.id,
                      onRemoved:
                          () => setState(() {
                            tracks.removeWhere((t) => t.id == track.id);
                          }),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
