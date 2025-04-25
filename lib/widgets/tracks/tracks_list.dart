import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jammies_app/mocks/mock_track.dart';
import 'package:jammies_app/widgets/tracks/track_card.dart';

class TracksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: mockTracks.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TrackCard(track: mockTracks[index]),
          );
        },
      ),
    );
  }
}
