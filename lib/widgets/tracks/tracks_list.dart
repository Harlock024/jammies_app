import 'package:flutter/material.dart';
import 'package:jammies_app/models/track.dart';
import 'package:jammies_app/services/track_services.dart';
import 'package:jammies_app/widgets/tracks/track_card.dart';

class TrackList extends StatelessWidget {
  TrackList({super.key});
  final TrackService trackService = TrackService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tracks')),
      body: FutureBuilder<List<Track>>(
        future: trackService.fetchTracks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final tracks = snapshot.data ?? [];

          if (tracks.isEmpty) {
            return const Center(child: Text('No hay canciones disponibles'));
          }

          return ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];
              return TrackCard(track: track);
            },
          );
        },
      ),
    );
  }
}
