// lib/screens/home.dart

import 'package:flutter/material.dart';
import 'package:jammies_app/mocks/tracks/mock_track.dart';
import 'package:jammies_app/widgets/tracks/track_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inicio')),
      body: ListView.builder(
        itemCount: mockTracks.length,
        itemBuilder: (context, index) {
          final track = mockTracks[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: TrackCard(track: track),
          );
        },
      ),
    );
  }
}
