import 'package:flutter/material.dart';
import 'package:jammies_app/models/playlist.dart';
import 'package:jammies_app/screens/playlist_details.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;

  const PlaylistCard({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => PlaylistDetailsScreen(playlistId: playlist.id),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Imagen de la portada de la playlist
          Image.network(
            playlist.coverUrl!,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          // Nombre de la playlist
          Text(
            playlist.name,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            playlist.createdBy.name!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
