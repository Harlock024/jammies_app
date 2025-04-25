import 'package:flutter/material.dart';
import 'package:jammies_app/models/track.dart';

class TrackCard extends StatelessWidget {
  final Track track;

  const TrackCard({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 5, // Da un efecto de sombra para resaltar la tarjeta
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                track.coverUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),

                  Text(
                    track.artist,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),

                  Text(
                    _formatDuration(track.duration),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.play_arrow, size: 32),
              onPressed: () {
                // Implement play functionality here
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(String duration) {
    final int minutes = int.parse(duration.split(':')[0]);
    final int seconds = int.parse(duration.split(':')[1]);
    return '$minutes min ${seconds.toString().padLeft(2, '0')} sec';
  }
}
