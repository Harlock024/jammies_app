import 'package:flutter/material.dart';

import 'package:jammies_app/providers/audio_player.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isLoading = true;

  late final AudioController audioController;

  @override
  void initState() {
    super.initState();
    audioController = context.read<AudioController>();

    // Escuchar duración
    audioController.player.durationStream.listen((duration) {
      if (duration != null) {
        setState(() => _totalDuration = duration);
      }
    });

    // Escuchar posición actual
    audioController.player.positionStream.listen((position) {
      setState(() => _currentPosition = position);
    });

    // Escuchar estado de carga
    audioController.player.processingStateStream.listen((state) {
      setState(
        () =>
            _isLoading =
                state == ProcessingState.loading ||
                state == ProcessingState.buffering,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioController = context.watch<AudioController>();
    final track = audioController.currentTrack;

    if (track == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "No track selected",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    double sliderValue =
        _totalDuration.inMilliseconds == 0
            ? 0
            : _currentPosition.inMilliseconds / _totalDuration.inMilliseconds;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "My Playlist",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Portada
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  track.coverUrl,
                  width: 320,
                  height: 320,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF86CECB),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.music_note,
                        color: Colors.white70,
                        size: 80,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Info canción
            Column(
              children: [
                Text(
                  track.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  track.artist.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Slider + duración
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Slider(
                    value: sliderValue,
                    onChanged:
                        _isLoading
                            ? null
                            : (value) {
                              final newPosition = _totalDuration * value;
                              audioController.seek(newPosition);
                            },
                    activeColor: const Color(0xFF86CECB),
                    inactiveColor: Colors.white24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatDuration(_currentPosition),
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Text(
                        formatDuration(_totalDuration),
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Controles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(Icons.shuffle, color: Colors.white70, size: 28),
                  IconButton(
                    iconSize: 32,
                    icon: const Icon(Icons.skip_previous, color: Colors.white),
                    onPressed:
                        _isLoading
                            ? null
                            : () => audioController.seek(Duration.zero),
                  ),
                  IconButton(
                    iconSize: 64,
                    icon:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Color(0xFF86CECB),
                            )
                            : Icon(
                              audioController.isPlaying
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                              color: Colors.white,
                            ),
                    onPressed:
                        _isLoading
                            ? null
                            : () {
                              audioController.isPlaying
                                  ? audioController.pause()
                                  : audioController.play();
                            },
                  ),
                  IconButton(
                    iconSize: 32,
                    icon: const Icon(Icons.skip_next, color: Colors.white),
                    onPressed:
                        _isLoading
                            ? null
                            : () => audioController.seek(_totalDuration),
                  ),
                  const Icon(Icons.repeat, color: Colors.white70, size: 28),
                ],
              ),
            ),

            // Devices
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.speaker_sharp,
                        color: Colors.white70,
                        size: 28,
                      ),
                      Text(
                        "Devices",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
