import 'package:flutter/material.dart';
import 'package:jammies_app/providers/audio_player.dart';
import 'package:jammies_app/providers/sensors_provider.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatelessWidget {
  final VoidCallback onTap;

  const MiniPlayer({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final track = context.watch<AudioController>().currentTrack;

    if (track == null) return const SizedBox();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black,
          border: const Border(top: BorderSide(color: Colors.white12)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                track.coverUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[800],
                    child: const Icon(Icons.music_note, color: Colors.white70),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    track.postedBy.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.play_arrow, color: Colors.white, size: 32),
          ],
        ),
      ),
    );
  }
}
