import 'package:flutter/material.dart';
import 'package:jammies_app/models/album.dart';
import 'package:jammies_app/screens/album_details.dart';

class AlbumCard extends StatelessWidget {
  final Album album;

  const AlbumCard({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlbumDetailsScreen(album: album),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              album.coverUrl,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            album.title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            album.artist,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
