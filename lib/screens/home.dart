import 'package:flutter/material.dart';
import 'package:jammies_app/models/track.dart';
import 'package:jammies_app/widgets/tracks/track_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TrackCard(
            track: Track(
              id: '1',
              title: 'Track Title',
              artist: 'Artist Name',
              album: 'Album Name',
              duration: '3:10',
              coverUrl:
                  "https://i.scdn.co/image/ab67616d0000b27393c50048dce0f88071728c8c",
            ),
          ),
        ],
      ),
    );
  }
}
