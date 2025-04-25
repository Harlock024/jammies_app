import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jammies_app/mocks/mock_playlist.dart';
import 'package:jammies_app/widgets/playlists/playlist_card.dart';

class PlaylistGrid extends StatelessWidget {
  const PlaylistGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(8),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      physics: const NeverScrollableScrollPhysics(),
      children:
          mockPlaylists
              .map((playlist) => PlaylistCard(playlist: playlist))
              .toList(),
    );
  }
}
