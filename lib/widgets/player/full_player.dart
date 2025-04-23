import 'package:flutter/material.dart';
import 'package:jammies_app/models/track.dart';

class FullPlayerOverlay extends StatelessWidget {
  final Track track;

  const FullPlayerOverlay({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 16),
              Image.network(track.coverUrl, width: 200, height: 200),
              const SizedBox(height: 24),
              Text(
                track.title,
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              const SizedBox(height: 8),
              Text(track.artist, style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 32),
              Icon(Icons.pause_circle_filled, color: Colors.white, size: 64),
            ],
          ),
        ),
      ),
    );
  }
}
